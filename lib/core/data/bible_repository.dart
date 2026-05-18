import 'dart:collection';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:drift/drift.dart';

import '../models/bible_location.dart';
import '../models/book_summary.dart';
import '../models/chapter_content.dart';
import '../models/search_hit.dart';
import '../models/translation_summary.dart';
import 'app_database.dart';
import 'bible_content_database.dart';
import 'reader_settings_repository.dart';
import 'semantic_embedding_client.dart';

class BibleRepository {
  BibleRepository(
    this._appDatabase, {
    ReaderSettingsRepository? settingsRepository,
    SemanticEmbeddingClient? embeddingClient,
  })  : _settingsRepository = settingsRepository,
        _embeddingClient = embeddingClient ?? OpenAiCompatibleEmbeddingClient();

  final AppDatabase _appDatabase;
  final ReaderSettingsRepository? _settingsRepository;
  final SemanticEmbeddingClient _embeddingClient;
  final LinkedHashMap<String, ChapterContent> _chapterCache =
      LinkedHashMap<String, ChapterContent>();
  final Map<String, Future<ChapterContent>> _pendingChapterLoads =
      <String, Future<ChapterContent>>{};

  static const int _chapterCacheLimit = 18;
  static const int _semanticSearchLimit = 50;
  static const int _semanticBatchSize = 512;

  Future<List<TranslationSummary>> listTranslations() async {
    final rows = await (_appDatabase.select(_appDatabase.installedTranslations)
          ..orderBy([
            (table) => OrderingTerm(
                  expression: table.installedAt,
                  mode: OrderingMode.asc,
                ),
          ]))
        .get();
    return rows.map(_mapTranslation).toList();
  }

  Stream<List<TranslationSummary>> watchTranslations() {
    final query = _appDatabase.select(_appDatabase.installedTranslations)
      ..orderBy([
        (table) => OrderingTerm(
              expression: table.installedAt,
              mode: OrderingMode.asc,
            ),
      ]);
    return query.watch().map((rows) => rows.map(_mapTranslation).toList());
  }

