import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

part 'bible_content_database.g.dart';

class ContentTranslations extends Table {
  @override
  String get tableName => 'translations';

  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get language => text()();
  TextColumn get version => text()();
  TextColumn get copyright => text()();
  BoolColumn get hasSearchIndex =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get hasSemanticIndex =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Books extends Table {
  IntColumn get id => integer()();
  TextColumn get abbreviation => text()();
  TextColumn get name => text()();
  TextColumn get testament => text()();
  IntColumn get sortOrder => integer()();
  IntColumn get chapterCount => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Chapters extends Table {
  TextColumn get translationId => text()();
  IntColumn get bookId => integer()();
  IntColumn get chapter => integer()();
  IntColumn get verseCount => integer()();

  @override
  Set<Column<Object>> get primaryKey => {translationId, bookId, chapter};
}

class Verses extends Table {
  TextColumn get translationId => text()();
  IntColumn get bookId => integer()();
  IntColumn get chapter => integer()();
  IntColumn get verse => integer()();
  TextColumn get content => text().named('text')();
  IntColumn get verseIndex => integer().named('verse_index').nullable()();

  @override
  Set<Column<Object>> get primaryKey => {translationId, bookId, chapter, verse};
}

class VerseEmbeddings extends Table {
  TextColumn get translationId => text()();
  IntColumn get verseIndex => integer().named('verse_index')();
  IntColumn get dim => integer()();
  TextColumn get vectorEncoding =>
      text().named('vector_encoding').withDefault(const Constant('f32'))();
  BlobColumn get vectorBlob => blob()();

  @override
  Set<Column<Object>> get primaryKey => {translationId, verseIndex};
}

class VerseSemanticNeighbors extends Table {
  TextColumn get translationId => text()();
  IntColumn get sourceVerseIndex => integer().named('source_verse_index')();
  BlobColumn get neighborIndicesBlob =>
      blob().named('neighbor_indices_blob')();

  @override
  Set<Column<Object>> get primaryKey => {
        translationId,
        sourceVerseIndex,
      };
}

@DriftDatabase(
  tables: [
    ContentTranslations,
    Books,
    Chapters,
    Verses,
    VerseEmbeddings,
    VerseSemanticNeighbors,
  ],
)
class BibleContentDatabase extends _$BibleContentDatabase {
  BibleContentDatabase(String filePath) : super(NativeDatabase(File(filePath)));

  BibleContentDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (migrator) async {
          await migrator.createAll();
          await _createSemanticIndexes();
        },
        onUpgrade: (migrator, from, to) async {
          if (from < 2) {
            await _ensureSchemaV2();
          }
          if (from < 3) {
            await _ensureSchemaV3();
          }
          await _createSemanticIndexes();
        },
      );

  Future<void> _ensureSchemaV2() async {
    final translationColumns = await customSelect(
      'PRAGMA table_info(translations)',
    ).get();
    final hasSemanticIndexColumn = translationColumns.any(
      (row) => row.read<String>('name') == 'has_semantic_index',
    );

    if (!hasSemanticIndexColumn) {
      await customStatement(
        '''
        ALTER TABLE translations
        ADD COLUMN has_semantic_index INTEGER NOT NULL DEFAULT 0
        ''',
      );
    }

    final tableRows = await customSelect(
      "SELECT name FROM sqlite_master WHERE type = 'table'",
    ).get();
    final tableNames = tableRows.map((row) => row.read<String>('name')).toSet();

    if (!tableNames.contains('verse_embeddings')) {
      await customStatement(
        '''
        CREATE TABLE verse_embeddings (
          translation_id TEXT NOT NULL,
          verse_index INTEGER NOT NULL,
          dim INTEGER NOT NULL,
          vector_encoding TEXT NOT NULL DEFAULT 'f32',
          vector_blob BLOB NOT NULL,
          PRIMARY KEY (translation_id, verse_index)
        )
        ''',
      );
    }

    if (!tableNames.contains('verse_semantic_neighbors')) {
      await customStatement(
        '''
        CREATE TABLE verse_semantic_neighbors (
          translation_id TEXT NOT NULL,
          source_verse_index INTEGER NOT NULL,
          neighbor_indices_blob BLOB NOT NULL,
          PRIMARY KEY (translation_id, source_verse_index)
        )
        ''',
      );
    }
  }

  Future<void> _ensureSchemaV3() async {
    final verseColumns = await customSelect(
      'PRAGMA table_info(verses)',
    ).get();
    final hasVerseIndexColumn = verseColumns.any(
      (row) => row.read<String>('name') == 'verse_index',
    );
    if (!hasVerseIndexColumn) {
      await customStatement(
        '''
        ALTER TABLE verses
        ADD COLUMN verse_index INTEGER
        ''',
      );
    }

    final embeddingColumns = await customSelect(
      'PRAGMA table_info(verse_embeddings)',
    ).get();
    final embeddingNames = embeddingColumns
        .map((row) => row.read<String>('name'))
        .toSet();
    if (!embeddingNames.contains('verse_index')) {
      await customStatement(
        '''
        ALTER TABLE verse_embeddings
        ADD COLUMN verse_index INTEGER
        ''',
      );
    }
    if (!embeddingNames.contains('vector_encoding')) {
      await customStatement(
        '''
        ALTER TABLE verse_embeddings
        ADD COLUMN vector_encoding TEXT NOT NULL DEFAULT 'f32'
        ''',
      );
    }

    final neighborColumns = await customSelect(
      'PRAGMA table_info(verse_semantic_neighbors)',
    ).get();
    final neighborNames = neighborColumns
        .map((row) => row.read<String>('name'))
        .toSet();
    if (!neighborNames.contains('source_verse_index')) {
      await customStatement(
        '''
        ALTER TABLE verse_semantic_neighbors
        ADD COLUMN source_verse_index INTEGER
        ''',
      );
    }
    if (!neighborNames.contains('neighbor_indices_blob')) {
      await customStatement(
        '''
        ALTER TABLE verse_semantic_neighbors
        ADD COLUMN neighbor_indices_blob BLOB
        ''',
      );
    }
  }

  Future<void> _createSemanticIndexes() async {
    final verseColumns = await customSelect(
      'PRAGMA table_info(verses)',
    ).get();
    final hasVerseIndexColumn = verseColumns.any(
      (row) => row.read<String>('name') == 'verse_index',
    );
    await customStatement(
      '''
      CREATE INDEX IF NOT EXISTS idx_verses_translation_chapter
      ON verses (translation_id, book_id, chapter, verse)
      ''',
    );
    if (hasVerseIndexColumn) {
      await customStatement(
        '''
        CREATE INDEX IF NOT EXISTS idx_verses_translation_index
        ON verses (translation_id, verse_index)
        ''',
      );
    }

    final embeddingColumns = await customSelect(
      'PRAGMA table_info(verse_embeddings)',
    ).get();
    final hasEmbeddingVerseIndex = embeddingColumns.any(
      (row) => row.read<String>('name') == 'verse_index',
    );
    if (hasEmbeddingVerseIndex) {
      await customStatement(
        '''
        CREATE INDEX IF NOT EXISTS idx_verse_embeddings_translation
        ON verse_embeddings (translation_id, verse_index)
        ''',
      );
    }

    final neighborColumns = await customSelect(
      'PRAGMA table_info(verse_semantic_neighbors)',
    ).get();
    final hasSourceVerseIndex = neighborColumns.any(
      (row) => row.read<String>('name') == 'source_verse_index',
    );
    if (hasSourceVerseIndex) {
      await customStatement(
        '''
        CREATE INDEX IF NOT EXISTS idx_verse_neighbors_translation
        ON verse_semantic_neighbors (translation_id, source_verse_index)
        ''',
      );
    }
  }
}
