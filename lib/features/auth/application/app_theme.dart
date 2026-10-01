import 'package:dompetqu/core/theme/dompet_brand.dart';
import 'package:flutter/material.dart';

/// Palet mengikuti tema daisyUI di web (primary/brand). Scaffold awal.
class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    final scheme = ColorScheme.fromSeed(
      seedColor: DompetBrand.primary,
      brightness: Brightness.dark,
    );
    return _base(scheme, scaffoldBackground: DompetBrand.background);
  }

  /// Tema terang — padanan tema light daisyUI di web.
  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: DompetBrand.primary,
      brightness: Brightness.light,
    );
    return _base(scheme, scaffoldBackground: const Color(0xFFF5F5F7));
  }

  static ThemeData _base(
    ColorScheme scheme, {
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
        backgroundColor: DompetBrand.surface.withValues(alpha: 0.92),
        indicatorColor: DompetBrand.gold.withValues(alpha: 0.35),
        height: 68,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w600
                : FontWeight.w500,
            color: states.contains(WidgetState.selected)
                ? Colors.white
                : Colors.white60,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? DompetBrand.purple
                : Colors.white54,
          ),
        ),
      ),
    );
  }
}
