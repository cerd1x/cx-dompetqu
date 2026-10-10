import 'package:dompetqu/features/home/widgets/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mix/mix.dart';

import '../../../core/theme/dompet_brand.dart';
import '../../../core/theme/widgets/cs_dialog_daterange_picker.dart';
import '../../../core/theme/widgets/cs_select_picker.dart';
import '../../../core/theme/widgets/dompet_badge.dart';
import '../../../core/theme/widgets/dompet_card.dart';
import '../../../core/utils/balance.dart';
import '../models/transaction.dart';
import '../application/transactions_controller.dart';
import '../widgets/data_states.dart';

/// Filter tipe transaksi.
enum _TypeFilter { all, income, expense, transfer }

String _typeLabel(_TypeFilter f) => switch (f) {
  _TypeFilter.all => 'Semua',
  _TypeFilter.income => 'Income',
  _TypeFilter.expense => 'Expense',
  _TypeFilter.transfer => 'Transfer',
};

/// Filter rentang tanggal (di-hitung mundur dari sekarang / custom).
enum _DateFilter { all, today, week, month, custom }

/// Daftar transaksi terbaru + tab filter type & date.
class RecentListTransaction extends StatefulWidget {
  const RecentListTransaction({super.key, required this.transactions});

  final TransactionsState transactions;

  @override
  State<RecentListTransaction> createState() => _RecentListTransactionState();
}

class _RecentListTransactionState extends State<RecentListTransaction> {
  _TypeFilter _type = _TypeFilter.all;
  _DateFilter _date = _DateFilter.all;
  DateTimeRange? _customRange;

  /// Batas bawah & atas (inklusif) filter tanggal aktif; null = tanpa batas.
  (DateTime?, DateTime?) get _rangeBounds {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final endOfToday = today.add(const Duration(days: 1));
    return switch (_date) {
      _DateFilter.today => (today, endOfToday),
      _DateFilter.week => (now.subtract(const Duration(days: 7)), null),
      _DateFilter.month => (now.subtract(const Duration(days: 30)), null),
      _DateFilter.custom when _customRange != null => (
        DateTime(
          _customRange!.start.year,
          _customRange!.start.month,
          _customRange!.start.day,
        ),
        DateTime(
          _customRange!.end.year,
          _customRange!.end.month,
          _customRange!.end.day,
        ).add(const Duration(days: 1)),
      ),
      _ => (null, null),
    };
  }

  String _dateLabel(_DateFilter f) => switch (f) {
    _DateFilter.all => 'all',
    _DateFilter.today => 'ToDay',
    _DateFilter.week => '1W',
    _DateFilter.month => '1M',
    _DateFilter.custom =>
      _customRange == null
          ? 'Pilih rentang'
          : '${DateFormat('d MMM').format(_customRange!.start)} – '
                '${DateFormat('d MMM yyyy').format(_customRange!.end)}',
  };

