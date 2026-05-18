import 'package:drift/native.dart';
import 'package:flip_bible/core/data/app_database.dart';
import 'package:flip_bible/core/data/reader_settings_repository.dart';
import 'package:flip_bible/core/data/semantic_search_defaults.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late ReaderSettingsRepository repository;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = ReaderSettingsRepository(database);
    await repository.ensureInitialized();
  });

  tearDown(() async {
    await database.close();
  });

  test('preserves blank semantic fields until runtime config is resolved', () async {
    final settings = await repository.getSettings();

    expect(settings.embeddingBaseUrl, isEmpty);
    expect(settings.embeddingApiKey, isEmpty);
    expect(settings.embeddingModel, isEmpty);
    expect(settings.defaultEmbeddingAccessUnlocked, isFalse);
  });

  test('enable default semantic access provisions built-in configuration', () async {
    await repository.enableDefaultSemanticAccess();

    final settings = await repository.getSettings();

    expect(settings.defaultEmbeddingAccessUnlocked, isTrue);
    expect(settings.embeddingBaseUrl, defaultEmbeddingBaseUrl);
    expect(settings.embeddingModel, defaultEmbeddingModel);
    expect(
      settings.embeddingApiKey,
      builtinEmbeddingApiKeyPlaceholder,
    );
  });
}
