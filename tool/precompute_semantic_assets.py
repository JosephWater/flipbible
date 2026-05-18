import json
import os
import sqlite3
import urllib.error
import urllib.request
import zipfile
from pathlib import Path

import numpy as np


ROOT = Path(__file__).resolve().parents[1]
BUNDLED_DIR = ROOT / "assets" / "bundled"
SAMPLES_DIR = ROOT / "assets" / "samples"
TRANSLATION_ID = "builtin_cn_demo"
TOP_K = 20

EMBED_BASE_URL = os.environ.get(
    "FLIPBIBLE_EMBEDDING_BASE_URL",
    "https://dashscope.aliyuncs.com/compatible-mode/v1",
).rstrip("/")
EMBED_API_KEY = os.environ.get("FLIPBIBLE_EMBEDDING_API_KEY", "").strip()
EMBED_MODEL = os.environ.get("FLIPBIBLE_EMBEDDING_MODEL", "text-embedding-v4")
EMBED_BATCH_SIZE = int(os.environ.get("FLIPBIBLE_EMBED_BATCH_SIZE", "10"))
SIMILARITY_BLOCK_SIZE = int(os.environ.get("FLIPBIBLE_SIM_BLOCK_SIZE", "256"))

MANIFEST = {
    "id": TRANSLATION_ID,
    "title": "和合本圣经",
    "language": "zh-CN",
    "version": "1.1.0-cus",
    "copyright": "和合本圣经属于公有领域，可自由使用。",
    "hasSearchIndex": False,
    "hasSemanticIndex": True,
}


def table_columns(cursor: sqlite3.Cursor, table_name: str) -> set[str]:
    rows = cursor.execute(f"PRAGMA table_info({table_name})").fetchall()
    return {row[1] for row in rows}


def request_embeddings(texts: list[str]) -> np.ndarray:
    if not EMBED_API_KEY:
        raise RuntimeError("FLIPBIBLE_EMBEDDING_API_KEY is required to build missing embeddings.")

    payload = json.dumps(
        {
            "model": EMBED_MODEL,
            "input": texts,
        }
    ).encode("utf-8")
    request = urllib.request.Request(
        f"{EMBED_BASE_URL}/embeddings",
        data=payload,
        headers={
            "Content-Type": "application/json",
            "Authorization": f"Bearer {EMBED_API_KEY}",
        },
        method="POST",
    )

    try:
        with urllib.request.urlopen(request, timeout=120) as response:
            decoded = json.loads(response.read().decode("utf-8"))
    except urllib.error.HTTPError as exc:
        detail = exc.read().decode("utf-8", errors="replace")
        raise RuntimeError(f"Embedding API HTTP {exc.code}: {detail}") from exc

    data = decoded.get("data")
    if not isinstance(data, list) or len(data) != len(texts):
        raise RuntimeError("Embedding API returned an unexpected payload size.")
    ordered = sorted(data, key=lambda item: item.get("index", 0))
    return np.asarray(
        [[float(value) for value in item["embedding"]] for item in ordered],
        dtype=np.float32,
    )


def ensure_translation_schema(cursor: sqlite3.Cursor) -> None:
    columns = table_columns(cursor, "translations")
    if "has_semantic_index" not in columns:
        cursor.execute(
            """
            ALTER TABLE translations
            ADD COLUMN has_semantic_index INTEGER NOT NULL DEFAULT 0
            """
        )


def ensure_verse_index(cursor: sqlite3.Cursor) -> dict[tuple[int, int, int], int]:
    columns = table_columns(cursor, "verses")
    if "verse_index" not in columns:
        cursor.execute(
            """
            ALTER TABLE verses
            ADD COLUMN verse_index INTEGER
            """
        )

    verse_rows = cursor.execute(
        """
        SELECT book_id, chapter, verse
        FROM verses
        WHERE translation_id = ?
        ORDER BY book_id, chapter, verse
        """,
        (TRANSLATION_ID,),
    ).fetchall()
    verse_index_map = {
        (book_id, chapter, verse): index
        for index, (book_id, chapter, verse) in enumerate(verse_rows)
    }
    cursor.executemany(
        """
        UPDATE verses
        SET verse_index = ?
        WHERE translation_id = ? AND book_id = ? AND chapter = ? AND verse = ?
        """,
        [
            (index, TRANSLATION_ID, book_id, chapter, verse)
            for (book_id, chapter, verse), index in verse_index_map.items()
        ],
    )
    return verse_index_map


