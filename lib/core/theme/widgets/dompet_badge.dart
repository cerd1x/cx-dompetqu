import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:remix/remix.dart';

import 'package:dompetqu/core/theme/dompet_brand.dart';

enum DompetBadgeTone { accent, success, danger }

/// Chip/klaim kecil — padanan kelas `btn-chips` daisyUI di web.
class DompetBadge extends StatelessWidget {
  const DompetBadge({
    super.key,
    required this.label,
    this.tone = DompetBadgeTone.accent,
    this.icon,
  });

  final String label;
  final DompetBadgeTone tone;
  final dynamic icon;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (tone) {
      DompetBadgeTone.accent => (DompetBrand.primary, DompetBrand.onPrimary),
      DompetBadgeTone.success => (const Color(0xFF059669), Colors.white),
      DompetBadgeTone.danger => (const Color(0xFFDB2777), Colors.white),
    };

    final style = BadgeStyler()
        .color(bg)
        .labelColor(fg)
        .borderRadius(BorderRadiusGeometryMix.circular(999))
        .padding(EdgeInsetsGeometryMix.symmetric(horizontal: 10, vertical: 5))
        .labelFontWeight(FontWeight.w600)
        .labelFontSize(12);

    // ponytail: dynamic icon handles IconData and HugeIcons List<List<dynamic>>
    final Widget? iconChild = switch (icon) {
      final IconData data => Icon(data, size: 14, color: fg),
      final List<List<dynamic>> data => HugeIcon(
        icon: data,
        size: 14,
        color: fg,
      ),
      final Widget w => w,
      _ => null,
    };

    return RemixBadge(
      label: label,
      style: style,
      child: iconChild == null
          ? null
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                iconChild,
                const SizedBox(width: 5),
                Text(
                  label,
                  style: TextStyle(
                    color: fg,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
    );
  }
}
