import 'package:dompetqu/core/theme/dompet_brand.dart';
import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

import '../../../core/theme/cs_mix.dart';

/// Bottom bar sticky di halaman tab (Contacts/Inventory/Assets).
class TabBottomBar extends StatelessWidget {
  const TabBottomBar({
    super.key,
    required this.child,
    this.paddingX = 16,
    this.paddingY = 6,
    this.blur = 12,
    this.opacity = .7,
  });

  final Widget child;
  final double paddingX;
  final double paddingY;
  final double blur;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return CsFrost(
      radius: 0,
      blur: blur,
      opacity: opacity,
      child: Box(
        style: BoxStyler.clipBehavior(.antiAlias)
            .decoration(
              .borderRadius(.bottom(.circular(24))).border(
                .bottom(BorderSideMix(color: Color(0x4DFBBF24), width: 2)),
              ),
            )
            .gradient(DompetBrand.gradientDarkWithAlpha(.3)),
        child: Stack(
          children: [
            // top border section
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(height: 1, color: Colors.white10),
            ),
            // content section
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: paddingX,
                vertical: paddingY,
              ),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