def fetch_raw_embeddings(
    cursor: sqlite3.Cursor,
    verse_index_map: dict[tuple[int, int, int], int],
) -> dict[int, np.ndarray]:
    columns = table_columns(cursor, "verse_embeddings")
    embeddings: dict[int, np.ndarray] = {}

    if not columns:
        return embeddings

    if {"book_id", "chapter", "verse", "vector_blob", "dim"}.issubset(columns):
        rows = cursor.execute(
            """
            SELECT book_id, chapter, verse, dim, vector_blob
            FROM verse_embeddings
            WHERE translation_id = ?
            """,
            (TRANSLATION_ID,),
        ).fetchall()
        for book_id, chapter, verse, dim, vector_blob in rows:
          verse_index = verse_index_map[(book_id, chapter, verse)]
          embeddings[verse_index] = np.frombuffer(
              vector_blob,
              dtype=np.float32,
              count=dim,
          ).astype(np.float32, copy=True)
        return embeddings

    if {"verse_index", "vector_blob", "dim", "vector_encoding"}.issubset(columns):
        rows = cursor.execute(
            """
            SELECT verse_index, dim, vector_encoding, vector_blob
            FROM verse_embeddings
            WHERE translation_id = ?
            """,
            (TRANSLATION_ID,),
        ).fetchall()
        for verse_index, dim, encoding, vector_blob in rows:
            if encoding == "i8n":
                quantized = np.frombuffer(vector_blob, dtype=np.int8, count=dim).astype(
                    np.float32
                )
                embeddings[int(verse_index)] = quantized / 127.0
            else:
                embeddings[int(verse_index)] = np.frombuffer(
                    vector_blob,
                    dtype=np.float32,
                    count=dim,
                ).astype(np.float32, copy=True)
    return embeddings


def build_missing_embeddings(
    cursor: sqlite3.Cursor,
    existing: dict[int, np.ndarray],
) -> dict[int, np.ndarray]:
    verse_rows = cursor.execute(
        """
        SELECT verse_index, text
        FROM verses
        WHERE translation_id = ?
        ORDER BY verse_index
        """,
        (TRANSLATION_ID,),
    ).fetchall()
    missing = [
        (verse_index, text)
        for verse_index, text in verse_rows
        if verse_index not in existing
    ]

    for start in range(0, len(missing), EMBED_BATCH_SIZE):
        batch = missing[start : start + EMBED_BATCH_SIZE]
        vectors = request_embeddings([text for _, text in batch])
        for (verse_index, _), vector in zip(batch, vectors):
            existing[int(verse_index)] = vector
        print(
            f"Built missing embeddings {start + 1}-{start + len(batch)} / {len(missing)}"
        )

    return existing


def quantize_normalized_embeddings(
    embeddings: dict[int, np.ndarray],
    total_verses: int,
) -> tuple[np.ndarray, list[tuple[str, int, int, str, bytes]]]:
    sample = next(iter(embeddings.values()), None)
    if sample is None:
        raise RuntimeError("No embeddings were available to compact.")

    dim = int(sample.shape[0])
    matrix = np.zeros((total_verses, dim), dtype=np.float32)
    for verse_index, vector in embeddings.items():
        matrix[verse_index] = vector

    norms = np.linalg.norm(matrix, axis=1, keepdims=True)
    norms[norms == 0] = 1.0
    normalized = matrix / norms
    quantized = np.clip(np.round(normalized * 127.0), -127, 127).astype(np.int8)

    rows = [
        (
            TRANSLATION_ID,
            verse_index,
            dim,
            "i8n",
            quantized[verse_index].tobytes(),
        )
        for verse_index in range(total_verses)
    ]
    return normalized, rows


