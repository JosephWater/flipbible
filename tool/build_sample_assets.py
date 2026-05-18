import json
import os
import re
import sqlite3
import zipfile
from dataclasses import dataclass
from html import unescape
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
ASSETS_DIR = ROOT / "assets"
BUNDLED_DIR = ASSETS_DIR / "bundled"
SAMPLES_DIR = ASSETS_DIR / "samples"
SOURCE_DIR = Path(
    os.environ.get("FLIPBIBLE_SOURCE_DIR", r"D:\鍦ｇ粡\bible-cus\CUS"),
)
TRANSLATION_ID = "builtin_cn_demo"


@dataclass(frozen=True)
class BookSpec:
    id: int
    stems: tuple[str, ...]
    testament: str
    expected_chapters: int


BOOK_SPECS = [
    BookSpec(1, ("Genesis",), "OT", 50),
    BookSpec(2, ("Exodus",), "OT", 40),
    BookSpec(3, ("Leviticus",), "OT", 27),
    BookSpec(4, ("Numbers",), "OT", 36),
    BookSpec(5, ("Deuteronomy",), "OT", 34),
    BookSpec(6, ("Joshua",), "OT", 24),
    BookSpec(7, ("Judges",), "OT", 21),
    BookSpec(8, ("Ruth",), "OT", 4),
    BookSpec(9, ("1Samuel",), "OT", 31),
    BookSpec(10, ("2Samuel",), "OT", 24),
    BookSpec(11, ("1Kings",), "OT", 22),
    BookSpec(12, ("2Kings",), "OT", 25),
    BookSpec(13, ("1Chronicles",), "OT", 29),
    BookSpec(14, ("2Chronicles",), "OT", 36),
    BookSpec(15, ("Ezra",), "OT", 10),
    BookSpec(16, ("Nehemiah",), "OT", 13),
    BookSpec(17, ("Esther",), "OT", 10),
    BookSpec(18, ("Job",), "OT", 42),
    BookSpec(
        19,
        (
            "Psalms-Book1",
            "Psalms-Book2",
            "Psalms-Book3",
            "Psalms-Book4",
            "Psalms-Book5",
        ),
        "OT",
        150,
    ),
    BookSpec(20, ("Proverbs",), "OT", 31),
    BookSpec(21, ("Ecclesiastes",), "OT", 12),
    BookSpec(22, ("Song-of-Solomon",), "OT", 8),
    BookSpec(23, ("Isaiah",), "OT", 66),
    BookSpec(24, ("Jeremiah",), "OT", 52),
    BookSpec(25, ("Lamentations",), "OT", 5),
    BookSpec(26, ("Ezekiel",), "OT", 48),
    BookSpec(27, ("Daniel",), "OT", 12),
    BookSpec(28, ("Hosea",), "OT", 14),
    BookSpec(29, ("Joel",), "OT", 3),
    BookSpec(30, ("Amos",), "OT", 9),
    BookSpec(31, ("Obadiah",), "OT", 1),
    BookSpec(32, ("Jonah",), "OT", 4),
    BookSpec(33, ("Micah",), "OT", 7),
    BookSpec(34, ("Nahum",), "OT", 3),
    BookSpec(35, ("Habakkuk",), "OT", 3),
    BookSpec(36, ("Zephaniah",), "OT", 3),
    BookSpec(37, ("Haggai",), "OT", 2),
    BookSpec(38, ("Zechariah",), "OT", 14),
    BookSpec(39, ("Malachi",), "OT", 4),
    BookSpec(40, ("Matthew",), "NT", 28),
    BookSpec(41, ("Mark",), "NT", 16),
    BookSpec(42, ("Luke",), "NT", 24),
    BookSpec(43, ("John",), "NT", 21),
    BookSpec(44, ("Acts",), "NT", 28),
    BookSpec(45, ("Romans",), "NT", 16),
    BookSpec(46, ("1Corinthians",), "NT", 16),
    BookSpec(47, ("2Corinthians",), "NT", 13),
    BookSpec(48, ("Galatians",), "NT", 6),
    BookSpec(49, ("Ephesians",), "NT", 6),
    BookSpec(50, ("Philippians",), "NT", 4),
    BookSpec(51, ("Colossians",), "NT", 4),
    BookSpec(52, ("1Thessalonians",), "NT", 5),
    BookSpec(53, ("2Thessalonians",), "NT", 3),
    BookSpec(54, ("1Timothy",), "NT", 6),
    BookSpec(55, ("2Timothy",), "NT", 4),
    BookSpec(56, ("Titus",), "NT", 3),
    BookSpec(57, ("Philemon",), "NT", 1),
    BookSpec(58, ("Hebrews",), "NT", 13),
    BookSpec(59, ("James",), "NT", 5),
    BookSpec(60, ("1Peter",), "NT", 5),
    BookSpec(61, ("2Peter",), "NT", 3),
    BookSpec(62, ("1John",), "NT", 5),
    BookSpec(63, ("2John",), "NT", 1),
    BookSpec(64, ("3John",), "NT", 1),
    BookSpec(65, ("Jude",), "NT", 1),
    BookSpec(66, ("Revelation",), "NT", 22),
]


