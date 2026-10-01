import 'package:flutter/material.dart';

import '../dompet_brand.dart';

/// Latar halaman: gradient ungu lembut di atas dasar gelap (mirip web).
/// Memenuhi seluruh layar — elemen lain (mis. nav bar) ditumpuk di atasnya.
class DompetGradientBackground extends StatelessWidget {
  const DompetGradientBackground({
    super.key,
    required this.child,
    this.radial = true,
  });

  final Widget child;
  final bool radial;

  @override
  Widget build(BuildContext context) {
    const kRoundedBottom = BorderRadius.vertical(bottom: Radius.circular(20));
    return Container(
      decoration: BoxDecoration(
        color: DompetBrand.background,
        borderRadius: kRoundedBottom,
        border: const Border(
          bottom: BorderSide(color: DompetBrand.csBorder, width: 1),
        ),
        gradient: RadialGradient(
          center: Alignment.topRight,
          radius: radial ? 1.1 : 0.9,
          colors: [
            DompetBrand.pink.withValues(alpha: .4),
            DompetBrand.goldDark.withValues(alpha: 0.4),
            DompetBrand.purple.withAlpha(10),
            Colors.black,
          ],
          stops: const [0.0, 0.1, 0.29, .3],
        ),
      ),
      child: child,
    );
  }
}
