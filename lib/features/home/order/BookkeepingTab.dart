// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mix/mix.dart';

import '../../../core/theme/widgets/dompet_card.dart';
import '../../../core/utils/balance.dart';
import '../../../core/utils/formatters.dart';
import '../application/transactions_controller.dart';
import '../models/transaction.dart';
import '../widgets/data_states.dart';
import 'OrderFormWidgets.dart';
import 'OrderTabWidgets.dart';

/// Filter tipe transaksi pada buku besar.
enum _LedgerFilter { all, income, expense, transfer }

String _filterLabel(_LedgerFilter f) => switch (f) {
  _LedgerFilter.all => 'All',
  _LedgerFilter.income => 'Income',
  _LedgerFilter.expense => 'Expense',
  _LedgerFilter.transfer => 'Transfer',
};

/// Tab **Bookkeeping** — buku besar (ledger) seluruh transaksi: total pemasukan/
/// pengeluaran per bulan, saldo berjalan, dan daftar transaksi per tanggal.
///
/// Sumber data: `transactionsControllerProvider`. Mode pagination di matikan
/// (`ensureAllLoaded`) karena ringkasan bulanan butuh transaksi di luar halaman
/// yang tampil.
class BookkeepingTab extends ConsumerStatefulWidget {
  const BookkeepingTab({super.key});

  @override
  ConsumerState<BookkeepingTab> createState() => _BookkeepingTabState();
}

class _BookkeepingTabState extends ConsumerState<BookkeepingTab> {
  /// Bulan pertama yang sedang dilihat (selalu tanggal 1).
  late DateTime _month = _monthOf(DateTime.now());
  _LedgerFilter _filter = _LedgerFilter.all;

  static DateTime _monthOf(DateTime d) => DateTime(d.year, d.month);

  @override
  void initState() {
    super.initState();
    // Ringkasan bulanan butuh daftar penuh, bukan hanya halaman pertama.
    Future.microtask(
      () => ref.read(transactionsControllerProvider.notifier).ensureAllLoaded(),
    );
  }

  void _shiftMonth(int delta) {
    setState(() => _month = DateTime(_month.year, _month.month + delta));
  }

  bool get _isCurrentMonth =>
      _month.year == DateTime.now().year &&
      _month.month == DateTime.now().month;

