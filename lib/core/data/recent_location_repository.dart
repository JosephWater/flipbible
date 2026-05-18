import 'package:drift/drift.dart';

import '../models/bible_location.dart';
import '../models/recent_location_entry.dart';
import 'app_database.dart';

class RecentLocationRepository {
  RecentLocationRepository(this._database);

  final AppDatabase _database;

  Stream<List<RecentLocationEntry>> watchRecent({
    bool includeArchived = false,
  }) {
    final query = _database.select(_database.recentLocations)
      ..orderBy([
        (table) => OrderingTerm(
              expression: table.createdAt,
              mode: OrderingMode.desc,
            ),
      ]);

    if (!includeArchived) {
      query.where((table) => table.archivedAt.isNull());
    }

    return query.watch().map(
          (rows) => rows.map(_mapRow).toList(),
        );
  }

  Future<void> recordNavigation(
    BibleLocation location,
    RecentSource source,
  ) async {
    final existing = await (_database.select(_database.recentLocations)
          ..where(
            (table) =>
                table.translationId.equals(location.translationId) &
                table.bookId.equals(location.bookId) &
                table.chapter.equals(location.chapter) &
                table.verseStart.equalsNullable(location.verseStart) &
                table.verseEnd.equalsNullable(location.verseEnd),
          ))
        .getSingleOrNull();

    final now = DateTime.now();
    if (existing != null) {
      await (_database.update(_database.recentLocations)
            ..where((table) => table.id.equals(existing.id)))
          .write(
        RecentLocationsCompanion(
          source: Value(source.name),
          createdAt: Value(now),
          archivedAt: const Value(null),
        ),
      );
    } else {
      await _database.into(_database.recentLocations).insert(
            RecentLocationsCompanion.insert(
              id: '${location.translationId}-${location.bookId}-${location.chapter}-${location.verseStart ?? 0}-${location.verseEnd ?? 0}',
              translationId: location.translationId,
              bookId: location.bookId,
              chapter: location.chapter,
              verseStart: Value(location.verseStart),
              verseEnd: Value(location.verseEnd),
              source: source.name,
              createdAt: now,
              archivedAt: const Value(null),
            ),
          );
    }

    final activeEntries = await (_database.select(_database.recentLocations)
          ..where((table) => table.archivedAt.isNull())
          ..orderBy([
            (table) => OrderingTerm(
                  expression: table.createdAt,
                  mode: OrderingMode.desc,
                ),
          ]))
        .get();

    if (activeEntries.length > 10) {
      for (final entry in activeEntries.skip(10)) {
        await (_database.delete(_database.recentLocations)
              ..where((table) => table.id.equals(entry.id)))
            .go();
      }
    }
  }

  Future<void> archive(String id) async {
    await (_database.update(_database.recentLocations)
          ..where((table) => table.id.equals(id)))
        .write(
      RecentLocationsCompanion(archivedAt: Value(DateTime.now())),
    );
  }

  Future<void> delete(String id) async {
    await (_database.delete(_database.recentLocations)
          ..where((table) => table.id.equals(id)))
        .go();
  }

  Future<void> clearRecent() async {
    await (_database.delete(_database.recentLocations)
          ..where((table) => table.archivedAt.isNull()))
        .go();
  }

  RecentLocationEntry _mapRow(RecentLocation row) {
    return RecentLocationEntry(
      id: row.id,
      location: BibleLocation(
        translationId: row.translationId,
        bookId: row.bookId,
        chapter: row.chapter,
        verseStart: row.verseStart,
        verseEnd: row.verseEnd,
      ),
      source: RecentSource.values.firstWhere(
        (value) => value.name == row.source,
        orElse: () => RecentSource.directory,
      ),
      createdAt: row.createdAt,
      archivedAt: row.archivedAt,
    );
  }
}
