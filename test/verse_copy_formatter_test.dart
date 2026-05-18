import 'package:flip_bible/core/models/book_summary.dart';
import 'package:flip_bible/core/models/chapter_content.dart';
import 'package:flip_bible/core/models/copy_settings.dart';
import 'package:flip_bible/core/models/translation_summary.dart';
import 'package:flip_bible/features/reader/application/verse_copy_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const chapter = ChapterContent(
    translation: TranslationSummary(
      id: 'cunp',
      title: '和合本',
      language: 'zh',
      version: '1',
      copyright: '',
      filePath: '',
      isBuiltin: true,
      isActive: true,
      hasSearchIndex: true,
      hasSemanticIndex: true,
    ),
    book: BookSummary(
      id: 43,
      abbreviation: '约',
      name: '约翰福音',
      testament: 'NT',
      sortOrder: 43,
      chapterCount: 21,
    ),
    chapter: 3,
    verses: [
      VerseContent(verse: 15, text: '叫一切信他的都得永生。'),
      VerseContent(verse: 16, text: '神爱世人，甚至将他的独生子赐给他们。'),
      VerseContent(verse: 17, text: '因为神差他的儿子降世。'),
    ],
  );

  test('format 1 includes header and verse numbers by default', () {
    final result = formatSelectedVersesForCopy(
      chapter: chapter,
      selectedVerses: const [15, 16, 17],
      settings: const CopySettings.defaults(),
    );

    expect(result, startsWith('约翰福音 3:15-17\n      15 叫一切信他的都得永生。 16 神爱世人'));
  });

  test('format 2 appends trailing citation', () {
    final result = formatSelectedVersesForCopy(
      chapter: chapter,
      selectedVerses: const [15, 16],
      settings: const CopySettings(
        format: CopyFormat.format2,
        showVerseNumbers: true,
      ),
    );

    expect(result, contains('( 约翰福音 3:15-16 和合本 )'));
  });

  test('format 3 can hide verse numbers', () {
    final result = formatSelectedVersesForCopy(
      chapter: chapter,
      selectedVerses: const [16, 17],
      settings: const CopySettings(
        format: CopyFormat.format3,
        showVerseNumbers: false,
      ),
    );

    expect(result, isNot(contains('16 ')));
    expect(result, contains('神爱世人，甚至将他的独生子赐给他们。'));
    expect(result, contains('\n\n因为神差他的儿子降世。'));
  });
}