MANIFEST = {
    "id": TRANSLATION_ID,
    "title": "和合本圣经",
    "language": "zh-CN",
    "version": "1.0.0-cus",
    "copyright": "和合本圣经属公有领域，没有版权限制，可自由使用。",
    "hasSearchIndex": False,
}


def clean_html(text: str) -> str:
    text = re.sub(r"<br\s*/?>", " ", text, flags=re.IGNORECASE)
    text = re.sub(r"</?(?:i|b|u|em|strong)>", "", text, flags=re.IGNORECASE)
    text = re.sub(r"<[^>]+>", "", text)
    text = unescape(text)
    text = text.replace("\xa0", " ")
    text = re.sub(r"\s+", " ", text).strip()
    return text


def extract_book_name(html: str) -> str:
    match = re.search(r"<title>(.*?)</title>", html, re.S)
    if not match:
        raise ValueError("Could not parse book title.")
    name = clean_html(match.group(1))
    if "Psalms" in name:
        return "Psalms"
    return name


def extract_book_abbreviation(html: str) -> str:
    match = re.search(r"<div id=\"currBook\">(.*?)</div>", html, re.S)
    if not match:
        raise ValueError("Could not parse book abbreviation.")
    return clean_html(match.group(1))


def parse_chapters(html: str) -> dict[int, list[tuple[int, str]]]:
    chapters: dict[int, list[tuple[int, str]]] = {}
    chapter_pattern = re.compile(r"<div class=\"chapHdr\" id=\"chap_(\d+)\"", re.S)
    div_pattern = re.compile(r"<div\b[^>]*>|</div>", re.I)
    verse_pattern = re.compile(
        r"<p id=\"[^\"]+\"[^>]*><span[^>]*>(\d+)</span>\s*(.*?)</p>",
        re.S,
    )

    for chapter_match in chapter_pattern.finditer(html):
        chapter_number = int(chapter_match.group(1))
        main_start = html.find('<div class="main">', chapter_match.end())
        if main_start == -1:
            raise ValueError(f"Could not locate main content for chapter {chapter_number}.")

        content_start = main_start + len('<div class="main">')
        depth = 1
        content_end = -1
        for div_match in div_pattern.finditer(html, content_start):
            token = div_match.group(0).lower()
            if token.startswith("<div"):
                depth += 1
            else:
                depth -= 1
                if depth == 0:
                    content_end = div_match.start()
                    break

        if content_end == -1:
            raise ValueError(f"Could not find end of main content for chapter {chapter_number}.")

        chapter_html = html[content_start:content_end]
        verses: list[tuple[int, str]] = []
        for verse_text, verse_html in verse_pattern.findall(chapter_html):
            verse_number = int(verse_text)
            verse_content = clean_html(verse_html)
            if verse_content:
                verses.append((verse_number, verse_content))
        if not verses:
            raise ValueError(f"Chapter {chapter_number} has no verses.")
        chapters[chapter_number] = verses
    if not chapters:
        raise ValueError("No chapters parsed from HTML.")
    return chapters


