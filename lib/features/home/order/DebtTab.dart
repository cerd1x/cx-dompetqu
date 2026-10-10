// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mix/mix.dart';

import '../../../core/theme/cs_dialog.dart';
import '../../../core/theme/dompet_brand.dart';
import '../../../core/theme/widgets/dompet_button.dart';
import '../../../core/theme/widgets/dompet_card.dart';
import '../../../core/utils/balance.dart';
import '../../../core/utils/formatters.dart';
import '../application/contacts_controller.dart';
import '../application/transactions_controller.dart';
import '../data/order_remote_source.dart';
import '../models/transaction.dart';
import '../widgets/data_states.dart';
import 'OrderTabWidgets.dart';
import 'debt_settlements.dart';

/// Kategori yang dipakai backend saat `createOrderLoan` — penanda sebuah
/// transaksi adalah utang pelanggan (`create-order-loan.usecase.ts`).
const String kLoanCategory = 'Loan';

/// Batas umur tunggakan sebelum ditandai "overdue".
const int kDebtOverdueDays = 30;

/// Tab **Debt** — daftar utang pelanggan (piutang) per kontak, dikelompokkan per
/// pelanggan + mata uang.
///
/// Sumber utang: transaksi kategori `Loan` (dibuat dari form Loan) atau transaksi
/// `expense` dengan metode pembayaran `credit`. Status lunas disimpan lokal di
/// [debtSettlementsProvider] karena API tidak menyediakan flag pelunasan;
/// pembayaran yang ditebus tetap dicatat ke ledger sebagai transaksi income.
class DebtTab extends ConsumerStatefulWidget {
  const DebtTab({super.key});

  @override
  ConsumerState<DebtTab> createState() => _DebtTabState();
}

enum _DebtFilter { outstanding, settled }

class _DebtTabState extends ConsumerState<DebtTab> {
  _DebtFilter _filter = _DebtFilter.outstanding;

  /// Id transaksi yang sedang diproses pelunasan (men Disable tombolnya).
  final Set<String> _busy = <String>{};

  @override
  void initState() {
    super.initState();
    // Nama kontak untuk setiap utang butuh daftar kontak penuh.
    Future.microtask(
      () => ref.read(contactsControllerProvider.notifier).ensureAllLoaded(),
    );
  }

  bool _isDebt(Transaction tx) {
    if (tx.type != 'expense') return false;
    if ((tx.category ?? '').toLowerCase() == kLoanCategory.toLowerCase()) {
      return true;
    }
    return tx.paymentMethod?.type == 'credit';
  }

  /// Utang yang punya pelanggan — tanpa `customerId` pembayaran tak bisa dicatat.
  List<_Debt> _debts(List<Transaction> items, Set<String> settledIds) {
    final debts = <_Debt>[];
    for (final tx in items) {
      final customerId = tx.customerId;
      if (customerId == null || customerId.isEmpty) continue;
      if (!_isDebt(tx)) continue;
      final balance = Balance.parse(tx.amount);
      debts.add(
        _Debt(
          tx: tx,
          customerId: customerId,
          currency: balance.code,
          amount: balance.value.toDouble(),
          settled: settledIds.contains(tx.id),
        ),
      );
    }
    debts.sort((a, b) => b.tx.createdAt.compareTo(a.tx.createdAt));
    return debts;
  }

