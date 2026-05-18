import 'package:drift/drift.dart';
import 'package:flutter/material.dart';

import '../models/bible_location.dart';
import '../models/reader_settings.dart';
import 'app_database.dart';
import 'semantic_search_defaults.dart';

class ReaderSettingsRepository {
  ReaderSettingsRepository(this._database);

  final AppDatabase _database;

  Stream<ReaderSettings> watchSettings() {
    return (_database.select(_database.readerPreferences)
          ..where((table) => table.id.equals(1)))
        .watchSingleOrNull()
        .map((row) => _mapRow(row));
  }

  Future<ReaderSettings> getSettings() async {
    final row = await (_database.select(_database.readerPreferences)
          ..where((table) => table.id.equals(1)))
        .getSingleOrNull();
    return _mapRow(row);
  }

  Future<void> ensureInitialized() async {
    final existing = await (_database.select(_database.readerPreferences)
          ..where((table) => table.id.equals(1)))
        .getSingleOrNull();
    if (existing != null) {
      return;
    }

    await _database.into(_database.readerPreferences).insert(
          const ReaderPreferencesCompanion(
            id: Value(1),
            themeMode: Value('light'),
            fontScale: Value(1),
            lineHeight: Value(1.75),
            verseSpacing: Value(10),
            pageHorizontalPadding: Value(18),
            backgroundColorValue: Value(0xFFFBF7EF),
            sliderSide: Value('right'),
            embeddingBaseUrl: Value(''),
            embeddingApiKey: Value(''),
            embeddingModel: Value(''),
            defaultEmbeddingAccessUnlocked: Value(false),
          ),
        );
  }

  Future<void> ensureLastLocation(String translationId) async {
    final settings = await getSettings();
    if (settings.lastLocation != null) {
      return;
    }
    await saveLastLocation(
      BibleLocation(
        translationId: translationId,
        bookId: 1,
        chapter: 1,
      ),
    );
  }

  Future<void> saveLastLocation(BibleLocation location) async {
    await (_database.update(_database.readerPreferences)
          ..where((table) => table.id.equals(1)))
        .write(
      ReaderPreferencesCompanion(
        lastTranslationId: Value(location.translationId),
        lastBookId: Value(location.bookId),
        lastChapter: Value(location.chapter),
        lastVerse: Value(location.verseStart),
      ),
    );
  }

  Future<void> updateThemeMode(ThemeMode mode) async {
    await (_database.update(_database.readerPreferences)
          ..where((table) => table.id.equals(1)))
        .write(
      ReaderPreferencesCompanion(themeMode: Value(mode.name)),
    );
  }

  Future<void> updateFontScale(double value) async {
    await (_database.update(_database.readerPreferences)
          ..where((table) => table.id.equals(1)))
        .write(ReaderPreferencesCompanion(fontScale: Value(value)));
  }

  Future<void> updateLineHeight(double value) async {
    await (_database.update(_database.readerPreferences)
          ..where((table) => table.id.equals(1)))
        .write(ReaderPreferencesCompanion(lineHeight: Value(value)));
  }

  Future<void> updateVerseSpacing(double value) async {
    await (_database.update(_database.readerPreferences)
          ..where((table) => table.id.equals(1)))
        .write(ReaderPreferencesCompanion(verseSpacing: Value(value)));
  }

  Future<void> updatePageHorizontalPadding(double value) async {
    await (_database.update(_database.readerPreferences)
          ..where((table) => table.id.equals(1)))
        .write(
      ReaderPreferencesCompanion(pageHorizontalPadding: Value(value)),
    );
  }

  Future<void> updateBackgroundColorValue(int value) async {
    await (_database.update(_database.readerPreferences)
          ..where((table) => table.id.equals(1)))
        .write(
      ReaderPreferencesCompanion(backgroundColorValue: Value(value)),
    );
  }

  Future<void> updateEmbeddingBaseUrl(String value) async {
    await (_database.update(_database.readerPreferences)
          ..where((table) => table.id.equals(1)))
        .write(ReaderPreferencesCompanion(embeddingBaseUrl: Value(value.trim())));
  }

