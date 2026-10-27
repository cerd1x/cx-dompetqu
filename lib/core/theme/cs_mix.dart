import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

import 'dompet_brand.dart';

/// Efek frosted glass — padanan `backdrop-blur-[6.1px]` di web.
///
/// Radius clip harus sama dengan radius container agar blur mengikuti sudut
/// membulat. Opsional [shadow] dilukis DI LUAR area blur (tidak ikut
/// ter-clip), jadi drop shadow panel/kartu tetap terlihat.
///
/// **[blur] default 0 = tanpa `BackdropFilter`.** Alasannya biaya: backdrop
/// blur dieksekusi ulang setiap frame, dan pada target 120 fps anggaran satu
/// frame hanya 8,33 ms. Di dalam konten yang scroll, efek blur nyaris tidak
/// terlihat (latar kartu adalah gradient halus) tapi biayanya penuh. Jadi
/// blur sekarang opt-in: hanya untuk overlay kecil yang jarang bergerak
/// (dialog, bottom sheet, nav bar) yang memang butuh mengaburkan konten di
/// belakangnya. Isi `blur: 12` secara eksplisit untuk memakainya.
class CsFrost extends StatelessWidget {
  const CsFrost({
    super.key,
    required this.child,
    this.radius = DompetBrand.radius,
    this.blur = 0,
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
    // `Opacity(1.0)` tetap membuat render object tambahan; baru dipakai bila
    // memang ada transparansi.
    Widget content = opacity < 1
        ? Opacity(opacity: opacity, child: child)
        : child;

    if (blur > 0) {
      content = BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: content,
      );
    }

    final frosted = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: content,
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