  /// Kelompok utang per pelanggan + mata uang, dengan total tunggakan.
  List<_DebtGroup> _group(List<_Debt> debts) {
    final groups = <String, _DebtGroup>{};
    for (final debt in debts) {
      groups
          .putIfAbsent(
            '${debt.customerId}|${debt.currency}',
            () => _DebtGroup(
              customerId: debt.customerId,
              currency: debt.currency,
            ),
          )
          .debts
          .add(debt);
    }
    final list = groups.values.toList();
    list.sort((a, b) => b.outstanding.compareTo(a.outstanding));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(transactionsControllerProvider);
    final contacts = ref.watch(contactsControllerProvider);
    final settledIds = ref.watch(debtSettlementsProvider);
    final names = {for (final c in contacts.items) c.id: c.name};

    final debts = _debts(transactions.items, settledIds);
    final visible = _filter == _DebtFilter.outstanding
        ? debts.where((d) => !d.settled).toList()
        : debts.where((d) => d.settled).toList();
    final groups = _group(visible);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSummary(debts),
        const SizedBox(height: 12),
        _buildFilters(debts),
        const SizedBox(height: 10),
        Expanded(
          child: _buildList(
            groups: groups,
            names: names,
            loading: transactions.loading,
            totalVisible: visible.length,
          ),
        ),
      ],
    );
  }

  /// Total tunggakan, jumlah utang, dan yang sudah lewat [kDebtOverdueDays].
  Widget _buildSummary(List<_Debt> debts) {
    final outstanding = debts.where((d) => !d.settled);
    final currency = outstanding.isNotEmpty
        ? outstanding.first.currency
        : 'IDR';
    var total = 0.0;
    var overdue = 0;
    for (final debt in outstanding) {
      total += debt.amount;
      if (debt.isOverdue) overdue++;
    }

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: OrderStatTile(
            label: 'Outstanding',
            value: formatMoney(total, currency),
            color: DompetBrand.gold,
            icon: Icons.receipt_long_outlined,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OrderStatTile(
            label: 'Debts',
            value: '${outstanding.length}',
            color: const Color(0xFFFBBF24),
            icon: Icons.list_alt_rounded,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OrderStatTile(
            label: 'Overdue',
            value: '$overdue',
            color: overdue > 0 ? DompetBrand.pink : Colors.white54,
            icon: Icons.schedule_rounded,
          ),
        ),
      ],
    );
  }

  Widget _buildFilters(List<_Debt> debts) {
    var outstanding = 0;
    var settled = 0;
    for (final debt in debts) {
      if (debt.settled) {
        settled++;
      } else {
        outstanding++;
      }
    }
    return Row(
      children: [
        OrderFilterChip(
          label: 'Outstanding ($outstanding)',
          selected: _filter == _DebtFilter.outstanding,
          onTap: () => setState(() => _filter = _DebtFilter.outstanding),
        ),
        const SizedBox(width: 6),
        OrderFilterChip(
          label: 'Settled ($settled)',
          selected: _filter == _DebtFilter.settled,
          onTap: () => setState(() => _filter = _DebtFilter.settled),
        ),
      ],
    );
  }

  Widget _buildList({
    required List<_DebtGroup> groups,
    required Map<String, String> names,
    required bool loading,
    required int totalVisible,
  }) {
    if (loading) return const SkeletonList(count: 4);
    if (totalVisible == 0) {
      return EmptyState(
        icon: Icons.receipt_long_outlined,
        label: _filter == _DebtFilter.outstanding
            ? 'No outstanding debts'
            : 'No settled debts yet',
      );
    }

    final children = <Widget>[];
    for (final group in groups) {
      children
        ..add(
          OrderGroupHeader(
            title: names[group.customerId] ?? 'Unknown contact',
            subtitle:
                '${group.debts.length} debts · '
                '${group.settledCount} settled',
            trailing: _filter == _DebtFilter.outstanding
                ? _SettleAllButton(
                    busy: group.debts.any((d) => _busy.contains(d.tx.id)),
                    onPressed: () => _settleAll(group, names),
                  )
                : null,
          ),
        )
        ..addAll([
          for (final debt in group.debts)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _DebtRow(
                debt: debt,
                busy: _busy.contains(debt.tx.id),
                onSettle: () => _settle(debt, names[group.customerId]),
                onReopen: () => ref
                    .read(debtSettlementsProvider.notifier)
                    .revert(debt.tx.id),
              ),
            ),
        ]);
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: children,
    );
  }

  /// Tebus satu utang: konfirmasi → catat pembayaran income → tandai lunas.
  Future<void> _settle(_Debt debt, String? contactName) async {
    final confirmed = await _confirm(
      title: 'Settle debt?',
      message:
          'Record a payment of ${formatMoney(debt.amount, debt.currency)} '
          'from ${contactName ?? 'this contact'}. The payment is stored as an '
          'income transaction in the ledger.',
      actionLabel: 'Settle',
    );
    if (!confirmed || !mounted) return;

    setState(() => _busy.add(debt.tx.id));
    try {
      final ok = await ref
          .read(orderRemoteSourceProvider)
          .createDebtPayment(
            totalAmount: debt.amount,
            currency: debt.currency,
            customerId: debt.customerId,
            description: debt.description,
          );
      if (!mounted) return;
      if (!ok) {
        _toast('Failed to record the payment');
        return;
      }
      await ref.read(debtSettlementsProvider.notifier).markSettled(debt.tx.id);
      // Pembayaran baru tercatat di ledger → muat ulang transaksi.
      ref.invalidate(transactionsControllerProvider);
      _toast('Debt settled');
    } catch (e) {
      if (mounted) _toast(e is Exception ? '$e' : '$e');
    } finally {
      if (mounted) setState(() => _busy.remove(debt.tx.id));
    }
  }

  /// Tebus semua utang satu pelanggan dalam satu konfirmasi.
  Future<void> _settleAll(_DebtGroup group, Map<String, String> names) async {
    final pending = group.debts.where((d) => !d.settled).toList();
    if (pending.isEmpty) return;

    final confirmed = await _confirm(
      title: 'Settle all debts?',
      message:
          'Record payments totaling '
          '${formatMoney(group.outstanding, group.currency)} from '
          '${names[group.customerId] ?? 'this contact'} across '
          '${pending.length} debts.',
      actionLabel: 'Settle all',
    );
    if (!confirmed || !mounted) return;

    setState(() => _busy.addAll(pending.map((d) => d.tx.id)));
    final failed = <_Debt>[];
    try {
      for (final debt in pending) {
        try {
          final ok = await ref
              .read(orderRemoteSourceProvider)
              .createDebtPayment(
                totalAmount: debt.amount,
                currency: debt.currency,
                customerId: debt.customerId,
                description: debt.description,
              );
          if (!ok) {
            failed.add(debt);
            continue;
          }
          await ref
              .read(debtSettlementsProvider.notifier)
              .markSettled(debt.tx.id);
        } catch (_) {
          failed.add(debt);
        }
      }
      if (failed.isEmpty) ref.invalidate(transactionsControllerProvider);
      if (!mounted) return;
      if (failed.isEmpty) {
        _toast('All debts settled');
      } else {
        _toast(
          '${pending.length - failed.length} settled, ${failed.length} failed',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _busy.removeAll(pending.map((d) => d.tx.id)));
      }
    }
  }

  Future<bool> _confirm({
    required String title,
    required String message,
    required String actionLabel,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => CsDialog(
        title: title,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          DompetButton(
            label: actionLabel,
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
        child: Text(
          message,
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
      ),
    );
    return result ?? false;
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontSize: 12.5)),
        backgroundColor: Colors.black87,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

/// Satu utang: transaksi `Loan`/`credit` milik satu pelanggan.
class _Debt {
  const _Debt({
    required this.tx,
    required this.customerId,
    required this.currency,
    required this.amount,
    required this.settled,
  });

  final Transaction tx;
  final String customerId;
  final String currency;
  final double amount;
  final bool settled;

  String get description =>
      'Debt payment: ${tx.displayName} (${DateFormat('d MMM yyyy').format(tx.createdAt)})';

  bool get isOverdue {
    final age = DateTime.now().difference(tx.createdAt).inDays;
    return age >= kDebtOverdueDays;
  }
}

/// Utang satu pelanggan untuk satu mata uang.
class _DebtGroup {
  _DebtGroup({required this.customerId, required this.currency});

  final String customerId;
  final String currency;
  final List<_Debt> debts = [];

  double get outstanding =>
      debts.where((d) => !d.settled).fold(0, (sum, d) => sum + d.amount);

  int get settledCount => debts.where((d) => d.settled).length;
}

/// Baris satu utang: tanggal, nominal, dan aksi lunas/buka lagi.
class _DebtRow extends StatelessWidget {
  const _DebtRow({
    required this.debt,
    required this.busy,
    required this.onSettle,
    required this.onReopen,
  });

  final _Debt debt;
  final bool busy;
  final VoidCallback onSettle;
  final VoidCallback onReopen;

  @override
  Widget build(BuildContext context) {
    final amount = formatMoney(debt.amount, debt.currency);

    return DompetCard(
      variant: DompetCardVariant.csGlassSurface,
      radius: 16,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                      color: debt.settled
                          ? const Color(0xFF34D399).withValues(alpha: 0.16)
                          : DompetBrand.pink.withValues(alpha: 0.16),
                      border: Border.all(
                        color:
                            (debt.settled
                                    ? const Color(0xFF34D399)
                                    : DompetBrand.pink)
                                .withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                ),
            child: Icon(
              debt.settled
                  ? Icons.check_circle_outline_rounded
                  : Icons.hourglass_bottom_rounded,
              size: 18,
              color: debt.settled ? const Color(0xFF34D399) : DompetBrand.pink,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  debt.tx.displayName,
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
                    Text(
                      DateFormat('d MMM yyyy').format(debt.tx.createdAt),
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white38,
                      ),
                    ),
                    if (!debt.settled && debt.isOverdue) ...[
                      const SizedBox(width: 6),
                      const Text(
                        'overdue',
                        style: TextStyle(fontSize: 11, color: DompetBrand.pink),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (debt.settled)
            DebtPaymentBadge(amount: amount)
          else
            DompetButton(
              label: busy ? '...' : 'Settle',
              onPressed: busy ? null : onSettle,
              loading: busy,
              height: 30,
            ),
        ],
      ),
    );
  }
}

/// Tombol "Settle all" di header grup pelanggan.
class _SettleAllButton extends StatelessWidget {
  const _SettleAllButton({required this.busy, required this.onPressed});

  final bool busy;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DompetButton(
      label: 'Settle all',
      onPressed: busy ? null : onPressed,
      loading: busy,
      height: 30,
    );
  }
}
