import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

import '../dompet_brand.dart';

/// Tombol aksi bulat — padanan tombol import/add di web.
class RoundActionButton extends StatelessWidget {
  const RoundActionButton({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.size = 43,
    this.gradient,
    this.alpha = 1,
    this.shadowAlpha = 0.1,
    this.tooltip = false,
    this.borderColor,
    this.borderWidth = 1.0,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final double size;
  final LinearGradientMix? gradient;
  final double alpha;
  final double shadowAlpha;
  final bool tooltip;
  final Color? borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final button = Box(
      style: BoxStyler()
          .size(size, size)
          .gradient(
            LinearGradientMix(
              colors: [
                DompetBrand.goldDark.withValues(alpha: alpha),
                DompetBrand.gold.withValues(alpha: alpha),
                DompetBrand.purple.withValues(alpha: alpha),
                Colors.black.withValues(alpha: alpha),
                DompetBrand.pink.withValues(alpha: alpha),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.0, 0.1, 0.4, 0.7, 1],
            ),
          )
          .shape(.circle(side: .create(color: .value(DompetBrand.csBorder))))
          .boxShadows([
            BoxShadowMix(
              color: Color(0x59000000),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
            BoxShadowMix(
              color: const Color(0xFFFFA55C).withValues(alpha: shadowAlpha),
              blurRadius: 22,
              offset: Offset(0, 10),
            ),
          ]),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        borderOnForeground: true,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            alignment: Alignment.center,
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: borderColor ?? DompetBrand.csBorderDark,
                width: borderWidth,
              ),
            ),
            child: Icon(icon, color: DompetBrand.goldLight, size: size * 0.5),
          ),
        ),
      ),
    );

    // Tooltip (OverlayPortal) tidak aman di dalam subtree ber-transform/
    // animation entrance (render error "RenderFollowerLayer"). Hanya dibangun
    // saat diaktifkan; default memakai Semantics supaya label tetap terbaca.
    if (tooltip) {
      return Tooltip(message: label, child: button);
    }
    return Semantics(button: true, label: label, child: button);
  }
}
