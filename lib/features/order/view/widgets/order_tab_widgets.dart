import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import 'package:dompetqu/core/theme/widgets/cx_badge.dart';
import 'package:dompetqu/features/transactions/domain/models/transaction.dart';
import 'package:dompetqu/core/theme/widgets/cx_icons.dart';

/// Warna/label/ikon transaksi per tipe — dipakai bersama tab Bookkeeping & Debt.
typedef TxTone = ({Color color, String sign, String label, IconData icon});

/// Nada tampilan untuk tipe transaksi (`income`/`expense`/lainnya).
TxTone txTone(String type) => switch (type) {
  'income' => (
    color: const Color(0xFF34D399),
    sign: '+',
    label: 'Income',
    icon: CxIcons.arrowUpwardRounded,
  ),
  'expense' => (
    color: const Color(0xFFF87171),
    sign: '-',
    label: 'Expense',
    icon: CxIcons.arrowDownwardRounded,
  ),
  'transfer' => (
    color: const Color(0xFFFBBF24),
    sign: '',
    label: 'Transfer',
    icon: CxIcons.swapHorizRounded,
  ),
  _ => (
    color: const Color(0xFFFBBF24),
    sign: '',
    label: 'Capital',
    icon: CxIcons.savingsOutlined,
  ),
};

/// Nominal transaksi sebagai angka — parsing aman untuk string "ISO VALUE".
///
/// Delegasi ke [Transaction.amountValue]; dipertahankan sebagai fungsi top-level
/// karena dipakai widget Order sebelum logikanya pindah ke domain.
num txAmount(Transaction tx) => tx.amountValue;

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
    return CxBadge(
      label: amount,
      icon: CxIcons.checkCircleOutlineRounded,
      tone: CxBadgeTone.success,
    );
  }
}
