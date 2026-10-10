import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

import '../cs_mix.dart';
import '../dompet_brand.dart';

enum DompetCardVariant { solid, glass, csGlassCard, csGlassSurface }

/// Kartu glassmorphism — padanan `card-sf` / `bg-white/4` di web.
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
    final card = RemixCard(style: _style, child: child);

    Widget result = switch (variant) {
      DompetCardVariant.solid => card,
      DompetCardVariant.glass => CsFrost(
        radius: radius,
        shadow: const [
          BoxShadow(
            color: Color(0x4D000000),
            blurRadius: 0,
            offset: Offset(0, 8),
          ),
        ],
        child: card,
      ),
      DompetCardVariant.csGlassCard ||
      DompetCardVariant.csGlassSurface => CsFrost(
        radius: radius,
        shadow: const [
          BoxShadow(
            color: DompetBrand.csShadow,
            blurRadius: 30,
            offset: Offset(0, 4),
          ),
        ],
        child: card,
      ),
    };

    if (onTap == null) return result;
    return GestureDetector(onTap: onTap, child: result);
  }
}
