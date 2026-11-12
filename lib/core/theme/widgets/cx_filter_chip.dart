import 'package:material_ui/material_ui.dart';

import 'package:dompetqu/core/theme/dompet_brand.dart';

/// Chip filter pill global yang bisa dipilih.
///
/// Dipakai lintas fitur: filter tipe transaksi, status utang, level log, dsb.
/// Dulu bernama `OrderFilterChip` (terkunci di fitur order); sekarang menjadi
/// komponen tema agar konsisten.
class CxFilterChip extends StatelessWidget {
  const CxFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  /// Ikon opsional di kiri label.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final color = selected ? DompetBrand.gold : Colors.white38;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? DompetBrand.gold.withValues(alpha: 0.16)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected
                ? DompetBrand.gold.withValues(alpha: 0.6)
                : Colors.white12,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ikon section — opsional, ukuran kecil agar chip tetap ringkas.
            if (icon != null) ...[
              Icon(icon, size: 13, color: color),
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
