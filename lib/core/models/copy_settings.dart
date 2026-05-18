enum CopyFormat {
  format1,
  format2,
  format3,
}

class CopySettings {
  const CopySettings({
    required this.format,
    required this.showVerseNumbers,
  });

  const CopySettings.defaults()
      : format = CopyFormat.format1,
        showVerseNumbers = true;

  final CopyFormat format;
  final bool showVerseNumbers;

  CopySettings copyWith({
    CopyFormat? format,
    bool? showVerseNumbers,
  }) {
    return CopySettings(
      format: format ?? this.format,
      showVerseNumbers: showVerseNumbers ?? this.showVerseNumbers,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'format': format.name,
      'showVerseNumbers': showVerseNumbers,
    };
  }

  factory CopySettings.fromJson(Map<String, Object?> json) {
    final rawFormat = json['format'];
    final rawShowVerseNumbers = json['showVerseNumbers'];

    return CopySettings(
      format: CopyFormat.values.firstWhere(
        (value) => value.name == rawFormat,
        orElse: () => CopyFormat.format1,
      ),
      showVerseNumbers: rawShowVerseNumbers is bool ? rawShowVerseNumbers : true,
    );
  }
}
