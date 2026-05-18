import 'package:flutter/material.dart';

import 'bible_location.dart';

enum SliderSide {
  right,
}

class ReaderSettings {
  const ReaderSettings({
    required this.themeMode,
    required this.fontScale,
    required this.lineHeight,
    this.verseSpacing = 10,
    this.pageHorizontalPadding = 18,
    this.backgroundColorValue = 0xFFFBF7EF,
    required this.sliderSide,
    required this.lastLocation,
    required this.embeddingBaseUrl,
    required this.embeddingApiKey,
    required this.embeddingModel,
    required this.defaultEmbeddingAccessUnlocked,
  });

  final ThemeMode themeMode;
  final double fontScale;
  final double lineHeight;
  final double verseSpacing;
  final double pageHorizontalPadding;
  final int backgroundColorValue;
  final SliderSide sliderSide;
  final BibleLocation? lastLocation;
  final String embeddingBaseUrl;
  final String embeddingApiKey;
  final String embeddingModel;
  final bool defaultEmbeddingAccessUnlocked;

  Color get backgroundColor => Color(backgroundColorValue);

  ReaderSettings copyWith({
    ThemeMode? themeMode,
    double? fontScale,
    double? lineHeight,
    double? verseSpacing,
    double? pageHorizontalPadding,
    int? backgroundColorValue,
    SliderSide? sliderSide,
    BibleLocation? lastLocation,
    String? embeddingBaseUrl,
    String? embeddingApiKey,
    String? embeddingModel,
    bool? defaultEmbeddingAccessUnlocked,
    bool clearLastLocation = false,
  }) {
    return ReaderSettings(
      themeMode: themeMode ?? this.themeMode,
      fontScale: fontScale ?? this.fontScale,
      lineHeight: lineHeight ?? this.lineHeight,
      verseSpacing: verseSpacing ?? this.verseSpacing,
      pageHorizontalPadding:
          pageHorizontalPadding ?? this.pageHorizontalPadding,
      backgroundColorValue: backgroundColorValue ?? this.backgroundColorValue,
      sliderSide: sliderSide ?? this.sliderSide,
      lastLocation:
          clearLastLocation ? null : lastLocation ?? this.lastLocation,
      embeddingBaseUrl: embeddingBaseUrl ?? this.embeddingBaseUrl,
      embeddingApiKey: embeddingApiKey ?? this.embeddingApiKey,
      embeddingModel: embeddingModel ?? this.embeddingModel,
      defaultEmbeddingAccessUnlocked: defaultEmbeddingAccessUnlocked ??
          this.defaultEmbeddingAccessUnlocked,
    );
  }
}
