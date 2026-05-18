class BibleLocation {
  const BibleLocation({
    required this.translationId,
    required this.bookId,
    required this.chapter,
    this.verseStart,
    this.verseEnd,
  });

  final String translationId;
  final int bookId;
  final int chapter;
  final int? verseStart;
  final int? verseEnd;

  BibleLocation copyWith({
    String? translationId,
    int? bookId,
    int? chapter,
    int? verseStart,
    int? verseEnd,
    bool clearVerseStart = false,
    bool clearVerseEnd = false,
  }) {
    return BibleLocation(
      translationId: translationId ?? this.translationId,
      bookId: bookId ?? this.bookId,
      chapter: chapter ?? this.chapter,
      verseStart: clearVerseStart ? null : verseStart ?? this.verseStart,
      verseEnd: clearVerseEnd ? null : verseEnd ?? this.verseEnd,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'translationId': translationId,
      'bookId': bookId,
      'chapter': chapter,
      'verseStart': verseStart,
      'verseEnd': verseEnd,
    };
  }

  @override
  bool operator ==(Object other) {
    return other is BibleLocation &&
        other.translationId == translationId &&
        other.bookId == bookId &&
        other.chapter == chapter &&
        other.verseStart == verseStart &&
        other.verseEnd == verseEnd;
  }

  @override
  int get hashCode => Object.hash(
        translationId,
        bookId,
        chapter,
        verseStart,
        verseEnd,
      );
}