  Future<TranslationSummary?> getTranslation(String id) async {
    final row = await (_appDatabase.select(_appDatabase.installedTranslations)
          ..where((table) => table.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _mapTranslation(row);
  }

  Future<void> setActiveTranslation(String id) async {
    await _appDatabase.transaction(() async {
      await _appDatabase.update(_appDatabase.installedTranslations).write(
            const InstalledTranslationsCompanion(isActive: Value(false)),
          );
      await (_appDatabase.update(_appDatabase.installedTranslations)
            ..where((table) => table.id.equals(id)))
          .write(
        const InstalledTranslationsCompanion(isActive: Value(true)),
      );
    });
  }

  Future<ChapterContent> loadChapter(BibleLocation location) async {
    final cacheKey = _chapterKey(location);
    final cached = _chapterCache.remove(cacheKey);
    if (cached != null) {
      _chapterCache[cacheKey] = cached;
      return cached;
    }

    final pending = _pendingChapterLoads[cacheKey];
    if (pending != null) {
      return pending;
    }

    final future = _loadChapterInternal(location);
    _pendingChapterLoads[cacheKey] = future;
    try {
      final result = await future;
      _chapterCache[cacheKey] = result;
      if (_chapterCache.length > _chapterCacheLimit) {
        _chapterCache.remove(_chapterCache.keys.first);
      }
      return result;
    } finally {
      _pendingChapterLoads.remove(cacheKey);
    }
  }

  Future<void> prefetchChapter(BibleLocation location) async {
    await loadChapter(location);
  }

  Future<List<BookSummary>> listBooks(String translationId) async {
    final translation = await getTranslation(translationId);
    if (translation == null) {
      return const [];
    }

    final database = BibleContentDatabase(translation.filePath);
    try {
      final books = await (database.select(database.books)
            ..orderBy([
              (table) => OrderingTerm(expression: table.sortOrder),
            ]))
          .get();
      return books
          .map(
            (book) => BookSummary(
              id: book.id,
              abbreviation: book.abbreviation,
              name: book.name,
              testament: book.testament,
              sortOrder: book.sortOrder,
              chapterCount: book.chapterCount,
            ),
          )
          .toList();
    } finally {
      await database.close();
    }
  }

  Future<List<SearchHit>> search(String query, String translationId) async {
    final cleaned = query.trim();
    if (cleaned.isEmpty) {
      return const [];
    }

    final translation = await getTranslation(translationId);
    if (translation == null) {
      return const [];
    }

    final database = BibleContentDatabase(translation.filePath);
    try {
      final result = await database.customSelect(
        '''
        SELECT v.translation_id, v.book_id, v.chapter, v.verse, v.text, b.name AS book_name
        FROM verses v
        JOIN books b ON b.id = v.book_id
        WHERE v.translation_id = ? AND v.text LIKE ?
        ORDER BY v.book_id, v.chapter, v.verse
        LIMIT 80
        ''',
        variables: [
          Variable<String>(translationId),
          Variable<String>('%$cleaned%'),
        ],
      ).get();

      return result.map((row) {
        final text = row.read<String>('text');
        return SearchHit(
          location: BibleLocation(
            translationId: translationId,
            bookId: row.read<int>('book_id'),
            chapter: row.read<int>('chapter'),
            verseStart: row.read<int>('verse'),
          ),
          bookName: row.read<String>('book_name'),
          translationTitle: translation.title,
          snippet: _makeSnippet(text, cleaned),
        );
      }).toList(growable: false);
    } finally {
      await database.close();
    }
  }

  Future<List<SearchHit>> getSimilarVersesForVerse(BibleLocation location) async {
    final translation = await _requireSemanticTranslation(location.translationId);
    final verse = location.verseStart;
    if (verse == null) {
      return const [];
    }

    final database = BibleContentDatabase(translation.filePath);
    try {
      final sourceRows = await database.customSelect(
        '''
        SELECT verse_index
        FROM verses
        WHERE translation_id = ? AND book_id = ? AND chapter = ? AND verse = ?
        LIMIT 1
        ''',
        variables: [
          Variable<String>(location.translationId),
          Variable<int>(location.bookId),
          Variable<int>(location.chapter),
          Variable<int>(verse),
        ],
      ).get();
      if (sourceRows.isEmpty) {
        return const [];
      }

      final sourceVerseIndex = sourceRows.single.read<int>('verse_index');
      final neighborRows = await database.customSelect(
        '''
        SELECT neighbor_indices_blob
        FROM verse_semantic_neighbors
        WHERE translation_id = ? AND source_verse_index = ?
        LIMIT 1
        ''',
        variables: [
          Variable<String>(location.translationId),
          Variable<int>(sourceVerseIndex),
        ],
      ).get();
      if (neighborRows.isEmpty) {
        return const [];
      }

      final neighborIndices = _decodeNeighborIndices(
        neighborRows.single.read<Uint8List>('neighbor_indices_blob'),
      );
      final hits = <SearchHit>[];
      for (final neighborVerseIndex in neighborIndices) {
        final hit = await _loadSemanticSearchHit(
          database,
          translation: translation,
          verseIndex: neighborVerseIndex,
          score: null,
        );
        if (hit != null) {
          hits.add(hit);
        }
      }
      return hits;
    } finally {
      await database.close();
    }
  }

  Future<List<SearchHit>> semanticSearch(
    String query,
    String translationId,
  ) async {
    final cleaned = query.trim();
    if (cleaned.isEmpty) {
      return const [];
    }

    final translation = await _requireSemanticTranslation(translationId);
    final settingsRepository = _settingsRepository;
    if (settingsRepository == null) {
      throw StateError('Semantic search requires reader settings access.');
    }

    final settings = await settingsRepository.getSettings();
    final config = EmbeddingApiConfig.fromSettings(settings);
    final queryVector = await _embeddingClient.createEmbedding(
      config: config,
      input: cleaned,
    );
    final queryNorm = _vectorNorm(queryVector);
    if (queryNorm == 0) {
      throw const SemanticSearchException(
        SemanticSearchErrorType.invalidResponse,
        message: 'Query embedding cannot be normalized.',
      );
    }

    final queryUnit = queryVector
        .map((value) => value / queryNorm)
        .toList(growable: false);

    final database = BibleContentDatabase(translation.filePath);
    try {
      final queue = HeapPriorityQueue<_ScoredVerseCandidate>(
        (left, right) => left.score.compareTo(right.score),
      );
      var offset = 0;

      while (true) {
        final batch = await database.customSelect(
          '''
          SELECT verse_index, dim, vector_encoding, vector_blob
          FROM verse_embeddings
          WHERE translation_id = ?
          ORDER BY verse_index
          LIMIT ? OFFSET ?
          ''',
          variables: [
            Variable<String>(translationId),
            Variable<int>(_semanticBatchSize),
            Variable<int>(offset),
          ],
        ).get();

        if (batch.isEmpty) {
          break;
        }

        for (final row in batch) {
          final verseIndex = row.read<int>('verse_index');
          final dim = row.read<int>('dim');
          final encoding = row.read<String>('vector_encoding');
          final vectorBytes = row.read<Uint8List>('vector_blob');
          final score = _scoreEncodedVector(
            queryUnit: queryUnit,
            bytes: vectorBytes,
            dim: dim,
            encoding: encoding,
          );

          if (queue.length < _semanticSearchLimit) {
            queue.add(
              _ScoredVerseCandidate(
                verseIndex: verseIndex,
                score: score,
              ),
            );
            continue;
          }

          final smallest = queue.first;
          if (score > smallest.score) {
            queue.removeFirst();
            queue.add(
              _ScoredVerseCandidate(
                verseIndex: verseIndex,
                score: score,
              ),
            );
          }
        }

        offset += batch.length;
      }

      final topMatches = queue.toList()
        ..sort((left, right) => right.score.compareTo(left.score));

      final hits = <SearchHit>[];
      for (final candidate in topMatches) {
        final hit = await _loadSemanticSearchHit(
          database,
          translation: translation,
          verseIndex: candidate.verseIndex,
          score: candidate.score,
        );
        if (hit != null) {
          hits.add(hit);
        }
      }
      return hits;
    } finally {
      await database.close();
    }
  }

  Future<String> formatLocation(BibleLocation location) async {
    final translation = await getTranslation(location.translationId);
    if (translation == null) {
      return '${location.chapter}\u7ae0';
    }
    final database = BibleContentDatabase(translation.filePath);
    try {
      final book = await (database.select(database.books)
            ..where((table) => table.id.equals(location.bookId)))
          .getSingle();
      final verse = location.verseStart == null ? '' : ':${location.verseStart}';
      return '${book.name} ${location.chapter}$verse';
    } finally {
      await database.close();
    }
  }

  Future<ChapterContent> _loadChapterInternal(BibleLocation location) async {
    final translation = await getTranslation(location.translationId);
    if (translation == null) {
      throw StateError('Translation not found: ${location.translationId}');
    }

    final database = BibleContentDatabase(translation.filePath);
    try {
      final book = await (database.select(database.books)
            ..where((table) => table.id.equals(location.bookId)))
          .getSingle();
      final verses = await (database.select(database.verses)
            ..where(
              (table) =>
                  table.translationId.equals(location.translationId) &
                  table.bookId.equals(location.bookId) &
                  table.chapter.equals(location.chapter),
            )
            ..orderBy([
              (table) => OrderingTerm(expression: table.verse),
            ]))
          .get();

      return ChapterContent(
        translation: translation,
        book: BookSummary(
          id: book.id,
          abbreviation: book.abbreviation,
          name: book.name,
          testament: book.testament,
          sortOrder: book.sortOrder,
          chapterCount: book.chapterCount,
        ),
        chapter: location.chapter,
        verses: verses
            .map((row) => VerseContent(verse: row.verse, text: row.content))
            .toList(growable: false),
      );
    } finally {
      await database.close();
    }
  }

  Future<SearchHit?> _loadSemanticSearchHit(
    BibleContentDatabase database, {
    required TranslationSummary translation,
    required int verseIndex,
    required double? score,
  }) async {
    final rows = await database.customSelect(
      '''
      SELECT v.book_id, v.chapter, v.verse, v.text, b.name AS book_name
      FROM verses v
      JOIN books b ON b.id = v.book_id
      WHERE v.translation_id = ? AND v.verse_index = ?
      LIMIT 1
      ''',
      variables: [
        Variable<String>(translation.id),
        Variable<int>(verseIndex),
      ],
    ).get();

    if (rows.isEmpty) {
      return null;
    }

    final row = rows.single;
    return SearchHit(
      location: BibleLocation(
        translationId: translation.id,
        bookId: row.read<int>('book_id'),
        chapter: row.read<int>('chapter'),
        verseStart: row.read<int>('verse'),
      ),
      bookName: row.read<String>('book_name'),
      translationTitle: translation.title,
      snippet: row.read<String>('text'),
      score: score,
    );
  }

  String _makeSnippet(String text, String query) {
    final index = text.indexOf(query);
    if (index < 0 || text.length <= 32) {
      return text;
    }

    final start = (index - 12).clamp(0, text.length).toInt();
    final end = (index + query.length + 18).clamp(0, text.length).toInt();
    final prefix = start > 0 ? '…' : '';
    final suffix = end < text.length ? '…' : '';
    return '$prefix${text.substring(start, end)}$suffix';
  }

  Future<TranslationSummary> _requireSemanticTranslation(String translationId) async {
    final translation = await getTranslation(translationId);
    if (translation == null || !translation.hasSemanticIndex) {
      throw const SemanticSearchException(
        SemanticSearchErrorType.unsupportedTranslation,
        message: '当前译本不支持语义搜索。',
      );
    }
    return translation;
  }

  double _vectorNorm(List<double> vector) {
    var total = 0.0;
    for (final value in vector) {
      total += value * value;
    }
    return math.sqrt(total);
  }

  double _scoreEncodedVector({
    required List<double> queryUnit,
    required Uint8List bytes,
    required int dim,
    required String encoding,
  }) {
    if (queryUnit.length != dim) {
      throw const SemanticSearchException(
        SemanticSearchErrorType.invalidResponse,
        message: 'Embedding dimensions do not match.',
      );
    }

    switch (encoding) {
      case 'i8n':
        return _scoreNormalizedInt8(queryUnit, bytes, dim);
      case 'f32':
        return _scoreFloat32(queryUnit, bytes, dim);
      default:
        throw const SemanticSearchException(
          SemanticSearchErrorType.invalidResponse,
          message: 'Stored verse embedding uses an unsupported format.',
        );
    }
  }

  double _scoreFloat32(
    List<double> queryUnit,
    Uint8List bytes,
    int dim,
  ) {
    if (bytes.lengthInBytes != dim * 4) {
      throw const SemanticSearchException(
        SemanticSearchErrorType.invalidResponse,
        message: 'Stored verse embedding has an invalid size.',
      );
    }

    final data = ByteData.sublistView(bytes);
    var dot = 0.0;
    var magnitude = 0.0;
    for (var index = 0; index < dim; index++) {
      final verseValue = data.getFloat32(index * 4, Endian.little);
      dot += queryUnit[index] * verseValue;
      magnitude += verseValue * verseValue;
    }
    if (magnitude == 0) {
      return 0;
    }
    return dot / math.sqrt(magnitude);
  }

  double _scoreNormalizedInt8(
    List<double> queryUnit,
    Uint8List bytes,
    int dim,
  ) {
    if (bytes.lengthInBytes != dim) {
      throw const SemanticSearchException(
        SemanticSearchErrorType.invalidResponse,
        message: 'Stored verse embedding has an invalid size.',
      );
    }

    final values = bytes.buffer.asInt8List(bytes.offsetInBytes, dim);
    var dot = 0.0;
    for (var index = 0; index < dim; index++) {
      dot += queryUnit[index] * values[index];
    }
    return dot / 127.0;
  }

  List<int> _decodeNeighborIndices(Uint8List bytes) {
    if (bytes.lengthInBytes.isOdd) {
      throw const SemanticSearchException(
        SemanticSearchErrorType.invalidResponse,
        message: 'Stored similar verse index blob has an invalid size.',
      );
    }

    final data = ByteData.sublistView(bytes);
    final count = bytes.lengthInBytes ~/ 2;
    final values = List<int>.filled(count, 0, growable: false);
    for (var index = 0; index < count; index++) {
      values[index] = data.getUint16(index * 2, Endian.little);
    }
    return values;
  }

  TranslationSummary _mapTranslation(InstalledTranslation row) {
    return TranslationSummary(
      id: row.id,
      title: row.title,
      language: row.language,
      version: row.version,
      copyright: row.copyright,
      filePath: row.filePath,
      isBuiltin: row.isBuiltin,
      isActive: row.isActive,
      hasSearchIndex: row.hasSearchIndex,
      hasSemanticIndex: row.hasSemanticIndex,
    );
  }

  String _chapterKey(BibleLocation location) {
    return '${location.translationId}-${location.bookId}-${location.chapter}';
  }
}

class _ScoredVerseCandidate {
  const _ScoredVerseCandidate({
    required this.verseIndex,
    required this.score,
  });

  final int verseIndex;
  final double score;
}