def build_neighbor_rows_from_existing(
    cursor: sqlite3.Cursor,
    verse_index_map: dict[tuple[int, int, int], int],
) -> dict[int, list[int]]:
    columns = table_columns(cursor, "verse_semantic_neighbors")

    if {"source_verse_index", "neighbor_indices_blob"}.issubset(columns):
        rows = cursor.execute(
            """
            SELECT source_verse_index, neighbor_indices_blob
            FROM verse_semantic_neighbors
            WHERE translation_id = ?
            ORDER BY source_verse_index
            """,
            (TRANSLATION_ID,),
        ).fetchall()
        if rows:
            return {
                int(source_verse_index): list(
                    np.frombuffer(neighbor_indices_blob, dtype="<u2")
                )
                for source_verse_index, neighbor_indices_blob in rows
            }

    if {
        "book_id",
        "chapter",
        "verse",
        "rank",
        "neighbor_book_id",
        "neighbor_chapter",
        "neighbor_verse",
    }.issubset(columns):
        rows = cursor.execute(
            """
            SELECT book_id, chapter, verse, rank,
                   neighbor_book_id, neighbor_chapter, neighbor_verse
            FROM verse_semantic_neighbors
            WHERE translation_id = ?
            ORDER BY book_id, chapter, verse, rank
            """,
            (TRANSLATION_ID,),
        ).fetchall()
        if rows:
            neighbor_map: dict[int, list[int]] = {}
            for (
                book_id,
                chapter,
                verse,
                rank,
                neighbor_book_id,
                neighbor_chapter,
                neighbor_verse,
            ) in rows:
                source_index = verse_index_map[(book_id, chapter, verse)]
                neighbor_index = verse_index_map[
                    (neighbor_book_id, neighbor_chapter, neighbor_verse)
                ]
                neighbor_map.setdefault(source_index, [])
                neighbor_map[source_index].append(neighbor_index)
            return neighbor_map

    return {}


def build_neighbor_rows_from_embeddings(normalized: np.ndarray) -> dict[int, list[int]]:
    neighbor_map: dict[int, list[int]] = {}
    total = normalized.shape[0]

    for start in range(0, total, SIMILARITY_BLOCK_SIZE):
        end = min(start + SIMILARITY_BLOCK_SIZE, total)
        similarity_block = normalized[start:end] @ normalized.T
        for local_index in range(end - start):
            similarity_block[local_index, start + local_index] = -np.inf

        top_indices = np.argpartition(similarity_block, -TOP_K, axis=1)[:, -TOP_K:]
        top_scores = np.take_along_axis(similarity_block, top_indices, axis=1)
        sorted_order = np.argsort(-top_scores, axis=1)
        sorted_indices = np.take_along_axis(top_indices, sorted_order, axis=1)

        for local_index, indices_row in enumerate(sorted_indices):
            source_verse_index = start + local_index
            neighbor_map[source_verse_index] = [int(value) for value in indices_row]
        print(f"Computed compact neighbors for verses {start + 1}-{end} / {total}")

    return neighbor_map


def pack_neighbor_rows(neighbor_map: dict[int, list[int]]) -> list[tuple[str, int, bytes]]:
    rows: list[tuple[str, int, bytes]] = []
    for source_verse_index in sorted(neighbor_map.keys()):
        neighbors = np.asarray(neighbor_map[source_verse_index], dtype="<u2")
        rows.append(
            (
                TRANSLATION_ID,
                source_verse_index,
                neighbors.tobytes(),
            )
        )
    return rows


def rebuild_compact_tables(
    cursor: sqlite3.Cursor,
    embedding_rows: list[tuple[str, int, int, str, bytes]],
    neighbor_rows: list[tuple[str, int, bytes]],
) -> None:
    cursor.executescript(
        """
        DROP TABLE IF EXISTS verse_embeddings_compact;
        DROP TABLE IF EXISTS verse_semantic_neighbors_compact;

        CREATE TABLE verse_embeddings_compact (
            translation_id TEXT NOT NULL,
            verse_index INTEGER NOT NULL,
            dim INTEGER NOT NULL,
            vector_encoding TEXT NOT NULL,
            vector_blob BLOB NOT NULL,
            PRIMARY KEY (translation_id, verse_index)
        ) WITHOUT ROWID;

        CREATE TABLE verse_semantic_neighbors_compact (
            translation_id TEXT NOT NULL,
            source_verse_index INTEGER NOT NULL,
            neighbor_indices_blob BLOB NOT NULL,
            PRIMARY KEY (translation_id, source_verse_index)
        ) WITHOUT ROWID;
        """
    )

    cursor.executemany(
        """
        INSERT INTO verse_embeddings_compact (
            translation_id, verse_index, dim, vector_encoding, vector_blob
        )
        VALUES (?, ?, ?, ?, ?)
        """,
        embedding_rows,
    )
    cursor.executemany(
        """
        INSERT INTO verse_semantic_neighbors_compact (
            translation_id, source_verse_index, neighbor_indices_blob
        )
        VALUES (?, ?, ?)
        """,
        neighbor_rows,
    )

    cursor.executescript(
        """
        DROP TABLE IF EXISTS verse_embeddings;
        DROP TABLE IF EXISTS verse_semantic_neighbors;
        ALTER TABLE verse_embeddings_compact RENAME TO verse_embeddings;
        ALTER TABLE verse_semantic_neighbors_compact RENAME TO verse_semantic_neighbors;

        CREATE INDEX IF NOT EXISTS idx_verses_translation_index
            ON verses (translation_id, verse_index);
        CREATE INDEX IF NOT EXISTS idx_verse_embeddings_translation
            ON verse_embeddings (translation_id, verse_index);
        CREATE INDEX IF NOT EXISTS idx_verse_neighbors_translation
            ON verse_semantic_neighbors (translation_id, source_verse_index);
        """
    )


