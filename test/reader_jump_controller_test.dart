import 'package:flip_bible/core/data/bible_repository.dart';
import 'package:flip_bible/core/data/reader_settings_repository.dart';
import 'package:flip_bible/core/data/recent_location_repository.dart';
import 'package:flip_bible/core/models/bible_location.dart';
import 'package:flip_bible/core/models/book_summary.dart';
import 'package:flip_bible/core/models/recent_location_entry.dart';
import 'package:flip_bible/features/reader/application/reader_jump_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockBibleRepository extends Mock implements BibleRepository {}

class _MockRecentLocationRepository extends Mock
    implements RecentLocationRepository {}

class _MockReaderSettingsRepository extends Mock
    implements ReaderSettingsRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const BibleLocation(
        translationId: 'fallback',
        bookId: 1,
        chapter: 1,
      ),
    );
    registerFallbackValue(RecentSource.directory);
  });

  late _MockBibleRepository bibleRepository;
  late _MockRecentLocationRepository recentRepository;
  late _MockReaderSettingsRepository settingsRepository;
  late ReaderJumpController controller;

  setUp(() {
    bibleRepository = _MockBibleRepository();
    recentRepository = _MockRecentLocationRepository();
    settingsRepository = _MockReaderSettingsRepository();
    controller = ReaderJumpController(
      bibleRepository: bibleRepository,
      recentLocationRepository: recentRepository,
      settingsRepository: settingsRepository,
    );

    when(() => settingsRepository.saveLastLocation(any())).thenAnswer((_) async {});
    when(() => recentRepository.recordNavigation(any(), any())).thenAnswer((_) async {});
    when(() => bibleRepository.prefetchChapter(any())).thenAnswer((_) async {});
    when(() => bibleRepository.listBooks(any())).thenAnswer(
      (_) async => const [
        BookSummary(
          id: 1,
          abbreviation: '创',
          name: '创世记',
          testament: 'OT',
          sortOrder: 1,
          chapterCount: 50,
        ),
      ],
    );
    when(() => bibleRepository.setActiveTranslation(any())).thenAnswer((_) async {});
  });

  test('records explicit jumps to settings and recent locations', () async {
    const location = BibleLocation(
      translationId: 'builtin_cn_demo',
      bookId: 43,
      chapter: 1,
      verseStart: 4,
    );

    await controller.jumpTo(location, source: RecentSource.search);

    verify(() => settingsRepository.saveLastLocation(location)).called(1);
    verify(() => recentRepository.recordNavigation(location, RecentSource.search))
        .called(1);
  });

  test('prefers freshly captured anchor when recording explicit jump', () async {
    const currentAnchor = BibleLocation(
      translationId: 'builtin_cn_demo',
      bookId: 43,
      chapter: 1,
      verseStart: 18,
    );
    const destination = BibleLocation(
      translationId: 'builtin_cn_demo',
      bookId: 44,
      chapter: 3,
      verseStart: 16,
    );

    controller = ReaderJumpController(
      bibleRepository: bibleRepository,
      recentLocationRepository: recentRepository,
      settingsRepository: settingsRepository,
      onCaptureCurrentAnchor: () => currentAnchor,
    );

    await controller.jumpTo(
      destination,
      source: RecentSource.slider,
      bookmarkLocation: const BibleLocation(
        translationId: 'builtin_cn_demo',
        bookId: 40,
        chapter: 1,
        verseStart: 1,
      ),
    );

    verify(
      () => recentRepository.recordNavigation(currentAnchor, RecentSource.slider),
    ).called(1);
  });

  test('can skip reading anchor updates for chapter swipe style jumps', () async {
    const destination = BibleLocation(
      translationId: 'builtin_cn_demo',
      bookId: 44,
      chapter: 2,
    );
    BibleLocation? committedLocation;
    var capturedCalled = false;

    controller = ReaderJumpController(
      bibleRepository: bibleRepository,
      recentLocationRepository: recentRepository,
      settingsRepository: settingsRepository,
      onCaptureCurrentAnchor: () {
        capturedCalled = true;
        return const BibleLocation(
          translationId: 'builtin_cn_demo',
          bookId: 43,
          chapter: 1,
          verseStart: 18,
        );
      },
      onLocationCommitted: (location) {
        committedLocation = location;
      },
    );

    await controller.jumpTo(
      destination,
      source: RecentSource.directory,
      recordRecent: false,
      updateReadingAnchor: false,
    );

    expect(capturedCalled, isFalse);
    expect(committedLocation, isNull);
    verifyNever(() => recentRepository.recordNavigation(any(), any()));
    verify(() => settingsRepository.saveLastLocation(destination)).called(1);
  });

  test('translation switch activates translation without creating recent entry', () async {
    await controller.switchTranslation('imported_demo');

    verify(() => bibleRepository.setActiveTranslation('imported_demo')).called(1);
    verify(() => settingsRepository.saveLastLocation(any())).called(1);
    verifyNever(() => recentRepository.recordNavigation(any(), any()));
  });
}
