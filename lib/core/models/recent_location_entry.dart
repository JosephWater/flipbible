import 'bible_location.dart';

enum RecentSource {
  slider,
  search,
  directory,
  recent,
}

class RecentLocationEntry {
  const RecentLocationEntry({
    required this.id,
    required this.location,
    required this.source,
    required this.createdAt,
    this.archivedAt,
  });

  final String id;
  final BibleLocation location;
  final RecentSource source;
  final DateTime createdAt;
  final DateTime? archivedAt;

  bool get isArchived => archivedAt != null;
}
