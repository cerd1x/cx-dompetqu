import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

import 'dompet_brand.dart';

/// Efek frosted glass — padanan `backdrop-blur-[6.1px]` di web.
///
/// Memblurkan konten di belakang container transparan. Radius clip harus
/// sama dengan radius container agar blur mengikuti sudut membulat.
/// Opsional [shadow] dilukis DI LUAR area blur (tidak ikut ter-clip),
/// jadi drop shadow panel/kartu tetap terlihat.
class CsFrost extends StatelessWidget {
  const CsFrost({
    super.key,
    required this.child,
    this.radius = DompetBrand.radius,
    this.blur = 6.1,
    this.shadow,
    this.opacity = 1.0,
  });

  final Widget child;
  final double radius;
  final double blur;
  final List<BoxShadow>? shadow;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    final frosted = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Opacity(opacity: opacity, child: child),
      ),
    );
    if (shadow == null || shadow!.isEmpty) return frosted;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: shadow,
      ),
      child: frosted,
    );
  }
}

extension CsCardStyleExtension on CardStyler {
  CardStyler glassCard({double radius = DompetBrand.radius}) =>
      decoration(DompetBrand.csGlassCard(radius: radius));

  CardStyler glassSurface({double radius = DompetBrand.radius}) =>
      decoration(DompetBrand.csGlassSurface(radius: radius));
}

extension CsButtonStyleExtension on ButtonStyler {
  ButtonStyler glassSurface({double radius = DompetBrand.radius}) {
    final deco = DompetBrand.csGlassSurface(radius: radius);
    return decoration(deco).labelColor(Colors.white);
  }
}

extension CsTextFieldStyleExtension on TextFieldStyler {
  TextFieldStyler glassInput({double radius = DompetBrand.radiusSm}) {
    final deco = DompetBrand.csGlassInput(radius: radius);
    return decoration(deco).color(Colors.white).hintColor(Colors.white38);
  }

  TextFieldStyler csInput({double radius = DompetBrand.radius}) {
    final deco = DompetBrand.csInput(radius: radius);
    return decoration(deco).color(Colors.white).hintColor(Colors.white38);
  }
}
