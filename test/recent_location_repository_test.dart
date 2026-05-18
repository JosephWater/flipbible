import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flip_bible/core/data/app_database.dart';
import 'package:flip_bible/core/data/recent_location_repository.dart';
import 'package:flip_bible/core/models/bible_location.dart';
import 'package:flip_bible/core/models/recent_location_entry.dart';

void main() {
  late AppDatabase database;
  late RecentLocationRepository repository;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = RecentLocationRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('deduplicates and moves repeated location to top', () async {
    const location = BibleLocation(
      translationId: 'builtin_cn_demo',
      bookId: 1,
      chapter: 1,
      verseStart: 1,
    );

    await repository.recordNavigation(location, RecentSource.search);
    await repository.recordNavigation(
      const BibleLocation(
        translationId: 'builtin_cn_demo',
        bookId: 1,
        chapter: 2,
      ),
      RecentSource.slider,
    );
    await repository.recordNavigation(location, RecentSource.directory);

    final items = await repository.watchRecent().first;
    expect(items, hasLength(2));
    expect(items.first.location, location);
    expect(items.first.source, RecentSource.directory);
  });

  test('keeps only the latest ten active entries', () async {
    for (var i = 1; i <= 12; i++) {
      await repository.recordNavigation(
        BibleLocation(
          translationId: 'builtin_cn_demo',
          bookId: i,
          chapter: 1,
        ),
        RecentSource.slider,
      );
      await Future<void>.delayed(const Duration(milliseconds: 1));
    }

    final items = await repository.watchRecent().first;
    expect(items, hasLength(10));
    expect(items.length, lessThanOrEqualTo(10));
  });

  test('archives and deletes entries', () async {
    const location = BibleLocation(
      translationId: 'builtin_cn_demo',
      bookId: 19,
      chapter: 23,
    );
    await repository.recordNavigation(location, RecentSource.directory);
    final item = (await repository.watchRecent().first).single;

    await repository.archive(item.id);
    expect(await repository.watchRecent().first, isEmpty);
    expect(await repository.watchRecent(includeArchived: true).first, hasLength(1));

    await repository.delete(item.id);
    expect(await repository.watchRecent(includeArchived: true).first, isEmpty);
  });
}