def load_book_parts(stem: str) -> tuple[str, str, dict[int, list[tuple[int, str]]]]:
    file_path = SOURCE_DIR / f"CUS_{stem}.html"
    html = file_path.read_text(encoding="utf-8")
    return (
        extract_book_name(html),
        extract_book_abbreviation(html),
        parse_chapters(html),
    )


def build_book_content() -> list[dict[str, object]]:
    books: list[dict[str, object]] = []
    for book in BOOK_SPECS:
        name = ""
        abbreviation = ""
        chapters: dict[int, list[tuple[int, str]]] = {}
        for stem in book.stems:
            current_name, current_abbreviation, current_chapters = load_book_parts(stem)
            if not name:
                name = current_name
            if not abbreviation:
                abbreviation = current_abbreviation
            for chapter_number, verses in current_chapters.items():
                if chapter_number in chapters:
                    raise ValueError(
                        f"Duplicate chapter {chapter_number} found for book {book.id}.",
                    )
                chapters[chapter_number] = verses

        chapter_numbers = sorted(chapters)
        expected = list(range(1, book.expected_chapters + 1))
        if chapter_numbers != expected:
            raise ValueError(
                f"Book {book.id} expected chapters {expected[0]}-{expected[-1]}, "
                f"parsed {chapter_numbers[:1]}...{chapter_numbers[-1:]}",
            )

        books.append(
            {
                "id": book.id,
                "name": name,
                "abbreviation": abbreviation,
                "testament": book.testament,
                "sort_order": book.id,
                "chapter_count": book.expected_chapters,
                "chapters": chapters,
            },
        )
    return books


def create_content_db(db_path: Path) -> None:
    if db_path.exists():
        db_path.unlink()

    books = build_book_content()
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    cursor.executescript(
        """
        CREATE TABLE translations (
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            language TEXT NOT NULL,
            version TEXT NOT NULL,
            copyright TEXT NOT NULL,
            has_search_index INTEGER NOT NULL DEFAULT 0,
            has_semantic_index INTEGER NOT NULL DEFAULT 0
        );
        CREATE TABLE books (
            id INTEGER PRIMARY KEY,
            abbreviation TEXT NOT NULL,
            name TEXT NOT NULL,
            testament TEXT NOT NULL,
            sort_order INTEGER NOT NULL,
            chapter_count INTEGER NOT NULL
        );
        CREATE TABLE chapters (
            translation_id TEXT NOT NULL,
            book_id INTEGER NOT NULL,
            chapter INTEGER NOT NULL,
            verse_count INTEGER NOT NULL,
            PRIMARY KEY (translation_id, book_id, chapter)
        );
        CREATE TABLE verses (
            translation_id TEXT NOT NULL,
            book_id INTEGER NOT NULL,
            chapter INTEGER NOT NULL,
            verse INTEGER NOT NULL,
            text TEXT NOT NULL,
            PRIMARY KEY (translation_id, book_id, chapter, verse)
        );
        CREATE INDEX idx_verses_lookup ON verses (translation_id, book_id, chapter, verse);
        CREATE INDEX idx_verses_search ON verses (translation_id, text);
        CREATE TABLE verse_embeddings (
            translation_id TEXT NOT NULL,
            book_id INTEGER NOT NULL,
            chapter INTEGER NOT NULL,
            verse INTEGER NOT NULL,
            dim INTEGER NOT NULL,
            vector_blob BLOB NOT NULL,
            PRIMARY KEY (translation_id, book_id, chapter, verse)
        );
        CREATE TABLE verse_semantic_neighbors (
            translation_id TEXT NOT NULL,
            book_id INTEGER NOT NULL,
            chapter INTEGER NOT NULL,
            verse INTEGER NOT NULL,
            rank INTEGER NOT NULL,
            neighbor_book_id INTEGER NOT NULL,
            neighbor_chapter INTEGER NOT NULL,
            neighbor_verse INTEGER NOT NULL,
            score REAL NOT NULL,
            PRIMARY KEY (translation_id, book_id, chapter, verse, rank)
        );
        CREATE INDEX idx_verse_embeddings_translation
            ON verse_embeddings (translation_id);
        CREATE INDEX idx_verse_neighbors_translation
            ON verse_semantic_neighbors (translation_id, book_id, chapter, verse);
        """
    )
    cursor.execute(
        """
        INSERT INTO translations (
            id, title, language, version, copyright, has_search_index, has_semantic_index
        )
        VALUES (?, ?, ?, ?, ?, ?, ?)
        """,
        (
            MANIFEST["id"],
            MANIFEST["title"],
            MANIFEST["language"],
            MANIFEST["version"],
            MANIFEST["copyright"],
            1 if MANIFEST["hasSearchIndex"] else 0,
            1 if MANIFEST.get("hasSemanticIndex") else 0,
        ),
    )

    for book in books:
        cursor.execute(
            """
            INSERT INTO books (id, abbreviation, name, testament, sort_order, chapter_count)
            VALUES (?, ?, ?, ?, ?, ?)
            """,
            (
                book["id"],
                book["abbreviation"],
                book["name"],
                book["testament"],
                book["sort_order"],
                book["chapter_count"],
            ),
        )

        chapters = book["chapters"]
        for chapter_number in range(1, book["chapter_count"] + 1):
            verses = chapters[chapter_number]
            verse_count = max(verse_number for verse_number, _ in verses)
            cursor.execute(
                """
                INSERT INTO chapters (translation_id, book_id, chapter, verse_count)
                VALUES (?, ?, ?, ?)
                """,
                (TRANSLATION_ID, book["id"], chapter_number, verse_count),
            )
            for verse_number, verse_text in verses:
                cursor.execute(
                    """
                    INSERT INTO verses (translation_id, book_id, chapter, verse, text)
                    VALUES (?, ?, ?, ?, ?)
                    """,
                    (TRANSLATION_ID, book["id"], chapter_number, verse_number, verse_text),
                )

    cursor.execute("PRAGMA user_version = 2")
    conn.commit()
    conn.close()


