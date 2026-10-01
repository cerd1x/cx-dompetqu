import 'package:flutter/material.dart';

import '../../../core/theme/dompet_brand.dart';
import '../../../core/theme/widgets/dompet_card.dart';

/// Baris skeleton — padanan kelas `skeleton` daisyUI di web.
class SkeletonRow extends StatelessWidget {
  const SkeletonRow({super.key, this.height = 64});

  final double height;

  @override
  Widget build(BuildContext context) {
    return DompetCard(
      variant: DompetCardVariant.csGlassSurface,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          // avatar block section
          _block(size: const Size(36, 36), radius: 999),
          const SizedBox(width: 12),
          // text lines section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _block(size: const Size(120, 12)),
                const SizedBox(height: 8),
                _block(size: const Size(80, 10)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // trailing block section
          _block(size: const Size(72, 12)),
        ],
      ),
    );
  }

  Widget _block({required Size size, double radius = 6}) {
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class SkeletonList extends StatelessWidget {
  const SkeletonList({super.key, this.count = 5, this.padding});

  final int count;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        children: [
          for (var i = 0; i < count; i++) ...[
            const SkeletonRow(),
            if (i != count - 1) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

/// State kosong — padanan "Is Empty" di web.
class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.label, this.icon});

  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // icon section
            Icon(icon ?? Icons.inbox_outlined, size: 44, color: Colors.white24),
            const SizedBox(height: 12),
            // message section
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white38, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}

/// State error + tombol retry (load ulang di background).
class ErrorState extends StatelessWidget {
  const ErrorState({super.key, required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // icon section
            const Icon(
              Icons.cloud_off_outlined,
              size: 40,
              color: DompetBrand.pink,
            ),
            const SizedBox(height: 10),
            // message section
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white60, fontSize: 13),
            ),
            // retry button section
            if (onRetry != null) ...[
              const SizedBox(height: 14),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Coba lagi'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
