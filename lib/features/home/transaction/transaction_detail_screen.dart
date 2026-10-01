import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/widgets/dompet_card.dart';
import '../../../core/utils/balance.dart';
import '../models/transaction.dart';

class TransactionDetailScreen extends StatelessWidget {
  const TransactionDetailScreen({super.key, required this.transaction});

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    final tone = _tone;
    final balance = Balance.parse(transaction.amount);
    final amountText = '${tone.sign}${balance.toLocalStr()}';

    return Scaffold(
      appBar: AppBar(title: Text(transaction.displayName)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DompetCard(
              variant: DompetCardVariant.csGlassSurface,
              radius: 16,
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  Icon(
                    _typeIcon,
                    size: 48,
                    color: tone.color,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    amountText,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    transaction.type.toUpperCase(),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _DetailRow(label: 'ID', value: transaction.id),
            _DetailRow(
              label: 'Tanggal',
              value: DateFormat('d MMM yyyy, HH:mm').format(transaction.createdAt),
            ),
            if (transaction.description != null)
              _DetailRow(label: 'Deskripsi', value: transaction.description!),
            if (transaction.category != null)
              _DetailRow(label: 'Kategori', value: transaction.category!),
            if (transaction.capital != null)
              _DetailRow(label: 'Modal', value: transaction.capital!),
            _DetailRow(
              label: 'Status',
              value: transaction.status,
            ),
            if (transaction.paymentMethod != null)
              _DetailRow(
                label: 'Metode',
                value: transaction.paymentMethod!.type,
              ),
          ],
        ),
      ),
    );
  }

  _TransactionTone get _tone {
    switch (transaction.type) {
      case 'income':
        return (color: const Color(0xFF34D399), sign: '+', icon: Icons.arrow_upward_rounded);
      case 'expense':
        return (color: const Color(0xFFF87171), sign: '-', icon: Icons.arrow_downward_rounded);
      default:
        return (color: const Color(0xFFFBBF24), sign: '', icon: Icons.swap_horiz_rounded);
    }
  }

  IconData get _typeIcon {
    switch (transaction.type) {
      case 'income':
        return Icons.arrow_upward_rounded;
      case 'expense':
        return Icons.arrow_downward_rounded;
      default:
        return Icons.swap_horiz_rounded;
    }
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 13,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

typedef _TransactionTone = ({Color color, String sign, IconData icon});