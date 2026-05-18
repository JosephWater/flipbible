import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/bible_location.dart';
import '../models/book_summary.dart';
import '../models/chapter_content.dart';
import '../models/copy_settings.dart';
import '../models/recent_location_entry.dart';
import '../models/reader_settings.dart';
import '../models/search_hit.dart';
import '../models/translation_summary.dart';
import '../../features/reader/application/reader_jump_controller.dart';
import 'app_database.dart';
import 'bible_repository.dart';
import 'copy_settings_repository.dart';
import 'package_import_service.dart';
import 'reader_settings_repository.dart';
import 'recent_location_repository.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

final settingsRepositoryProvider = Provider<ReaderSettingsRepository>((ref) {
  return ReaderSettingsRepository(ref.watch(appDatabaseProvider));
});

final copySettingsRepositoryProvider = Provider<CopySettingsRepository>((ref) {
  final repository = CopySettingsRepository();
  ref.onDispose(repository.dispose);
  return repository;
});

final recentLocationRepositoryProvider = Provider<RecentLocationRepository>((ref) {
  return RecentLocationRepository(ref.watch(appDatabaseProvider));
});

final bibleRepositoryProvider = Provider<BibleRepository>((ref) {
  return BibleRepository(
    ref.watch(appDatabaseProvider),
    settingsRepository: ref.watch(settingsRepositoryProvider),
  );
});

final packageImportServiceProvider = Provider<PackageImportService>((ref) {
  return PackageImportService(ref.watch(appDatabaseProvider));
});

final readerJumpControllerProvider = Provider<ReaderJumpController>((ref) {
  return ReaderJumpController(
    bibleRepository: ref.watch(bibleRepositoryProvider),
    recentLocationRepository: ref.watch(recentLocationRepositoryProvider),
    settingsRepository: ref.watch(settingsRepositoryProvider),
    onCaptureCurrentAnchor: () {
      return ref.read(readingAnchorCaptureProvider.notifier).capture();
    },
    onLocationCommitted: (location) {
      ref.read(currentReadingAnchorProvider.notifier).set(location);
    },
  );
});

final appBootstrapProvider = FutureProvider<void>((ref) async {
  final settingsRepository = ref.watch(settingsRepositoryProvider);
  final packageImportService = ref.watch(packageImportServiceProvider);
  final bibleRepository = ref.watch(bibleRepositoryProvider);

  await settingsRepository.ensureInitialized();
  await packageImportService.bootstrapBundledTranslation();
  final translations = await bibleRepository.listTranslations();
  if (translations.isNotEmpty) {
    await settingsRepository.ensureLastLocation(translations.first.id);
  }
});

final readerSettingsProvider = StreamProvider<ReaderSettings>((ref) {
  ref.watch(appBootstrapProvider);
  return ref.watch(settingsRepositoryProvider).watchSettings();
});

final copySettingsProvider = StreamProvider<CopySettings>((ref) {
  return ref.watch(copySettingsRepositoryProvider).watchSettings();
});

final currentReadingAnchorProvider =
    NotifierProvider<CurrentReadingAnchorNotifier, BibleLocation?>(
  CurrentReadingAnchorNotifier.new,
);

final readingAnchorCaptureProvider = NotifierProvider<
    ReadingAnchorCaptureNotifier, ReadingAnchorCaptureRegistration?>(
  ReadingAnchorCaptureNotifier.new,
);

final currentLocationProvider = StreamProvider<BibleLocation?>((ref) {
  return ref.watch(settingsRepositoryProvider).watchSettings().map(
        (settings) => settings.lastLocation,
      );
});

final activeTranslationIdProvider = FutureProvider<String?>((ref) async {
  final settings = await ref.watch(settingsRepositoryProvider).getSettings();
  return settings.lastLocation?.translationId;
});

final activeTranslationProvider =
    FutureProvider<TranslationSummary?>((ref) async {
  final translationId = await ref.watch(activeTranslationIdProvider.future);
  if (translationId == null) {
    return null;
  }
  return ref.watch(bibleRepositoryProvider).getTranslation(translationId);
});

final translationsProvider = StreamProvider<List<TranslationSummary>>((ref) {
  ref.watch(appBootstrapProvider);
  return ref.watch(bibleRepositoryProvider).watchTranslations();
});

final booksProvider =
    FutureProvider.family<List<BookSummary>, String>((ref, translationId) {
  return ref.watch(bibleRepositoryProvider).listBooks(translationId);
});

final chapterContentProvider =
    FutureProvider.family<ChapterContent, BibleLocation>((ref, location) {
  ref.watch(appBootstrapProvider);
  return ref.watch(bibleRepositoryProvider).loadChapter(location);
});

final recentLocationsProvider = StreamProvider<List<RecentLocationEntry>>((ref) {
  ref.watch(appBootstrapProvider);
  return ref.watch(recentLocationRepositoryProvider).watchRecent();
});

final locationLabelProvider =
    FutureProvider.family<String, BibleLocation>((ref, location) {
  return ref.watch(bibleRepositoryProvider).formatLocation(location);
});

final searchResultsProvider =
    FutureProvider.autoDispose.family<List<SearchHit>, String>((ref, query) async {
  ref.watch(appBootstrapProvider);
  final translationId = await ref.watch(activeTranslationIdProvider.future);
  final cleaned = query.trim();
  if (cleaned.isEmpty || translationId == null) {
    return const [];
  }

  return ref.watch(bibleRepositoryProvider).search(cleaned, translationId);
});

final semanticSearchResultsProvider =
    FutureProvider.autoDispose.family<List<SearchHit>, String>((ref, query) async {
  ref.watch(appBootstrapProvider);
  final translationId = await ref.watch(activeTranslationIdProvider.future);
  final cleaned = query.trim();
  if (cleaned.isEmpty || translationId == null) {
    return const [];
  }

  return ref.watch(bibleRepositoryProvider).semanticSearch(cleaned, translationId);
});

final similarVersesProvider = FutureProvider.autoDispose
    .family<List<SearchHit>, BibleLocation>((ref, location) async {
  ref.watch(appBootstrapProvider);
  return ref.watch(bibleRepositoryProvider).getSimilarVersesForVerse(location);
});

class CurrentReadingAnchorNotifier extends Notifier<BibleLocation?> {
  @override
  BibleLocation? build() => null;

  void set(BibleLocation? value) {
    state = value;
  }
}

class ReadingAnchorCaptureRegistration {
  const ReadingAnchorCaptureRegistration({
    required this.owner,
    required this.callback,
  });

  final Object owner;
  final FutureOr<BibleLocation?> Function() callback;
}

class ReadingAnchorCaptureNotifier
    extends Notifier<ReadingAnchorCaptureRegistration?> {
  @override
  ReadingAnchorCaptureRegistration? build() => null;

  void register(
    Object owner,
    FutureOr<BibleLocation?> Function() callback,
  ) {
    state = ReadingAnchorCaptureRegistration(
      owner: owner,
      callback: callback,
    );
  }

  void unregister(Object owner) {
    if (state?.owner == owner) {
      state = null;
    }
  }

  Future<BibleLocation?> capture() async {
    final callback = state?.callback;
    if (callback == null) {
      return null;
    }
    return await callback();
  }
}
