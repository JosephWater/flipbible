import 'package:flip_bible/core/data/app_providers.dart';
import 'package:flip_bible/core/data/recent_location_repository.dart';
import 'package:flip_bible/core/models/bible_location.dart';
import 'package:flip_bible/core/models/recent_location_entry.dart';
import 'package:flip_bible/features/reader/application/reader_jump_controller.dart';
import 'package:flip_bible/features/reader/presentation/recent_locations_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRecentLocationRepository extends Mock
    implements RecentLocationRepository {}

class _FakeReaderJumpController extends Fake implements ReaderJumpController {}

void main() {
  testWidgets('long press archives a recent location chip', (tester) async {
    final repository = _MockRecentLocationRepository();
    when(() => repository.archive('recent-1')).thenAnswer((_) async {});
    when(() => repository.delete(any())).thenAnswer((_) async {});

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appBootstrapProvider.overrideWith((ref) async {}),
          recentLocationRepositoryProvider.overrideWithValue(repository),
          recentLocationsProvider.overrideWith(
            (ref) => Stream.value(
              [
                RecentLocationEntry(
                  id: 'recent-1',
                  location: const BibleLocation(
                    translationId: 'builtin_cn_demo',
                    bookId: 1,
                    chapter: 1,
                  ),
                  source: RecentSource.directory,
                  createdAt: DateTime(2024),
                ),
              ],
            ),
          ),
          locationLabelProvider.overrideWith(
            (ref, location) async => '创世记 1',
          ),
          readerJumpControllerProvider.overrideWithValue(
            _FakeReaderJumpController(),
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(body: RecentLocationsBar()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('创世记 1'), findsOneWidget);
    await tester.longPress(find.text('创世记 1'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('归档'));
    await tester.pumpAndSettle();
    verify(() => repository.archive('recent-1')).called(1);
  });
}
