import 'bible_location.dart';

class SearchHit {
  const SearchHit({
    required this.location,
    required this.bookName,
    required this.translationTitle,
    required this.snippet,
    this.score,
  });

  final BibleLocation location;
  final String bookName;
  final String translationTitle;
  final String snippet;
  final double? score;
}