def create_bundle(bundle_path: Path, db_path: Path, manifest_path: Path) -> None:
    if bundle_path.exists():
        bundle_path.unlink()
    with zipfile.ZipFile(bundle_path, "w", compression=zipfile.ZIP_DEFLATED) as archive:
        archive.write(manifest_path, arcname="manifest.json")
        archive.write(db_path, arcname="content.sqlite")


def main() -> None:
    if not SOURCE_DIR.exists():
        raise FileNotFoundError(
            f"Bible source directory not found: {SOURCE_DIR}",
        )

    BUNDLED_DIR.mkdir(parents=True, exist_ok=True)
    SAMPLES_DIR.mkdir(parents=True, exist_ok=True)

    manifest_path = BUNDLED_DIR / "builtin_manifest.json"
    db_path = BUNDLED_DIR / "builtin_content.sqlite"
    sample_bundle_path = SAMPLES_DIR / "flipbible_demo_bundle.flipbible"
    sample_bundle_v2_manifest_path = SAMPLES_DIR / "flipbible_demo_bundle_v2_manifest.json"
    sample_bundle_v2_path = SAMPLES_DIR / "flipbible_demo_bundle_v2.flipbible"

    manifest_path.write_text(
        json.dumps(MANIFEST, ensure_ascii=False, indent=2),
        encoding="utf-8",
    )
    create_content_db(db_path)
    create_bundle(sample_bundle_path, db_path, manifest_path)

    sample_bundle_v2_manifest = dict(MANIFEST)
    sample_bundle_v2_manifest["version"] = "2.0.0-cus"
    sample_bundle_v2_manifest_path.write_text(
        json.dumps(sample_bundle_v2_manifest, ensure_ascii=False, indent=2),
        encoding="utf-8",
    )
    create_bundle(sample_bundle_v2_path, db_path, sample_bundle_v2_manifest_path)

    print(f"Generated {manifest_path}")
    print(f"Generated {db_path}")
    print(f"Generated {sample_bundle_path}")
    print(f"Generated {sample_bundle_v2_path}")


if __name__ == "__main__":
    main()
