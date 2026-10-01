import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

/// Brand identity DompetQu — updated to gold-black primary with purple & pink accents
/// (frosted glass + gold bevel accents, preserving purple/pink highlights).
class DompetBrand {
  DompetBrand._();

  // Palette utama.
  // Dominan: gold & black. Aksen: sedikit purple -> pink.
  static const primary = Color(0xFFD4A574); // semantic primary (gold)
  static const onPrimary = Color(0xFF0A0A0A); // text/icons on primary (black)
  static const purple = Color(0xFF8B5CF6); // accent purple (subtle)
  static const pink = Color(0xFFF4A6D6); // accent pink (softer)

  // Gold-black accent palette (for premium highlights)
  static const goldLight = Color(0xFFFFD79B);
  static const gold = primary;
  static const goldDark = Color(0xFFA37A3E);
  static const blackBg = Color(0xFF0A0A0A);
  static const goldGlow = Color(0x33D4A574);
  static const innerShadow = Color(0x99000000);
  static const LinearGradient goldBevel = LinearGradient(
    colors: [goldLight, gold],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Latar & glass (gold-black primary with frosted glass preserved).
  static const background = Color(0xFF0A0A0A);
  static const surface = Color(0xFF121212);
  static const glassFill = Color(0x14FFFFFF); // slightly stronger frosted fill
  static const glassBorder = Color(0x26FFFFFF);

  static const radius = 16.0;
  static const radiusSm = 12.0;

  /// Gradient utama brand: purple -> green -> pink.
  static LinearGradientMix gradient = LinearGradientMix(
    colors: [goldLight, gold, purple, pink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Gradient utama brand: purple -> green -> pink.
  static LinearGradientMix gradientWithAlpha([double alpha = 1.0]) =>
      LinearGradientMix(
        colors: [
          gold.withValues(alpha: alpha),
          Colors.purple.shade900.withValues(alpha: alpha),
          Colors.black.withValues(alpha: alpha),
          pink.withValues(alpha: alpha),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
  static LinearGradientMix gradientDarkWithAlpha([double alpha = 0.1]) =>
      LinearGradientMix(
        colors: [
          DompetBrand.goldDark.withValues(alpha: alpha),
          Colors.black,
        ],
        begin: .topCenter,
        end: .bottomCenter,
        stops: [0.0, 0.1],
      );

  /// [BoxDecorationMix] gradient untuk dipakai di style Mix/Remix.
  static BoxDecorationMix gradientDecoration() => BoxDecorationMix(
    gradient: LinearGradientMix(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [goldLight, gold, purple, pink],
    ),
  );

  // Palette khusus CS glass — update ke gold tint sehingga frosted glass tetap terlihat tapi aksen gold.
  static const csBorder = Color(0x66D4A574); // gold 40%
  static const csBorderHover = Color(0xA6D4A574); // gold 65%
  static const csFill = Color(0x14D4A574); // gold 8%
  static const csFillHover = Color(0x24D4A574); // gold 14%
  static const csFocusBorder = Color(
    0xA68B5CF6,
  ); // gunakan purple untuk focus (subtle)
  static const csFocusRing = Color(0x59A855F6); // purple ring translucent
  static const csShadow = Color(0x1A000000); // rgba(0,0,0,0.1)

  // Dark mode variants.
  static const csBorderDark = Color(0x33D4A574); // gold 20%
  static const csFillDark = Color(0x730A0A0F); // rgba(10,10,15,0.45)
  static const csShadowDark = Color(0x8C000000); // rgba(0,0,0,0.55)

  /// Kartu / panel glassmorphism khas web (`bg-white/4` + border tipis).
  static BoxDecorationMix glassDecoration({double radius = radius}) =>
      BoxDecorationMix(
        color: glassFill,
        borderRadius: BorderRadiusGeometryMix.circular(radius),
        border: BorderMix.all(BorderSideMix(color: glassBorder, width: 1)),
        boxShadow: [
          BoxShadowMix(
            blurRadius: 0,
            color: Colors.black.withValues(alpha: 0.30),
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      );

  /// Base CS glass (mirip `@utility csglass`).
  static BoxDecorationMix csGlass({double radius = radius}) => BoxDecorationMix(
    color: csFill,
    borderRadius: BorderRadiusGeometryMix.circular(radius),
    border: BorderMix.all(BorderSideMix(color: csBorder, width: 1)),
    boxShadow: [
      BoxShadowMix(
        blurRadius: 30,
        color: csShadow,
        offset: const Offset(0, 4),
        spreadRadius: 0,
      ),
    ],
  );

  /// Card variant (mirip `@utility csglass-card`).
  static BoxDecorationMix csGlassCard({double radius = radius}) =>
      BoxDecorationMix(
        color: csFill,
        borderRadius: BorderRadiusGeometryMix.circular(radius),
        border: BorderMix.all(BorderSideMix(color: csBorder, width: 1)),
        boxShadow: [
          BoxShadowMix(
            blurRadius: 30,
            color: csShadow,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      );

  /// Surface variant (mirip `@utility csglass-surface`).
  static BoxDecorationMix csGlassSurface({double radius = radius}) =>
      BoxDecorationMix(
        color: csFill,
        borderRadius: BorderRadiusGeometryMix.circular(radius),
        border: BorderMix.all(BorderSideMix(color: csBorder, width: 1)),
        boxShadow: [
          BoxShadowMix(
            blurRadius: 30,
            color: csShadow,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      );

  /// Input variant (mirip `@utility csglass-input`).
  static BoxDecorationMix csGlassInput({double radius = radiusSm}) =>
      BoxDecorationMix(
        color: csFill,
        borderRadius: BorderRadiusGeometryMix.circular(radius),
        border: BorderMix.all(BorderSideMix(color: csBorder, width: 1)),
        boxShadow: [
          BoxShadowMix(
            blurRadius: 30,
            color: csShadow,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      );

  /// Strong input (mirip `@utility csinput`).
  static BoxDecorationMix csInput({double radius = radius}) => BoxDecorationMix(
    color: csFill,
    borderRadius: BorderRadiusGeometryMix.circular(radius),
    border: BorderMix.all(BorderSideMix(color: csBorder, width: 1)),
    boxShadow: [
      BoxShadowMix(
        blurRadius: 30,
        color: csShadow,
        offset: const Offset(0, 4),
        spreadRadius: 0,
      ),
    ],
  );

  /// Panel solid (pengganti kartu putih di web).
  static BoxDecorationMix solidDecoration({double radius = radius}) =>
      BoxDecorationMix(
        color: surface,
        borderRadius: BorderRadiusGeometryMix.circular(radius),
        border: BorderMix.all(BorderSideMix(color: glassBorder, width: 1)),
      );
}
