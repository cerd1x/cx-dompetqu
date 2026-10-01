import 'package:flutter/material.dart';

import '../../../core/theme/widgets/dompet_card.dart';
import '../../../core/utils/formatters.dart';
import '../application/statistics_controller.dart';

/// Grid statistik dashboard — padanan `_dashboard` stats cards di web.
class StatsGrid extends StatelessWidget {
  const StatsGrid({super.key, required this.stats});

  final StatisticsState stats;

  static const _cells = [
    (label: 'Income', key: 'income', color: Color(0xFF34D399)),
    (label: 'Expense', key: 'expense', color: Color(0xFFF87171)),
    (label: 'Loan', key: 'loan', color: Color(0xFF60A5FA)),
    (label: 'Profit', key: 'profit', color: Color(0xFF34D399)),
    (label: 'Cash', key: 'cash', color: Color(0xFFFBBF24)),
    (label: 'Aset', key: 'asset', color: Color(0xFFA78BFA)),
  ];

  String _value(String key) {
    if (stats.loading) return '...';
    if (stats.error != null) return '--';
    final s = stats.statistics;
    return switch (key) {
      'income' => formatMoney(s.totalIncome, 'IDR'),
      'expense' => formatMoney(s.totalExpense, 'IDR'),
      'loan' => formatMoney(s.totalLoan, 'IDR'),
      'profit' => formatMoney(s.totalProfit, 'IDR'),
      'cash' => formatMoney(s.totalCash, 'IDR'),
      _ => formatMoney(s.totalAsset, 'IDR'),
    };
  }

  @override
  Widget build(BuildContext context) {
    return DompetCard(
      variant: DompetCardVariant.csGlassCard,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Column(
        children: [
          // stat rows section
          for (var row = 0; row < 2; row++) ...[
            Row(
              children: [
                for (var col = 0; col < 3; col++)
                  Expanded(
                    child: StatCell(
                      label: _cells[row * 3 + col].label,
                      value: _value(_cells[row * 3 + col].key),
                      color: _cells[row * 3 + col].color,
                    ),
                  ),
              ],
            ),
            if (row == 0) const Divider(height: 20, color: Color(0x1AFFFFFF)),
          ],
        ],
      ),
    );
  }
}

class StatCell extends StatelessWidget {
  const StatCell({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // label section
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: Colors.white54),
          ),
          const SizedBox(height: 2),
          // value section
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
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