def update_translation_metadata(cursor: sqlite3.Cursor) -> None:
    cursor.execute(
        """
        UPDATE translations
        SET title = ?, language = ?, version = ?, copyright = ?,
            has_search_index = ?, has_semantic_index = 1
        WHERE id = ?
        """,
        (
            MANIFEST["title"],
            MANIFEST["language"],
            MANIFEST["version"],
            MANIFEST["copyright"],
            1 if MANIFEST["hasSearchIndex"] else 0,
            TRANSLATION_ID,
        ),
    )


def compact_semantic_assets(db_path: Path) -> None:
    conn = sqlite3.connect(db_path)
    try:
        cursor = conn.cursor()
        ensure_translation_schema(cursor)
        verse_index_map = ensure_verse_index(cursor)
        conn.commit()

        embeddings = fetch_raw_embeddings(cursor, verse_index_map)
        embeddings = build_missing_embeddings(cursor, embeddings)
        normalized, embedding_rows = quantize_normalized_embeddings(
            embeddings=embeddings,
            total_verses=len(verse_index_map),
        )

        neighbor_map = build_neighbor_rows_from_existing(cursor, verse_index_map)
        if not neighbor_map:
            neighbor_map = build_neighbor_rows_from_embeddings(normalized)

        rebuild_compact_tables(
            cursor,
            embedding_rows,
            pack_neighbor_rows(neighbor_map),
        )
        update_translation_metadata(cursor)
        conn.commit()
        cursor.execute("VACUUM")
    finally:
        conn.close()


def create_bundle(bundle_path: Path, db_path: Path, manifest_path: Path) -> None:
    if bundle_path.exists():
        bundle_path.unlink()
    with zipfile.ZipFile(bundle_path, "w", compression=zipfile.ZIP_DEFLATED) as archive:
        archive.write(manifest_path, arcname="manifest.json")
        archive.write(db_path, arcname="content.sqlite")


def main() -> None:
    manifest_path = BUNDLED_DIR / "builtin_manifest.json"
    db_path = BUNDLED_DIR / "builtin_content.sqlite"
    sample_bundle_path = SAMPLES_DIR / "flipbible_demo_bundle.flipbible"
    sample_bundle_v2_manifest_path = SAMPLES_DIR / "flipbible_demo_bundle_v2_manifest.json"
    sample_bundle_v2_path = SAMPLES_DIR / "flipbible_demo_bundle_v2.flipbible"

    if not db_path.exists():
        raise FileNotFoundError(f"Bundled database not found: {db_path}")

    BUNDLED_DIR.mkdir(parents=True, exist_ok=True)
    SAMPLES_DIR.mkdir(parents=True, exist_ok=True)

    manifest_path.write_text(
        json.dumps(MANIFEST, ensure_ascii=False, indent=2),
        encoding="utf-8",
    )
    compact_semantic_assets(db_path)
    create_bundle(sample_bundle_path, db_path, manifest_path)

    sample_bundle_v2_manifest = dict(MANIFEST)
    sample_bundle_v2_manifest["version"] = "2.0.0-cus"
    sample_bundle_v2_manifest_path.write_text(
        json.dumps(sample_bundle_v2_manifest, ensure_ascii=False, indent=2),
        encoding="utf-8",
    )
    create_bundle(sample_bundle_v2_path, db_path, sample_bundle_v2_manifest_path)

    print(f"Compacted semantic assets in {db_path}")
    print(f"Updated bundle {sample_bundle_path}")
    print(f"Updated bundle {sample_bundle_v2_path}")


if __name__ == "__main__":
    main()