  Future<void> updateEmbeddingApiKey(String value) async {
    await (_database.update(_database.readerPreferences)
          ..where((table) => table.id.equals(1)))
        .write(ReaderPreferencesCompanion(embeddingApiKey: Value(value.trim())));
  }

  Future<void> updateEmbeddingModel(String value) async {
    await (_database.update(_database.readerPreferences)
          ..where((table) => table.id.equals(1)))
        .write(ReaderPreferencesCompanion(embeddingModel: Value(value.trim())));
  }

  Future<void> updateDefaultEmbeddingAccessUnlocked(bool value) async {
    await (_database.update(_database.readerPreferences)
          ..where((table) => table.id.equals(1)))
        .write(
      ReaderPreferencesCompanion(
        defaultEmbeddingAccessUnlocked: Value(value),
      ),
    );
  }

  Future<void> enableDefaultSemanticAccess() async {
    final settings = await getSettings();
    final currentBaseUrl = settings.embeddingBaseUrl.trim();
    final currentModel = settings.embeddingModel.trim();
    final currentApiKey = settings.embeddingApiKey.trim();

    await (_database.update(_database.readerPreferences)
          ..where((table) => table.id.equals(1)))
        .write(
      ReaderPreferencesCompanion(
        defaultEmbeddingAccessUnlocked: const Value(true),
        embeddingBaseUrl: Value(
          currentBaseUrl.isEmpty ? defaultEmbeddingBaseUrl : currentBaseUrl,
        ),
        embeddingModel: Value(
          currentModel.isEmpty ? defaultEmbeddingModel : currentModel,
        ),
        embeddingApiKey: Value(
          hasManualEmbeddingApiKey(currentApiKey)
              ? currentApiKey
              : builtinEmbeddingApiKeyPlaceholder,
        ),
      ),
    );
  }

  Future<void> disableDefaultSemanticAccess() async {
    final settings = await getSettings();
    final currentBaseUrl = settings.embeddingBaseUrl.trim();
    final currentModel = settings.embeddingModel.trim();
    final currentApiKey = settings.embeddingApiKey.trim();

    await (_database.update(_database.readerPreferences)
          ..where((table) => table.id.equals(1)))
        .write(
      ReaderPreferencesCompanion(
        defaultEmbeddingAccessUnlocked: const Value(false),
        embeddingBaseUrl: Value(
          currentBaseUrl == defaultEmbeddingBaseUrl ? '' : currentBaseUrl,
        ),
        embeddingModel: Value(
          currentModel == defaultEmbeddingModel ? '' : currentModel,
        ),
        embeddingApiKey: Value(
          isBuiltinEmbeddingApiKeyPlaceholder(currentApiKey) ? '' : currentApiKey,
        ),
      ),
    );
  }

  ReaderSettings _mapRow(ReaderPreference? row) {
    if (row == null) {
      return const ReaderSettings(
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
    }

    return ReaderSettings(
      themeMode: ThemeMode.values.firstWhere(
        (mode) => mode.name == row.themeMode,
        orElse: () => ThemeMode.light,
      ),
      fontScale: row.fontScale,
      lineHeight: row.lineHeight,
      verseSpacing: row.verseSpacing,
      pageHorizontalPadding: row.pageHorizontalPadding,
      backgroundColorValue: row.backgroundColorValue,
      sliderSide: SliderSide.right,
      lastLocation: row.lastTranslationId == null ||
              row.lastBookId == null ||
              row.lastChapter == null
          ? null
          : BibleLocation(
              translationId: row.lastTranslationId!,
              bookId: row.lastBookId!,
              chapter: row.lastChapter!,
              verseStart: row.lastVerse,
            ),
      embeddingBaseUrl: row.embeddingBaseUrl.trim(),
      embeddingApiKey: row.embeddingApiKey.trim(),
      embeddingModel: row.embeddingModel.trim(),
      defaultEmbeddingAccessUnlocked: row.defaultEmbeddingAccessUnlocked,
    );
  }
}
