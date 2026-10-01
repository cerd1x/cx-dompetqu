import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
import '../dompet_brand.dart';

/// Avatar brand dengan latar gradient — padanan avatar inisial di web.
class DompetAvatar extends StatelessWidget {
  const DompetAvatar({
    super.key,
    required this.label,
    this.size = 40,
    this.onTap,
  });

  final String label;
  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final avatar = RemixAvatar(
      label: label,
      style: AvatarStyler()
          .size(size, size)
          .borderRadius(BorderRadiusGeometryMix.circular(size / 2))
          .decoration(DompetBrand.gradientDecoration())
          .labelColor(Colors.white)
          .labelFontWeight(FontWeight.w700)
          .labelFontSize(size * 0.38),
    );

    if (onTap == null) return avatar;
    return Material(
      color: Colors.transparent,
      shape: CircleBorder(side: BorderSide.none),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: avatar,
      ),
    );
  }
}
