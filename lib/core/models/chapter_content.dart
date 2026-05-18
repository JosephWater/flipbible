import 'book_summary.dart';
import 'translation_summary.dart';

class ChapterContent {
  const ChapterContent({
    required this.translation,
    required this.book,
    required this.chapter,
    required this.verses,
  });

  final TranslationSummary translation;
  final BookSummary book;
  final int chapter;
  final List<VerseContent> verses;
}

class VerseContent {
  const VerseContent({
    required this.verse,
    required this.text,
  });

  final int verse;
  final String text;
}
