import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

import 'package:dompetqu/core/theme/dompet_brand.dart';

enum DompetCardVariant { solid, glass, csGlassCard, csGlassSurface }

/// Kartu glassmorphism — padanan `card-sf` / `bg-white/4` di web.
///
/// Varian `glass`/`csGlassCard`/`csGlassSurface` mengandalkan fill translusen
/// + border tipis, **bukan** `BackdropFilter`. Blur backdrop sengaja tidak
/// dipakai di sini: kartu berada di dalam konten yang scroll, jadi blur akan
/// dieksekusi ulang tiap frame tanpa terlihat bedanya di atas latar gradient.
/// Butuh blur sungguhan? Bungkus sendiri dengan `CsFrost(blur: 12)`.
class DompetCard extends StatelessWidget {
  const DompetCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.radius = DompetBrand.radius,
    this.variant = DompetCardVariant.glass,
    this.onTap,
    this.compact = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final DompetCardVariant variant;
  final VoidCallback? onTap;

  /// When true, uses a tighter internal padding to render a compact card.
  final bool compact;

  CardStyler get _style {
    final effectivePadding = compact
        ? const EdgeInsets.symmetric(horizontal: 10, vertical: 8)
        : padding;
    final decoration = switch (variant) {
      DompetCardVariant.solid => DompetBrand.solidDecoration(radius: radius),
      DompetCardVariant.glass => DompetBrand.glassDecoration(radius: radius),
      DompetCardVariant.csGlassCard => DompetBrand.csGlassCard(radius: radius),
      DompetCardVariant.csGlassSurface => DompetBrand.csGlassSurface(
        radius: radius,
      ),
    };

    return CardStyler()
        .padding(EdgeInsetsGeometryMix.value(effectivePadding))
        .borderRadius(BorderRadiusGeometryMix.circular(radius))
        .decoration(decoration);
  }

  @override
  Widget build(BuildContext context) {
    // Setiap varian sudah membawa fill + border + shadow di decoration-nya
    // sendiri. Wrapper `CsFrost` dulu menambahkan shadow kedua yang identik
    // dan — karena memakai `ClipRRect` — memotong shadow milik decoration
    // (shadow digambar di luar bounds). Jadi kartu dikembalikan apa adanya.
    final Widget result = RemixCard(style: _style, child: child);

    if (onTap == null) return result;
    return GestureDetector(onTap: onTap, child: result);
  }
}
