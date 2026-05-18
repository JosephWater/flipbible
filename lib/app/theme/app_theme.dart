import 'package:flutter/material.dart';

class AppTheme {
  static const _bodyFontFamily = 'serif';
  static const _displayFontFamily = 'sans-serif';
  static const _defaultLightBackground = Color(0xFFFBF7EF);

  static ThemeData lightTheme(
    double fontScale, {
    Color? backgroundColor,
  }) {
    final paperBackground = backgroundColor ?? _defaultLightBackground;
    final paperSurface = _blendTowards(
      paperBackground,
      Colors.white,
      0.24,
    );
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF8B5E3C),
      brightness: Brightness.light,
      surface: paperSurface,
      primary: const Color(0xFF7B4E2F),
      secondary: const Color(0xFFC47B4F),
    );

    final base = ThemeData(
      colorScheme: scheme,
      scaffoldBackgroundColor: paperBackground,
      canvasColor: paperBackground,
      useMaterial3: true,
    );

    return base.copyWith(
      textTheme: _textTheme(base.textTheme, fontScale),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 22 * fontScale,
          fontWeight: FontWeight.w700,
          fontFamily: _displayFontFamily,
          letterSpacing: 0.2,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white.withValues(alpha: 0.75),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      popupMenuTheme: PopupMenuThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  static ThemeData darkTheme(double fontScale) {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFFD19A66),
      brightness: Brightness.dark,
      surface: const Color(0xFF171311),
      primary: const Color(0xFFE0A96D),
      secondary: const Color(0xFFB88152),
    );

    final base = ThemeData(
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFF110E0C),
      useMaterial3: true,
    );

    return base.copyWith(
      textTheme: _textTheme(base.textTheme, fontScale, isDark: true),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 22 * fontScale,
          fontWeight: FontWeight.w700,
          fontFamily: _displayFontFamily,
          letterSpacing: 0.2,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: const Color(0xFF1C1714),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF241D1A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: const Color(0xFF241D1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  static TextTheme _textTheme(
    TextTheme base,
    double fontScale, {
    bool isDark = false,
  }) {
    final color = isDark ? const Color(0xFFF3EBDD) : const Color(0xFF33251D);

    final body = base.apply(
      bodyColor: color,
      displayColor: color,
      fontFamily: _bodyFontFamily,
    );

    return body.copyWith(
      bodyLarge: body.bodyLarge?.copyWith(
        fontSize: 18 * fontScale,
        height: 1.8,
        color: color,
        fontFamily: _bodyFontFamily,
      ),
      bodyMedium: body.bodyMedium?.copyWith(
        fontSize: 15 * fontScale,
        height: 1.65,
        color: color,
        fontFamily: _bodyFontFamily,
      ),
      headlineMedium: body.headlineMedium?.copyWith(
        fontSize: 28 * fontScale,
        fontWeight: FontWeight.w800,
        color: color,
        fontFamily: _displayFontFamily,
      ),
      titleLarge: body.titleLarge?.copyWith(
        fontSize: 20 * fontScale,
        fontWeight: FontWeight.w700,
        color: color,
        fontFamily: _displayFontFamily,
      ),
      titleMedium: body.titleMedium?.copyWith(
        fontSize: 16 * fontScale,
        fontWeight: FontWeight.w600,
        color: color,
        fontFamily: _displayFontFamily,
      ),
      labelLarge: body.labelLarge?.copyWith(
        fontSize: 14 * fontScale,
        fontWeight: FontWeight.w600,
        color: color,
        fontFamily: _displayFontFamily,
      ),
    );
  }

  static Color _blendTowards(Color base, Color target, double amount) {
    return Color.alphaBlend(
      target.withValues(alpha: amount.clamp(0, 1).toDouble()),
      base,
    );
  }
}
