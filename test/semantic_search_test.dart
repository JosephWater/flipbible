import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flip_bible/core/data/app_database.dart';
import 'package:flip_bible/core/data/bible_repository.dart';
import 'package:flip_bible/core/data/reader_settings_repository.dart';
import 'package:flip_bible/core/data/semantic_embedding_client.dart';
import 'package:flip_bible/core/models/bible_location.dart';
import 'package:flip_bible/core/models/reader_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

class _MockReaderSettingsRepository extends Mock
    implements ReaderSettingsRepository {}

class _MockSemanticEmbeddingClient extends Mock
    implements SemanticEmbeddingClient {}

void main() {
  late AppDatabase appDatabase;
  late Directory tempDir;
  late File contentFile;
  late _MockReaderSettingsRepository settingsRepository;
  late _MockSemanticEmbeddingClient embeddingClient;

  setUpAll(() {
    registerFallbackValue(
      const EmbeddingApiConfig(
        baseUrl: 'https://example.com/v1',
        apiKey: 'test-key',
        model: 'test-model',
      ),
    );
  });

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('flipbible_semantic_test');
    contentFile = File('${tempDir.path}/semantic.sqlite');
    _createContentDatabase(contentFile);
    appDatabase = AppDatabase.forTesting(NativeDatabase.memory());
    settingsRepository = _MockReaderSettingsRepository();
    embeddingClient = _MockSemanticEmbeddingClient();

    await appDatabase.into(appDatabase.installedTranslations).insert(
          InstalledTranslationsCompanion.insert(
            id: 'builtin_cn_demo',
            title: '和合本示例',
            language: 'zh-CN',
            version: '1',
            copyright: '',
            filePath: contentFile.path,
            isBuiltin: const Value(true),
            isActive: const Value(true),
            hasSearchIndex: const Value(false),
            hasSemanticIndex: const Value(true),
            installedAt: DateTime(2024),
          ),
        );
  });

  tearDown(() async {
    await appDatabase.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('semantic search uses user overrides and sorts by similarity', () async {
    when(() => settingsRepository.getSettings()).thenAnswer(
      (_) async => const ReaderSettings(
        themeMode: ThemeMode.light,
        fontScale: 1,
        lineHeight: 1.75,
        verseSpacing: 10,
        pageHorizontalPadding: 18,
        backgroundColorValue: 0xFFFBF7EF,
        sliderSide: SliderSide.right,
        lastLocation: null,
        embeddingBaseUrl: 'https://example.com/v1',
        embeddingApiKey: 'user-key',
        embeddingModel: 'user-model',
        defaultEmbeddingAccessUnlocked: false,
      ),
    );
    when(
      () => embeddingClient.createEmbedding(
        config: any(named: 'config'),
        input: any(named: 'input'),
      ),
    ).thenAnswer((_) async => const [1.0, 0.0]);

    final repository = BibleRepository(
      appDatabase,
      settingsRepository: settingsRepository,
      embeddingClient: embeddingClient,
    );

    final results = await repository.semanticSearch('神爱', 'builtin_cn_demo');

    expect(results, hasLength(3));
    expect(results.first.location.verseStart, 1);
    expect(results[1].location.verseStart, 2);
    expect(results[2].location.verseStart, 3);

    final captured = verify(
      () => embeddingClient.createEmbedding(
        config: captureAny(named: 'config'),
        input: captureAny(named: 'input'),
      ),
    ).captured;
    final config = captured.first as EmbeddingApiConfig;
    expect(config.baseUrl, 'https://example.com/v1');
    expect(config.apiKey, 'user-key');
    expect(config.model, 'user-model');
    expect(captured.last, '神爱');
  });

  test('returns precomputed similar verses ordered by rank', () async {
    final repository = BibleRepository(
      appDatabase,
      settingsRepository: settingsRepository,
      embeddingClient: embeddingClient,
    );

    final results = await repository.getSimilarVersesForVerse(
      const BibleLocation(
        translationId: 'builtin_cn_demo',
        bookId: 43,
        chapter: 3,
        verseStart: 1,
      ),
    );

    expect(results, hasLength(2));
    expect(results.first.location.verseStart, 2);
    expect(results.last.location.verseStart, 3);
  });

  test('throws unsupported translation when semantic index is unavailable', () async {
    await appDatabase.into(appDatabase.installedTranslations).insertOnConflictUpdate(
          InstalledTranslationsCompanion.insert(
            id: 'plain_demo',
            title: 'Plain',
            language: 'zh-CN',
            version: '1',
            copyright: '',
            filePath: contentFile.path,
            isBuiltin: const Value(false),
            isActive: const Value(false),
            hasSearchIndex: const Value(false),
            hasSemanticIndex: const Value(false),
            installedAt: DateTime(2024),
          ),
        );

    final repository = BibleRepository(
      appDatabase,
      settingsRepository: settingsRepository,
      embeddingClient: embeddingClient,
    );

    expect(
      () => repository.semanticSearch('hope', 'plain_demo'),
      throwsA(
        isA<SemanticSearchException>().having(
          (error) => error.type,
          'type',
          SemanticSearchErrorType.unsupportedTranslation,
        ),
      ),
    );
  });

  test('does not use the bundled API key while invite code access is locked', () {
    const settings = ReaderSettings(
      themeMode: ThemeMode.light,
      fontScale: 1,
      lineHeight: 1.75,
      verseSpacing: 10,
      pageHorizontalPadding: 18,
      backgroundColorValue: 0xFFFBF7EF,
      sliderSide: SliderSide.right,
      lastLocation: null,
      embeddingBaseUrl: '',
      embeddingApiKey: '',
      embeddingModel: '',
      defaultEmbeddingAccessUnlocked: false,
    );

    final config = EmbeddingApiConfig.fromSettings(settings);

    expect(config.baseUrl, isNotEmpty);
    expect(config.model, isNotEmpty);
    expect(config.apiKey, isEmpty);
  });
}

void _createContentDatabase(File file) {
  final database = sqlite.sqlite3.open(file.path);
  try {
    database.execute(
      '''
      CREATE TABLE translations (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        language TEXT NOT NULL,
        version TEXT NOT NULL,
        copyright TEXT NOT NULL,
        has_search_index INTEGER NOT NULL DEFAULT 0,
        has_semantic_index INTEGER NOT NULL DEFAULT 1
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
        verse_index INTEGER,
        PRIMARY KEY (translation_id, book_id, chapter, verse)
      );
      CREATE TABLE verse_embeddings (
        translation_id TEXT NOT NULL,
        verse_index INTEGER NOT NULL,
        dim INTEGER NOT NULL,
        vector_encoding TEXT NOT NULL,
        vector_blob BLOB NOT NULL,
        PRIMARY KEY (translation_id, verse_index)
      );
      CREATE TABLE verse_semantic_neighbors (
        translation_id TEXT NOT NULL,
        source_verse_index INTEGER NOT NULL,
        neighbor_indices_blob BLOB NOT NULL,
        PRIMARY KEY (translation_id, source_verse_index)
      );
      ''',
    );

    database.execute(
      '''
      INSERT INTO translations (
        id, title, language, version, copyright, has_search_index, has_semantic_index
      ) VALUES ('builtin_cn_demo', '和合本示例', 'zh-CN', '1', '', 0, 1);
      INSERT INTO books (id, abbreviation, name, testament, sort_order, chapter_count)
      VALUES (43, '约', '约翰福音', 'NT', 43, 21);
      INSERT INTO chapters (translation_id, book_id, chapter, verse_count)
      VALUES ('builtin_cn_demo', 43, 3, 3);
      INSERT INTO verses (translation_id, book_id, chapter, verse, text, verse_index) VALUES
        ('builtin_cn_demo', 43, 3, 1, '神爱世人', 0),
        ('builtin_cn_demo', 43, 3, 2, '神赐下独生子', 1),
        ('builtin_cn_demo', 43, 3, 3, '世人需要拯救', 2);
      ''',
    );

    final insertEmbedding = database.prepare(
      '''
      INSERT INTO verse_embeddings (
        translation_id, verse_index, dim, vector_encoding, vector_blob
      ) VALUES (?, ?, ?, ?, ?)
      ''',
    );
    insertEmbedding.execute([
      'builtin_cn_demo',
      0,
      2,
      'i8n',
      _normalizedInt8Blob(const [1.0, 0.0]),
    ]);
    insertEmbedding.execute([
      'builtin_cn_demo',
      1,
      2,
      'i8n',
      _normalizedInt8Blob(const [0.8, 0.2]),
    ]);
    insertEmbedding.execute([
      'builtin_cn_demo',
      2,
      2,
      'i8n',
      _normalizedInt8Blob(const [0.0, 1.0]),
    ]);
    insertEmbedding.close();

    database.execute(
      '''
      INSERT INTO verse_semantic_neighbors (
        translation_id, source_verse_index, neighbor_indices_blob
      ) VALUES (?, ?, ?);
      ''',
      [
        'builtin_cn_demo',
        0,
        _neighborBlob(const [1, 2]),
      ],
    );
  } finally {
    database.close();
  }
}

Uint8List _normalizedInt8Blob(List<double> values) {
  final vector = Float32List.fromList(values);
  var magnitude = 0.0;
  for (final value in vector) {
    magnitude += value * value;
  }
  magnitude = magnitude == 0 ? 1 : math.sqrt(magnitude);

  final bytes = Int8List(vector.length);
  for (var index = 0; index < vector.length; index++) {
    final normalized = vector[index] / magnitude;
    bytes[index] = (normalized * 127).round().clamp(-127, 127);
  }
  return bytes.buffer.asUint8List();
}

Uint8List _neighborBlob(List<int> values) {
  final data = ByteData(values.length * 2);
  for (var index = 0; index < values.length; index++) {
    data.setUint16(index * 2, values[index], Endian.little);
  }
  return data.buffer.asUint8List();
}