  /// Transaksi pada bulan terpilih, terbaru dulu.
  List<Transaction> _monthItems(List<Transaction> items) {
    final filtered = items.where((tx) {
      if (tx.createdAt.year != _month.year ||
          tx.createdAt.month != _month.month) {
        return false;
      }
      return switch (_filter) {
        _LedgerFilter.all => true,
        _ => tx.type == _filter.name,
      };
    }).toList();
    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(transactionsControllerProvider);
    final currency = selectedCurrency(ref);
    final items = _monthItems(transactions.items);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildMonthNav(),
        const SizedBox(height: 12),
        _buildSummary(items, currency),
        const SizedBox(height: 12),
        _buildFilters(),
        const SizedBox(height: 10),
        Expanded(child: _buildLedger(items, transactions.loading)),
      ],
    );
  }

  /// Navigasi bulan: mundur/maju + tombol lompat ke bulan berjalan.
  Widget _buildMonthNav() {
    return Row(
      children: [
        IconButton(
          tooltip: 'Previous month',
          onPressed: () => _shiftMonth(-1),
          icon: const Icon(Icons.chevron_left_rounded, color: Colors.white70),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white.withValues(alpha: 0.06),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              DateFormat('MMMM yyyy').format(_month),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ),
        IconButton(
          tooltip: 'Next month',
          onPressed: _isCurrentMonth ? null : () => _shiftMonth(1),
          icon: const Icon(Icons.chevron_right_rounded, color: Colors.white70),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white.withValues(alpha: 0.06),
          ),
        ),
        if (!_isCurrentMonth)
          TextButton(
            onPressed: () => setState(() => _month = _monthOf(DateTime.now())),
            child: const Text('This month', style: TextStyle(fontSize: 12)),
          ),
      ],
    );
  }

  /// Ringkasan pemasukan, pengeluaran, dan selisihnya untuk bulan aktif.
  Widget _buildSummary(List<Transaction> items, String currency) {
    var income = 0.0;
    var expense = 0.0;
    for (final tx in items) {
      final amount = txAmount(tx);
      if (tx.type == 'income') income += amount;
      if (tx.type == 'expense') expense += amount;
    }
    final profit = income - expense;

    return Row(
      children: [
        Expanded(
          child: OrderStatTile(
            label: 'Income',
            value: formatMoney(income, currency),
            color: const Color(0xFF34D399),
            icon: Icons.arrow_upward_rounded,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OrderStatTile(
            label: 'Expense',
            value: formatMoney(expense, currency),
            color: const Color(0xFFF87171),
            icon: Icons.arrow_downward_rounded,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OrderStatTile(
            label: 'Profit',
            value: formatMoney(profit, currency),
            color: profit >= 0
                ? const Color(0xFF34D399)
                : const Color(0xFFF87171),
            icon: Icons.trending_up_rounded,
          ),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return SizedBox(
      height: 30,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _LedgerFilter.values.length,
        separatorBuilder: (_, _) => const SizedBox(width: 6),
        itemBuilder: (_, i) {
          final f = _LedgerFilter.values[i];
          return OrderFilterChip(
            label: _filterLabel(f),
            selected: _filter == f,
            onTap: () => setState(() => _filter = f),
          );
        },
      ),
    );
  }

  Widget _buildLedger(List<Transaction> items, bool loading) {
    if (loading) return const SkeletonList(count: 4);
    if (items.isEmpty) {
      return EmptyState(
        icon: Icons.menu_book_outlined,
        label: _filter == _LedgerFilter.all
            ? 'No transactions in ${DateFormat('MMMM yyyy').format(_month)}'
            : 'No ${_filter.name} transactions in '
                  '${DateFormat('MMMM yyyy').format(_month)}',
      );
    }

    // Saldo berjalan dihitung dari transaksi terlama ke terbaru, lalu dipetakan
    // ke id transaksi supaya tiap baris tahu saldo pada titik itu.
    final chronological = items.reversed.toList();
    var running = 0.0;
    final balances = <String, double>{};
    for (final tx in chronological) {
      final amount = txAmount(tx);
      running += switch (tx.type) {
        'income' => amount,
        'expense' => -amount,
        _ => 0.0,
      };
      balances[tx.id] = running;
    }

    final groups = <String, List<Transaction>>{};
    for (final tx in items) {
      (groups[DateFormat('yyyy-MM-dd').format(tx.createdAt)] ??= []).add(tx);
    }

    final children = <Widget>[];
    groups.forEach((_, list) {
      children
        ..add(
          OrderGroupHeader(
            title: _dayLabel(list.first.createdAt),
            subtitle: '${list.length} transactions',
          ),
        )
        ..addAll([
          for (final tx in list)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _LedgerRow(
                tx: tx,
                balance: balances[tx.id] ?? 0,
                currency: selectedCurrency(ref),
                onTap: () => context.push('/struct-details', extra: tx),
              ),
            ),
        ]);
    });

    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: children,
    );
  }

  /// Label tanggal: "Today"/"Yesterday"/tanggal lengkap.
  String _dayLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(date.year, date.month, date.day);
    if (day == today) return 'Today';
    if (day == today.subtract(const Duration(days: 1))) return 'Yesterday';
    return DateFormat('d MMM yyyy').format(date);
  }
}

/// Modal transaksi sebagai angka; null bila kosong atau format tak dikenal.
num? _capitalOf(Transaction tx) {
  final raw = tx.capital;
  if (raw == null) return null;
  try {
    return Balance.parse(raw).value;
  } on FormatException {
    return null;
  }
}

/// Baris ledger: nama transaksi, tipe + modal, nominal, dan saldo berjalan.
class _LedgerRow extends StatelessWidget {
  const _LedgerRow({
    required this.tx,
    required this.balance,
    required this.currency,
    this.onTap,
  });

  final Transaction tx;
  final double balance;
  final String currency;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tone = txTone(tx.type);
    final amount = formatMoney(txAmount(tx), currency);
    final capital = _capitalOf(tx);

    return DompetCard(
      variant: DompetCardVariant.csGlassSurface,
      radius: 16,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      onTap: onTap,
      child: Row(
        children: [
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
                      color: tone.color.withValues(alpha: 0.16),
                      border: Border.all(
                        color: tone.color.withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                ),
            child: Icon(tone.icon, size: 18, color: tone.color),
          ),
          const SizedBox(width: 12),
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
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  [
                    tone.label,
                    if (capital != null)
                      'capital ${formatMoney(capital, currency)}',
                    DateFormat('HH:mm').format(tx.createdAt),
                  ].join(' · '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, color: Colors.white38),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${tone.sign}$amount',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: tone.color,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'balance ${formatMoney(balance, currency)}',
                style: const TextStyle(fontSize: 10.5, color: Colors.white38),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
