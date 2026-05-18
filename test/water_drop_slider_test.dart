import 'package:flip_bible/core/models/bible_location.dart';
import 'package:flip_bible/core/models/book_summary.dart';
import 'package:flip_bible/features/reader/presentation/water_drop_slider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows overlay during long press and commits selected location',
      (tester) async {
    BibleLocation? committed;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.centerRight,
            child: WaterDropSlider(
              books: const [
                BookSummary(
                  id: 1,
                  abbreviation: '创',
                  name: '创世记',
                  testament: 'OT',
                  sortOrder: 1,
                  chapterCount: 50,
                ),
                BookSummary(
                  id: 2,
                  abbreviation: '出',
                  name: '出埃及记',
                  testament: 'OT',
                  sortOrder: 2,
                  chapterCount: 40,
                ),
              ],
              currentLocation: const BibleLocation(
                translationId: 'builtin_cn_demo',
                bookId: 1,
                chapter: 1,
              ),
              onCommit: (location) => committed = location,
            ),
          ),
        ),
      ),
    );

    final handle = find.byKey(const Key('book-handle'));
    final gesture = await tester.startGesture(tester.getCenter(handle));
    await tester.pump(kLongPressTimeout + const Duration(milliseconds: 60));
    expect(find.byKey(const Key('slider-overlay')), findsOneWidget);

    await gesture.moveBy(const Offset(0, 170));
    await tester.pump(const Duration(milliseconds: 120));
    await gesture.up();
    await tester.pumpAndSettle();

    expect(committed, isNotNull);
    expect(committed!.translationId, 'builtin_cn_demo');
  });
}