  /// Buka date-range picker bergaya CS glass (container CsDialog).
  Future<void> _pickCustomRange() async {
    final now = DateTime.now();
    final picked = await showCsDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: now,
      initialDateRange:
          _customRange ??
          DateTimeRange(start: now.subtract(const Duration(days: 7)), end: now),
    );
    if (picked == null) return;
    setState(() {
      _customRange = picked;
      _date = _DateFilter.custom;
    });
  }

  List<Transaction> get _filtered {
    final (start, end) = _rangeBounds;
    return widget.transactions.items.where((tx) {
      final matchType = switch (_type) {
        _TypeFilter.all => true,
        _ => tx.type == _type.name,
      };
      final matchDate =
          (start == null || !tx.createdAt.isBefore(start)) &&
          (end == null || tx.createdAt.isBefore(end));
      return matchType && matchDate;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Box(
      style: BoxStyler()
          .padding(EdgeInsetsGeometryMix.value(const EdgeInsets.only(top: 12)))
          .decoration(
            DecorationMix.value(
              BoxDecoration(
                color: DompetBrand.csFillDark,
                borderRadius: const BorderRadius.all(Radius.circular(24)),
                border: const Border(
                  top: BorderSide(color: Color(0x4DFBBF24), width: 2),
                ),
              ),
            ),
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: _buildBody(),
            ),
          ),
          _buildFilterList(context),
        ],
      ),
    );
  }

  Widget _buildFilterList(BuildContext context) {
    return TabBottomBar(
      child: Row(
        crossAxisAlignment: .center,
        children: [
          // date filter chips section — scrollable-x
          Expanded(
            flex: 1,
            child: SizedBox(
              height: 28,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _DateFilter.values.length,
                itemBuilder: (_, i) {
                  final f = _DateFilter.values[i];
                  return _TabChip(
                    label: _dateLabel(f),
                    selected: _date == f,
                    onTap: () => f == _DateFilter.custom
                        ? _pickCustomRange()
                        : setState(() => _date = f),
                  );
                },
                separatorBuilder: (_, _) => const SizedBox(width: 6),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // type filter select picker section
          CSSelectPicker<_TypeFilter>(
            items: _TypeFilter.values
                .map((f) => CSSelectItem(value: f, label: _typeLabel(f)))
                .toList(),
            value: _type,
            onChanged: (f) => setState(() => _type = f),
            panelWidth: 100,
            optionHeight: 28,
            borderRadius: DompetBrand.radiusSm,
            triggerBuilder: (item, menuOpen, onTap) {
              return InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(DompetBrand.radiusSm),
                child: Box(
                  style: BoxStyler()
                      .padding(
                        EdgeInsetsGeometryMix.value(
                          const EdgeInsets.symmetric(horizontal: 8),
                        ),
                      )
                      .constraints(
                        BoxConstraintsMix.value(
                          (const BoxConstraints()).tighten(
                            width: null,
                            height: 28,
                          ),
                        ),
                      )
                      .decoration(
                        DecorationMix.value(
                          BoxDecoration(
                            color: DompetBrand.csFill,
                            borderRadius: BorderRadius.circular(
                              DompetBrand.radiusSm,
                            ),
                            border: Border.all(
                              color: DompetBrand.csBorder,
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.label,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(width: 4),
                      AnimatedRotation(
                        turns: menuOpen ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    // loading section
    if (widget.transactions.loading) {
      return const SkeletonList(count: 3);
    }
    // error section
    if (widget.transactions.error != null) {
      return ErrorState(message: widget.transactions.error!, onRetry: null);
    }
    final items = _filtered.reversed.toList();
    // empty section
    if (items.isEmpty) {
      return const EmptyState(label: 'Transaction Masih Kosong...');
    }
    // transaction list section — grouped by tanggal (terbaru dulu,
    // urutan grup mengikuti kemunculan pertama item).
    final groups = <String, List<Transaction>>{};
    for (final tx in items) {
      final key = DateFormat('yyyy-MM-dd').format(tx.createdAt);
      (groups[key] ??= []).add(tx);
    }
    final children = <Widget>[];
    groups.forEach((_, list) {
      children
        ..add(_DateHeader(date: list.first.createdAt))
        ..addAll([
          for (final tx in list)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: TransactionRow(
                tx: tx,
                onTap: () => context.push('/struct-details', extra: tx),
              ),
            ),
        ]);
    });
    return ListView(
      padding: const EdgeInsets.only(bottom: 4),
      children: children,
    );
  }
}

/// Header grup tanggal — "Hari ini"/"Kemarin"/tanggal lengkap.
class _DateHeader extends StatelessWidget {
  const _DateHeader({required this.date});

  final DateTime date;

  String get _label {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(date.year, date.month, date.day);
    if (day == today) return 'Hari ini';
    if (day == today.subtract(const Duration(days: 1))) return 'Kemarin';
    return DateFormat('d MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 2, 4, 8),
      child: Row(
        children: [
          Text(
            _label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
              color: Colors.white.withValues(alpha: 0.45),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Box(
              style: BoxStyler()
                  .constraints(
                    BoxConstraintsMix.value(
                      (const BoxConstraints()).tighten(width: null, height: 1),
                    ),
                  )
                  .decoration(
                    DecorationMix.value(
                      BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.06),
                      ),
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Chip tab filter glass — selected: gold accent; idle: outline redup.
class _TabChip extends StatelessWidget {
  const _TabChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFFBBF24);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? gold.withValues(alpha: 0.16) : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? gold.withValues(alpha: 0.6) : Colors.white12,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? gold : Colors.white38,
          ),
        ),
      ),
    );
  }
}

/// Tone income/expense/transfer: warna, prefix, dan ikon.
typedef _TransactionTone = ({Color color, String sign, IconData icon});

class TransactionRow extends StatelessWidget {
  const TransactionRow({super.key, required this.tx, this.onTap});

  final Transaction tx;
  final VoidCallback? onTap;

  _TransactionTone get _tone {
    switch (tx.type) {
      case 'income':
        return (
          color: const Color(0xFF34D399),
          sign: '+',
          icon: Icons.arrow_upward_rounded,
        );
      case 'expense':
        return (
          color: const Color(0xFFF87171),
          sign: '-',
          icon: Icons.arrow_downward_rounded,
        );
      default:
        return (
          color: const Color(0xFFFBBF24),
          sign: '',
          icon: Icons.swap_horiz_rounded,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tone = _tone;
    final balance = Balance.parse(tx.amount);
    final amountText = '${tone.sign}${balance.toLocalStr()}';

    return DompetCard(
      variant: DompetCardVariant.csGlassSurface,
      radius: 16,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      onTap: onTap,
      child: Row(
        children: [
          // leading icon section
          _LeadingIcon(tone: tone),
          const SizedBox(width: 12),
          // info section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Box(
                      style: BoxStyler()
                          .constraints(
                            BoxConstraintsMix.value(
                              (const BoxConstraints()).tighten(
                                width: 5,
                                height: 5,
                              ),
                            ),
                          )
                          .decoration(
                            DecorationMix.value(
                              BoxDecoration(
                                shape: BoxShape.circle,
                                color: tone.color.withValues(alpha: 0.8),
                              ),
                            ),
                          ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      DateFormat('d MMM yyyy · HH:mm').format(tx.createdAt),
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white38,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // amount badge section
          DompetBadge(
            label: amountText,
            icon: tone.icon,
            tone: tx.type == 'expense'
                ? DompetBadgeTone.danger
                : tx.type == 'income'
                ? DompetBadgeTone.success
                : DompetBadgeTone.accent,
          ),
        ],
      ),
    );
  }
}

/// Lingkaran ikon berwarna sesuai tone dengan aksen gradient halus.
class _LeadingIcon extends StatelessWidget {
  const _LeadingIcon({required this.tone});

  final _TransactionTone tone;

  @override
  Widget build(BuildContext context) {
    return Box(
      style: BoxStyler()
          .constraints(
            BoxConstraintsMix.value(
              (const BoxConstraints()).tighten(width: 38, height: 38),
            ),
          )
          .decoration(
            DecorationMix.value(
              BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    tone.color.withValues(alpha: 0.32),
                    tone.color.withValues(alpha: 0.08),
                  ],
                ),
                border: Border.all(
                  color: tone.color.withValues(alpha: 0.45),
                  width: 1,
                ),
              ),
            ),
          ),
      child: Icon(tone.icon, size: 19, color: tone.color),
    );
  }
}
