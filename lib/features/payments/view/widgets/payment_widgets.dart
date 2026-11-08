import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mix/mix.dart';

import 'package:dompetqu/core/theme/widgets/cx_card.dart';
import 'package:dompetqu/core/utils/formatters.dart';
import 'package:dompetqu/features/payments/domain/models/payment.dart';

/// Pill status payment — `failed` merah, `completed` hijau, `pending`/
/// `processing` kuning, `refunded`/`cancelled` netral.
///
/// Dipakai bersama oleh baris ledger transaksi (status pembayaran transaksi)
/// dan [FailedPaymentRow] agar warna status konsisten.
class PaymentStatusPill extends StatelessWidget {
  const PaymentStatusPill({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status.toLowerCase()) {
      'paid' || 'completed' => const Color(0xFF34D399),
      'failed' => const Color(0xFFF87171),
      'pending' || 'processing' || 'unpaid' => const Color(0xFFFBBF24),
      _ => Colors.white54,
    };
    return Box(
      style: BoxStyler()
          .padding(
            EdgeInsetsGeometryMix.value(
              const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            ),
          )
          .decoration(
            DecorationMix.value(
              BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: color.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
            ),
          ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: color,
        ),
      ),
    );
  }
}

/// Baris satu payment gagal: judul, metode, sisa retry, waktu, dan nominal.
///
/// [onTap] membuka layar detail (`DetailPaymentFailedView`) tempat retry dan
/// report dilakukan; row sendiri tetap tidak mengubah data. Nominal memakai
/// `payment.currency` dari backend karena payment bisa beda mata uang dengan
/// preferensi tampilan aplikasi.
class FailedPaymentRow extends StatelessWidget {
  const FailedPaymentRow({super.key, required this.payment, this.onTap});

  final Payment payment;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final code = payment.currency;
    final amount = formatMoney(payment.amount, code);
    final retry = 'retry ${payment.retryCount}/${payment.maxRetries}';
    final reference = payment.gatewayRef;

    return CxCard(
      variant: CxCardVariant.csGlassSurface,
      radius: 16,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      onTap: onTap,
      child: Row(
        children: [
          // icon section
          Box(
            style: BoxStyler()
                .constraints(
                  BoxConstraintsMix.value(
                    (const BoxConstraints()).tighten(width: 36, height: 36),
                  ),
                )
                .decoration(
                  DecorationMix.value(
                    BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFF87171).withValues(alpha: 0.16),
                      border: Border.all(
                        color: const Color(0xFFF87171).withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                ),
            child: const Icon(
              Icons.error_outline_rounded,
              size: 18,
              color: Color(0xFFF87171),
            ),
          ),
          const SizedBox(width: 12),
          // detail section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payment.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    PaymentStatusPill(status: payment.status),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        [
                          payment.method,
                          retry,
                          DateFormat('HH:mm').format(payment.createdAt),
                        ].join(' · '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.white38,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // nominal section
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFF87171),
                ),
              ),
              if (reference != null) ...[
                const SizedBox(height: 3),
                Text(
                  reference,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 10.5, color: Colors.white38),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
