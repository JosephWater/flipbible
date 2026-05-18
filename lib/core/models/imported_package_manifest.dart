class ImportedPackageManifest {
  const ImportedPackageManifest({
    required this.id,
    required this.title,
    required this.language,
    required this.version,
    required this.copyright,
    required this.hasSearchIndex,
    required this.hasSemanticIndex,
  });

  final String id;
  final String title;
  final String language;
  final String version;
  final String copyright;
  final bool hasSearchIndex;
  final bool hasSemanticIndex;

  factory ImportedPackageManifest.fromJson(Map<String, dynamic> json) {
    return ImportedPackageManifest(
      id: json['id'] as String,
      title: json['title'] as String,
      language: json['language'] as String,
      version: json['version'] as String,
      copyright: json['copyright'] as String,
      hasSearchIndex: json['hasSearchIndex'] as bool? ?? false,
      hasSemanticIndex: json['hasSemanticIndex'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'language': language,
      'version': version,
      'copyright': copyright,
      'hasSearchIndex': hasSearchIndex,
      'hasSemanticIndex': hasSemanticIndex,
    };
  }
}
