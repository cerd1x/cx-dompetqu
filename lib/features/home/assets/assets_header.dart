import 'package:flutter/material.dart';

/// Header kecil untuk halaman Assets.
class AssetsHeader extends StatelessWidget {
  const AssetsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Text(
        'Assets',
        style: Theme.of(
          context,
        ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}
