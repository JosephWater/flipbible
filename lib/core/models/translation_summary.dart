class TranslationSummary {
  const TranslationSummary({
    required this.id,
    required this.title,
    required this.language,
    required this.version,
    required this.copyright,
    required this.filePath,
    required this.isBuiltin,
    required this.isActive,
    required this.hasSearchIndex,
    required this.hasSemanticIndex,
  });

  final String id;
  final String title;
  final String language;
  final String version;
  final String copyright;
  final String filePath;
  final bool isBuiltin;
  final bool isActive;
  final bool hasSearchIndex;
  final bool hasSemanticIndex;
}
