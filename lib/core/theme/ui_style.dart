import 'dart:convert';

import 'package:flutter/material.dart';

/// Nilai tampilan yang dapat dikendalikan saat runtime — sumber kebenaran
/// warna (primary/secondary/tertiary), gradient, opacity glass, dan blur.
///
/// Satu-satunya tempat mengatur "look & feel" aplikasi. Widget membaca lewat
/// [UiStyleController.uiStyleControllerProvider] (lihat `ui_style_controller.dart`),
/// dan tema dibangun dari instance ini via `AppTheme.fromStyle(...)`.
class UiStyle {
  const UiStyle({
    this.primary = kUiPrimary,
    this.secondary = kUiSecondary,
    this.tertiary = kUiTertiary,
    this.gradientColors = kUiGradientColors,
    this.gradientBegin = Alignment.topLeft,
    this.gradientEnd = Alignment.bottomRight,
    this.glassOpacity = kUiGlassOpacity,
    this.blurSigma = kUiBlurSigma,
  });

  /// Warna utama (brand) — seed `ColorScheme`.
  final Color primary;

  /// Warna sekunder (akcent).
  final Color secondary;

  /// Warna tersier.
  final Color tertiary;

  /// Daftar warna yang menyusun gradient (gradient picker).
  final List<Color> gradientColors;

  /// Titik awal arah gradient.
  final Alignment gradientBegin;

  /// Titik akhir arah gradient.
  final Alignment gradientEnd;

  /// Opacity isi frosted glass (0.0–1.0) — opacity picker.
  final double glassOpacity;

  /// Radius sigma blur `BackdropFilter` (0 = blur nonaktif) — blur picker.
  final double blurSigma;

  /// `true` selama [blurSigma] > 0.
  bool get hasBlur => blurSigma > 0;

  /// Gradient LinearGradient sesuai [gradientColors] + arah picker.
  LinearGradient get gradient => LinearGradient(
    colors: gradientColors,
    begin: gradientBegin,
    end: gradientEnd,
  );

  /// Warna isi frosted glass dari [primary] dengan [glassOpacity].
  Color get glassFill => primary.withValues(alpha: glassOpacity);

  /// Border glass tipis dari [primary] berbasis [glassOpacity].
  Color get glassBorder => primary.withValues(
    alpha: (glassOpacity * 3).clamp(0.0, 1.0),
  );

  UiStyle copyWith({
    Color? primary,
    Color? secondary,
    Color? tertiary,
    List<Color>? gradientColors,
    Alignment? gradientBegin,
    Alignment? gradientEnd,
    double? glassOpacity,
    double? blurSigma,
  }) => UiStyle(
    primary: primary ?? this.primary,
    secondary: secondary ?? this.secondary,
    tertiary: tertiary ?? this.tertiary,
    gradientColors: gradientColors ?? this.gradientColors,
    gradientBegin: gradientBegin ?? this.gradientBegin,
    gradientEnd: gradientEnd ?? this.gradientEnd,
    glassOpacity: glassOpacity ?? this.glassOpacity,
    blurSigma: blurSigma ?? this.blurSigma,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UiStyle &&
          primary == other.primary &&
          secondary == other.secondary &&
          tertiary == other.tertiary &&
          _listEquals(gradientColors, other.gradientColors) &&
          gradientBegin == other.gradientBegin &&
          gradientEnd == other.gradientEnd &&
          glassOpacity == other.glassOpacity &&
          blurSigma == other.blurSigma;

  @override
  int get hashCode => Object.hash(
    primary,
    secondary,
    tertiary,
    Object.hashAll(gradientColors),
    gradientBegin,
    gradientEnd,
    glassOpacity,
    blurSigma,
  );

  /// Persist ke `SharedPreferences` dalam bentuk JSON string.
  String toJson() => jsonEncode({
    'primary': _hex(primary),
    'secondary': _hex(secondary),
    'tertiary': _hex(tertiary),
    'gradientColors': gradientColors.map(_hex).toList(),
    'gradientBeginX': gradientBegin.x,
    'gradientBeginY': gradientBegin.y,
    'gradientEndX': gradientEnd.x,
    'gradientEndY': gradientEnd.y,
    'glassOpacity': glassOpacity,
    'blurSigma': blurSigma,
  });

  /// Baca dari JSON string yang ditulis [toJson]. `null` bila tidak valid.
  static UiStyle? fromJson(String raw) {
    final Object? decoded;
    try {
      decoded = jsonDecode(raw);
    } on FormatException {
      return null;
    }
    if (decoded is! Map<String, dynamic>) return null;
    final map = decoded;
    final colors = _parseColors(map['gradientColors']);
    if (colors == null) return null;
    return UiStyle(
      primary: _parseColor(map['primary']) ?? kUiPrimary,
      secondary: _parseColor(map['secondary']) ?? kUiSecondary,
      tertiary: _parseColor(map['tertiary']) ?? kUiTertiary,
      gradientColors: colors,
      gradientBegin: Alignment(
        (map['gradientBeginX'] as num?)?.toDouble() ?? -1,
        (map['gradientBeginY'] as num?)?.toDouble() ?? -1,
      ),
      gradientEnd: Alignment(
        (map['gradientEndX'] as num?)?.toDouble() ?? 1,
        (map['gradientEndY'] as num?)?.toDouble() ?? 1,
      ),
      glassOpacity: (map['glassOpacity'] as num?)?.toDouble() ?? kUiGlassOpacity,
      blurSigma: (map['blurSigma'] as num?)?.toDouble() ?? kUiBlurSigma,
    );
  }

  static bool _listEquals(List<Color> a, List<Color> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  static String _hex(Color c) =>
      '#${(c.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';

  static Color? _parseColor(Object? value) {
    if (value is! String) return null;
    final hex = value.replaceFirst('#', '');
    if (hex.length != 6) return null;
    final parsed = int.tryParse(hex, radix: 16);
    if (parsed == null) return null;
    return Color(0xFF000000 | parsed);
  }

  static List<Color>? _parseColors(Object? value) {
    if (value is! List) return null;
    final colors = <Color>[];
    for (final item in value) {
      final color = _parseColor(item);
      if (color == null) return null;
      colors.add(color);
    }
    return colors.isEmpty ? null : colors;
  }
}

/// Default primary — gold brand DompetQu.
const Color kUiPrimary = Color(0xFFD4A574);
/// Default secondary — purple accent.
const Color kUiSecondary = Color(0xFF8B5CF6);
/// Default tertiary — pink accent.
const Color kUiTertiary = Color(0xFFF4A6D6);
/// Default urutan warna gradient: gold → purple → pink.
const List<Color> kUiGradientColors = [
  Color(0xFFFFD79B),
  kUiPrimary,
  kUiSecondary,
  kUiTertiary,
];
/// Default opacity isi frosted glass.
const double kUiGlassOpacity = 0.08;
/// Default sigma blur BackdropFilter (`backdrop-blur-[6.1px]` di web).
const double kUiBlurSigma = 6.1;