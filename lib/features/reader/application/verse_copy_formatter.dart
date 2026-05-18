import '../../../core/models/chapter_content.dart';
import '../../../core/models/copy_settings.dart';

String formatSelectedVersesForCopy({
  required ChapterContent chapter,
  required List<int> selectedVerses,
  required CopySettings settings,
}) {
  final orderedNumbers = [...selectedVerses]..sort();
  final verseMap = {
    for (final verse in chapter.verses) verse.verse: verse,
  };
  final verses = [
    for (final number in orderedNumbers)
      if (verseMap[number] != null) verseMap[number]!,
  ];

  if (verses.isEmpty) {
    return '';
  }

  final reference =
      '${chapter.book.name} ${chapter.chapter}:${_formatVerseRanges(orderedNumbers)}';

  switch (settings.format) {
    case CopyFormat.format1:
      final body = verses
          .map(
            (verse) => settings.showVerseNumbers
                ? '${verse.verse} ${_singleLineText(verse.text)}'
                : _singleLineText(verse.text),
          )
          .join(' ');
      return '$reference\n      $body';
    case CopyFormat.format2:
      final body = verses
          .map(
            (verse) => settings.showVerseNumbers
                ? '${verse.verse}${_inlineParentheticalText(verse.text)}'
                : _inlineParentheticalText(verse.text),
          )
          .join(' ');
      return '$body ( $reference ${chapter.translation.title} )';
    case CopyFormat.format3:
      return verses
          .map(
            (verse) => settings.showVerseNumbers
                ? '${verse.verse} ${verse.text.trim()}'
                : verse.text.trim(),
          )
          .join('\n\n');
  }
}

String _singleLineText(String text) {
  return text.replaceAll(RegExp(r'\s+'), ' ').trim();
}

String _inlineParentheticalText(String text) {
  return _singleLineText(text)
      .replaceAll('〔', '（')
      .replaceAll('〕', '）');
}

String _formatVerseRanges(List<int> verses) {
  if (verses.isEmpty) {
    return '';
  }

  final ranges = <String>[];
  var start = verses.first;
  var end = verses.first;

  for (final verse in verses.skip(1)) {
    if (verse == end + 1) {
      end = verse;
      continue;
    }

    ranges.add(start == end ? '$start' : '$start-$end');
    start = verse;
    end = verse;
  }

  ranges.add(start == end ? '$start' : '$start-$end');
  return ranges.join(',');
}
