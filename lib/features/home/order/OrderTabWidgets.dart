// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../../core/theme/dompet_brand.dart';
import '../../../core/theme/widgets/dompet_badge.dart';
import '../../../core/utils/balance.dart';
import '../models/transaction.dart';

/// Warna/label/ikon transaksi per tipe — dipakai bersama tab Bookkeeping & Debt.
typedef TxTone = ({Color color, String sign, String label, IconData icon});

/// Nada tampilan untuk tipe transaksi (`income`/`expense`/lainnya).
TxTone txTone(String type) => switch (type) {
  'income' => (
    color: const Color(0xFF34D399),
    sign: '+',
    label: 'Income',
    icon: Icons.arrow_upward_rounded,
  ),
  'expense' => (
    color: const Color(0xFFF87171),
    sign: '-',
    label: 'Expense',
    icon: Icons.arrow_downward_rounded,
  ),
  'transfer' => (
    color: const Color(0xFFFBBF24),
    sign: '',
    label: 'Transfer',
    icon: Icons.swap_horiz_rounded,
  ),
  _ => (
    color: const Color(0xFFFBBF24),
    sign: '',
    label: 'Capital',
    icon: Icons.savings_outlined,
  ),
};

/// Nominal transaksi sebagai angka — parsing aman untuk string "ISO VALUE".
num txAmount(Transaction tx) {
  try {
    return Balance.parse(tx.amount).value;
  } on FormatException {
    return 0;
  }
}

/// Kotak ringkasan angka (Income/Expense/Profit/Outstanding) — padanan kartu
/// statistik di dashboard, dipakai tab Bookkeeping & Debt.
class OrderStatTile extends StatelessWidget {
  const OrderStatTile({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    this.icon,
  });

  final String label;
  final String value;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Box(
      style: BoxStyler()
          .padding(
            EdgeInsetsGeometryMix.value(
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          )
          .decoration(
            DecorationMix.value(
              BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: color.withValues(alpha: 0.28)),
              ),
            ),
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 13, color: color.withValues(alpha: 0.9)),
                const SizedBox(width: 5),
              ],
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white54,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Chip filter pill yang bisa dipilih (tipe transaksi / status utang).
class OrderFilterChip extends StatelessWidget {
  const OrderFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? DompetBrand.gold : Colors.white38,
          ),
        ),
      ),
    );
  }
}

/// Judul grup daftar + aksi di kanan (tanggal/contact/pelanggan).
class OrderGroupHeader extends StatelessWidget {
  const OrderGroupHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10.5,
                        color: Colors.white38,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 8), trailing!],
        ],
      ),
    );
  }
}

/// Badge status Debt Payment — menandai pembayaran yang sudah masuk ledger.
class DebtPaymentBadge extends StatelessWidget {
  const DebtPaymentBadge({super.key, required this.amount});

  final String amount;

  @override
  Widget build(BuildContext context) {
    return DompetBadge(
      label: amount,
      icon: Icons.check_circle_outline_rounded,
      tone: DompetBadgeTone.success,
    );
  }
}
