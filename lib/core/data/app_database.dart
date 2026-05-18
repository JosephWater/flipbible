import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class InstalledTranslations extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get language => text()();
  TextColumn get version => text()();
  TextColumn get copyright => text()();
  TextColumn get filePath => text()();
  BoolColumn get isBuiltin => boolean().withDefault(const Constant(false))();
  BoolColumn get isActive => boolean().withDefault(const Constant(false))();
  BoolColumn get hasSearchIndex =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get hasSemanticIndex =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get installedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class RecentLocations extends Table {
  TextColumn get id => text()();
  TextColumn get translationId => text()();
  IntColumn get bookId => integer()();
  IntColumn get chapter => integer()();
  IntColumn get verseStart => integer().nullable()();
  IntColumn get verseEnd => integer().nullable()();
  TextColumn get source => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get archivedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class ReaderPreferences extends Table {
  IntColumn get id => integer()();
  TextColumn get themeMode =>
      text().withDefault(const Constant('light'))();
  RealColumn get fontScale => real().withDefault(const Constant(1.0))();
  RealColumn get lineHeight => real().withDefault(const Constant(1.75))();
  RealColumn get verseSpacing => real().withDefault(const Constant(10.0))();
  RealColumn get pageHorizontalPadding =>
      real().withDefault(const Constant(18.0))();
  IntColumn get backgroundColorValue =>
      integer().withDefault(const Constant(0xFFFBF7EF))();
  TextColumn get sliderSide =>
      text().withDefault(const Constant('right'))();
  TextColumn get lastTranslationId => text().nullable()();
  IntColumn get lastBookId => integer().nullable()();
  IntColumn get lastChapter => integer().nullable()();
  IntColumn get lastVerse => integer().nullable()();
  TextColumn get embeddingBaseUrl =>
      text().withDefault(const Constant(''))();
  TextColumn get embeddingApiKey =>
      text().withDefault(const Constant(''))();
  TextColumn get embeddingModel =>
      text().withDefault(const Constant(''))();
  BoolColumn get defaultEmbeddingAccessUnlocked =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    InstalledTranslations,
    RecentLocations,
    ReaderPreferences,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (migrator, from, to) async {
          if (from < 2) {
            await migrator.addColumn(
              installedTranslations,
              installedTranslations.hasSemanticIndex,
            );
            await migrator.addColumn(
              readerPreferences,
              readerPreferences.embeddingBaseUrl,
            );
            await migrator.addColumn(
              readerPreferences,
              readerPreferences.embeddingApiKey,
            );
            await migrator.addColumn(
              readerPreferences,
              readerPreferences.embeddingModel,
            );
          }
          if (from < 3) {
            await migrator.addColumn(
              readerPreferences,
              readerPreferences.verseSpacing,
            );
          }
          if (from < 4) {
            await customStatement(
              'ALTER TABLE reader_preferences '
              'ADD COLUMN default_embedding_access_unlocked '
              'INTEGER NOT NULL DEFAULT 0',
            );
          }
          if (from < 5) {
            await migrator.addColumn(
              readerPreferences,
              readerPreferences.pageHorizontalPadding,
            );
            await migrator.addColumn(
              readerPreferences,
              readerPreferences.backgroundColorValue,
            );
          }
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final appDirectory = await getApplicationSupportDirectory();
    final file = File(p.join(appDirectory.path, 'flipbible_app.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
