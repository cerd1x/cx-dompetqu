import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

import '../../../core/theme/dompet_brand.dart';
import '../../../core/theme/widgets/dompet_card.dart';

/// Widget dasar untuk tab yang belum diimplementasikan.
class PlaceholderTab extends StatelessWidget {
  const PlaceholderTab({super.key, required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DompetCard(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // icon section
            Box(
              style: BoxStyler()
                  .size(64, 64)
                  .alignment(.center)
                  .gradient(DompetBrand.gradient)
                  .borderRadius(.circular(20)),
              child: Icon(icon, size: 30, color: Colors.white),
            ),
            const SizedBox(height: 16),
            // label section
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            // hint section
            Text(
              'Segera hadir',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.white60),
            ),
          ],
        ),
      ),
    );
  }
}

/// Scaffold standar untuk tab portofolio `/dompet`.
class TabScaffold extends StatelessWidget {
  const TabScaffold({super.key, required this.header, required this.body});

  final Widget header;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          header,
          Expanded(child: body),
        ],
      ),
    );
  }
}
