import 'dart:async';

import '../../../core/data/bible_repository.dart';
import '../../../core/data/reader_settings_repository.dart';
import '../../../core/data/recent_location_repository.dart';
import '../../../core/models/bible_location.dart';
import '../../../core/models/book_summary.dart';
import '../../../core/models/recent_location_entry.dart';

class ReaderJumpController {
  ReaderJumpController({
    required BibleRepository bibleRepository,
    required RecentLocationRepository recentLocationRepository,
    required ReaderSettingsRepository settingsRepository,
    FutureOr<BibleLocation?> Function()? onCaptureCurrentAnchor,
    void Function(BibleLocation location)? onLocationCommitted,
  })  : _bibleRepository = bibleRepository,
        _recentLocationRepository = recentLocationRepository,
        _settingsRepository = settingsRepository,
        _onCaptureCurrentAnchor = onCaptureCurrentAnchor,
        _onLocationCommitted = onLocationCommitted;

  final BibleRepository _bibleRepository;
  final RecentLocationRepository _recentLocationRepository;
  final ReaderSettingsRepository _settingsRepository;
  final FutureOr<BibleLocation?> Function()? _onCaptureCurrentAnchor;
  final void Function(BibleLocation location)? _onLocationCommitted;

  Future<void> jumpTo(
    BibleLocation location, {
    required RecentSource source,
    bool recordRecent = true,
    bool updateReadingAnchor = true,
    BibleLocation? bookmarkLocation,
  }) async {
    final prefetchFuture = _bibleRepository.prefetchChapter(location);
    BibleLocation? resolvedBookmarkLocation = bookmarkLocation;
    if (recordRecent) {
      final capturedAnchor = await _onCaptureCurrentAnchor?.call();
      resolvedBookmarkLocation = capturedAnchor ?? resolvedBookmarkLocation;
    }
    await _settingsRepository.saveLastLocation(location);
    if (updateReadingAnchor) {
      _onLocationCommitted?.call(
        location.copyWith(
          verseStart: location.verseStart ?? 1,
          clearVerseEnd: true,
        ),
      );
    }
    if (recordRecent) {
      await _recentLocationRepository.recordNavigation(
        resolvedBookmarkLocation ?? location,
        source,
      );
    }
    await prefetchFuture;
  }

  Future<void> switchTranslation(String translationId) async {
    await _bibleRepository.setActiveTranslation(translationId);
    final books = await _bibleRepository.listBooks(translationId);
    final firstBook = books.isEmpty ? null : books.first;
    await jumpTo(
      BibleLocation(
        translationId: translationId,
        bookId: firstBook?.id ?? 1,
        chapter: 1,
      ),
      source: RecentSource.directory,
      recordRecent: false,
    );
  }

  Future<void> jumpToNextChapter(BibleLocation current) async {
    final books = await _bibleRepository.listBooks(current.translationId);
    final activeBook = books.firstWhere(
      (book) => book.id == current.bookId,
      orElse: () => books.first,
    );

    if (current.chapter < activeBook.chapterCount) {
      await jumpTo(
        current.copyWith(
          chapter: current.chapter + 1,
          clearVerseStart: true,
          clearVerseEnd: true,
        ),
        source: RecentSource.directory,
        recordRecent: false,
        updateReadingAnchor: false,
      );
      return;
    }

    final nextBook = _nextBook(books, activeBook);
    if (nextBook == null) {
      return;
    }

    await jumpTo(
      BibleLocation(
        translationId: current.translationId,
        bookId: nextBook.id,
        chapter: 1,
      ),
      source: RecentSource.directory,
      recordRecent: false,
      updateReadingAnchor: false,
    );
  }

  Future<void> jumpToPreviousChapter(BibleLocation current) async {
    final books = await _bibleRepository.listBooks(current.translationId);
    final activeBook = books.firstWhere(
      (book) => book.id == current.bookId,
      orElse: () => books.first,
    );

    if (current.chapter > 1) {
      await jumpTo(
        current.copyWith(
          chapter: current.chapter - 1,
          clearVerseStart: true,
          clearVerseEnd: true,
        ),
        source: RecentSource.directory,
        recordRecent: false,
        updateReadingAnchor: false,
      );
      return;
    }

    final previousBook = _previousBook(books, activeBook);
    if (previousBook == null) {
      return;
    }

    await jumpTo(
      BibleLocation(
        translationId: current.translationId,
        bookId: previousBook.id,
        chapter: previousBook.chapterCount,
      ),
      source: RecentSource.directory,
      recordRecent: false,
      updateReadingAnchor: false,
    );
  }

  BookSummary? _nextBook(List<BookSummary> books, BookSummary currentBook) {
    final index = books.indexWhere((book) => book.id == currentBook.id);
    if (index < 0 || index == books.length - 1) {
      return null;
    }
    return books[index + 1];
  }

  BookSummary? _previousBook(List<BookSummary> books, BookSummary currentBook) {
    final index = books.indexWhere((book) => book.id == currentBook.id);
    if (index <= 0) {
      return null;
    }
    return books[index - 1];
  }
}
