import 'package:flutter/material.dart';

import 'ui_style.dart';

/// Tema dibuat dari [UiStyle] sehingga warna, gradient, opacity, dan blur
/// dapat dikendalikan saat runtime (lihat `ui_style_controller.dart`).
class AppTheme {
  AppTheme._();

  /// Tema gelap bawaan (pakai [UiStyle] default).
  static ThemeData get dark => fromStyle(const UiStyle(), brightness: Brightness.dark);

  /// Tema terang bawaan (pakai [UiStyle] default).
  static ThemeData get light => fromStyle(const UiStyle(), brightness: Brightness.light);

  /// Bangun [ThemeData] dari [style] dan [brightness].
  static ThemeData fromStyle(
    UiStyle style, {
    required Brightness brightness,
  }) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: style.primary,
      primary: style.primary,
      secondary: style.secondary,
      tertiary: style.tertiary,
      brightness: brightness,
    );
    return _base(
      scheme,
      style: style,
      scaffoldBackground: isDark
          ? const Color(0xFF0A0A0A)
          : const Color(0xFFF5F5F7),
    );
  }

  static ThemeData _base(
    ColorScheme scheme, {
    required UiStyle style,
    required Color scaffoldBackground,
  }) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffoldBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: style.primary,
          foregroundColor: style.primary.computeLuminance() > 0.5
              ? Colors.black
              : Colors.white,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFF121212).withValues(
          alpha: (style.glassOpacity * 8).clamp(0.0, 1.0),
        ),
        indicatorColor: style.primary.withValues(alpha: 0.35),
        height: 68,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w600
                : FontWeight.w500,
            color: states.contains(WidgetState.selected)
                ? style.primary
                : Colors.white60,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? style.secondary
                : Colors.white54,
          ),
        ),
      ),
    );
  }
}