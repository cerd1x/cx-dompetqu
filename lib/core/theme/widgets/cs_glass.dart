import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

import '../cs_mix.dart';
import '../dompet_brand.dart';

/// Widget wrapper glassmorphism dengan backdrop blur.
/// Mirip efek `backdrop-blur-[6.1px]` di CSS.
class CsGlass extends StatelessWidget {
  const CsGlass({
    super.key,
    required this.child,
    this.radius = DompetBrand.radius,
    this.decoration,
    this.blur = 6.1,
    this.padding,
  });

  final Widget child;
  final double radius;
  final BoxDecorationMix? decoration;
  final double blur;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final content = padding != null
        ? Padding(padding: padding!, child: child)
        : child;

    return CsFrost(
      radius: radius,
      blur: blur,
      child: RemixCard(
        style: CardStyler()
            .borderRadius(BorderRadiusGeometryMix.circular(radius))
            .decoration(decoration ?? DompetBrand.csGlass(radius: radius)),
        child: content,
      ),
    );
  }
}
