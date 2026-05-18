class BookSummary {
  const BookSummary({
    required this.id,
    required this.abbreviation,
    required this.name,
    required this.testament,
    required this.sortOrder,
    required this.chapterCount,
  });

  final int id;
  final String abbreviation;
  final String name;
  final String testament;
  final int sortOrder;
  final int chapterCount;
}
