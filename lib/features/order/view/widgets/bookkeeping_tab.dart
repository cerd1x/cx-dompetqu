import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mix/mix.dart';

import 'package:dompetqu/core/theme/widgets/cx_card.dart';
import 'package:dompetqu/core/utils/balance.dart';
import 'package:dompetqu/core/utils/formatters.dart';
import 'package:dompetqu/core/utils/platform_target.dart';
import 'package:dompetqu/features/transactions/view/stores/transactions_store.dart';
import 'package:dompetqu/features/transactions/domain/models/transaction.dart';
import 'package:dompetqu/features/payments/domain/models/payment.dart';
import 'package:dompetqu/features/payments/view/stores/failed_payments_store.dart';
import 'package:dompetqu/features/payments/view/widgets/payment_widgets.dart';
import 'package:dompetqu/core/theme/widgets/data_states.dart';
import 'package:dompetqu/features/order/view/stores/bookkeeping_store.dart';
import 'package:dompetqu/features/order/view/widgets/order_form_widgets.dart';
import 'package:dompetqu/features/order/view/widgets/order_tab_widgets.dart';
import 'package:dompetqu/core/theme/widgets/cx_filter_chip.dart';
import 'package:dompetqu/core/cx_icons.dart';

/// Tab **Bookkeeping** — buku besar (ledger) seluruh transaksi: total pemasukan/
/// pengeluaran per bulan, saldo berjalan, dan daftar transaksi per tanggal.
///
/// Bulan/filter aktif dan data turunannya (ringkasan, saldo berjalan, grup
/// tanggal) ada di [bookkeepingStoreProvider]; widget hanya merender. Sumber
/// datanya `transactionsStoreProvider` dengan mode pagination dimatikan
/// (`ensureAllLoaded` dipanggil store) karena ringkasan bulanan butuh transaksi
/// di luar halaman yang tampil.
class BookkeepingTab extends ConsumerWidget {
  const BookkeepingTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bookkeepingStoreProvider);
    final store = ref.read(bookkeepingStoreProvider.notifier);
    final currency = selectedCurrency(ref);

    // Tab Failed punya sumber data sendiri: query `paymentsByStatus(status:
    // failed)` langsung ke backend, bukan filter transaksi di klien.
    if (state.filter == BookkeepingFilter.failed) {
      final failed = ref.watch(failedPaymentsProvider(state.month));
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildMonthNav(context, store, state),
          const SizedBox(height: 12),
          _buildFailedSummary(failed.value ?? const <Payment>[]),
          const SizedBox(height: 12),
          _buildFilters(store, state),
          const SizedBox(height: 10),
          Expanded(
            child: _buildFailedLedger(context, ref, failed, state.month),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildMonthNav(context, store, state),
        const SizedBox(height: 12),
        _buildSummary(state, currency),
        const SizedBox(height: 12),
        _buildFilters(store, state),
        const SizedBox(height: 10),
        Expanded(child: _buildLedger(context, ref, state)),
      ],
    );
  }

  /// Navigasi bulan: mundur/maju + tombol lompat ke bulan berjalan.
  Widget _buildMonthNav(
    BuildContext context,
    BookkeepingStore store,
    BookkeepingState state,
  ) {
    return Row(
      children: [
        IconButton(
          tooltip: 'Previous month',
          onPressed: () => store.shiftMonth(-1),
          icon: const Icon(CxIcons.chevronLeftRounded, color: Colors.white70),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white.withValues(alpha: 0.06),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              DateFormat('MMMM yyyy').format(state.month),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ),
        IconButton(
          tooltip: 'Next month',
          onPressed: state.isCurrentMonth ? null : () => store.shiftMonth(1),
          icon: const Icon(CxIcons.chevronRightRounded, color: Colors.white70),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white.withValues(alpha: 0.06),
          ),
        ),
        if (!state.isCurrentMonth)
          TextButton(
            onPressed: store.jumpToCurrentMonth,
            child: const Text('This month', style: TextStyle(fontSize: 12)),
          ),
      ],
    );
  }

  /// Ringkasan payment gagal pada bulan aktif (dari query `paymentsByStatus`).
  Widget _buildFailedSummary(List<Payment> payments) {
    final retryable = payments.where((p) => p.canRetry).length;
    return Row(
      children: [
        Expanded(
          child: OrderStatTile(
            label: 'Failed Payments',
            value: payments.length.toString(),
            color: const Color(0xFFF87171),
            icon: CxIcons.errorOutlineRounded,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OrderStatTile(
            label: 'Retry Available',
            value: retryable.toString(),
            color: const Color(0xFFFBBF24),
            icon: CxIcons.refreshRounded,
          ),
        ),
      ],
    );
  }

  /// Ringkasan pemasukan, pengeluaran, dan selisihnya untuk bulan aktif.
  Widget _buildSummary(BookkeepingState state, String currency) {
    return Row(
      children: [
        Expanded(
          child: OrderStatTile(
            label: 'Income',
            value: formatMoney(state.income, currency),
            color: const Color(0xFF34D399),
            icon: CxIcons.arrowUpwardRounded,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OrderStatTile(
            label: 'Expense',
            value: formatMoney(state.expense, currency),
            color: const Color(0xFFF87171),
            icon: CxIcons.arrowDownwardRounded,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OrderStatTile(
            label: 'Profit',
            value: formatMoney(state.profit, currency),
            color: state.profit >= 0
                ? const Color(0xFF34D399)
                : const Color(0xFFF87171),
            icon: CxIcons.trendingUpRounded,
          ),
        ),
      ],
    );
  }

  Widget _buildFilters(BookkeepingStore store, BookkeepingState state) {
    return SizedBox(
      height: 30,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: BookkeepingFilter.values.length,
        separatorBuilder: (_, _) => const SizedBox(width: 6),
        itemBuilder: (_, i) {
          final f = BookkeepingFilter.values[i];
          final count = state.counts[f] ?? 0;
          return CxFilterChip(
            label: '${f.label} ($count)',
            icon: _filterIcon(f),
            selected: state.filter == f,
            onTap: () => store.selectFilter(f),
          );
        },
      ),
    );
  }

  Widget _buildLedger(
    BuildContext context,
    WidgetRef ref,
    BookkeepingState state,
  ) {
    if (state.loading) return const SkeletonList(count: 4);
    if (state.items.isEmpty) {
      return EmptyState(
        icon: CxIcons.menuBookOutlined,
        label: state.filter == BookkeepingFilter.all
            ? 'No transactions in ${DateFormat('MMMM yyyy').format(state.month)}'
            : 'No ${state.filter.name} transactions in '
                  '${DateFormat('MMMM yyyy').format(state.month)}',
      );
    }

    // Saldo berjalan & grup tanggal sudah dihitung store; di sini hanya render
    // satu list datar supaya `ListView.builder` tetap lazy.
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: state.entries.length,
      itemBuilder: (context, i) => switch (state.entries[i]) {
        LedgerDayHeader(:final date, :final count) => OrderGroupHeader(
          title: _dayLabel(date),
          subtitle: '$count transactions',
        ),
        LedgerTransactionRow(:final transaction) => RepaintBoundary(
          // `Builder` memberi context yang menunjuk ke render box baris,
          // dipakai sebagai jangkar popup menu long-press.
          child: Builder(
            builder: (rowContext) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _LedgerRow(
                tx: transaction,
                balance: state.balances[transaction.id] ?? 0,
                currency: selectedCurrency(ref),
                onTap: () =>
                    context.push('/struct-details', extra: transaction),
                onLongPress: () =>
                    _showLedgerActions(context, ref, rowContext, transaction),
                onDoubleTap: PlatformTarget.of(context).isDesktop
                    ? () => _showLedgerActions(
                        context,
                        ref,
                        rowContext,
                        transaction,
                      )
                    : null,
              ),
            ),
          ),
        ),
      },
    );
  }

  /// Daftar payment gagal (query `paymentsByStatus`), tanpa saldo berjalan
  /// karena Payment bukan transaksi keuangan.
  Widget _buildFailedLedger(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<Payment>> payments,
    DateTime month,
  ) {
    return payments.when(
      skipLoadingOnRefresh: false,
      loading: () => const SkeletonList(count: 3),
      error: (error, _) => ErrorState(
        message: 'Gagal memuat payment gagal: $error',
        onRetry: () => ref.invalidate(failedPaymentsProvider(month)),
      ),
      data: (items) {
        if (items.isEmpty) {
          return EmptyState(
            icon: CxIcons.checkCircleOutlineRounded,
            label:
                'No failed payments in '
                '${DateFormat('MMMM yyyy').format(month)}',
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.only(bottom: 24),
          itemCount: items.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (_, i) => RepaintBoundary(
            child: FailedPaymentRow(
              payment: items[i],
              onTap: () => context.push('/payment-failed', extra: items[i]),
            ),
          ),
        );
      },
    );
  }

  /// Menu aksi baris ledger: ubah status pembayaran transaksi.
  ///
  /// Dibuka lewat long-press (mobile) atau double-tap (desktop).
  /// `unpaid` → "Mark as paid", `paid` → "Mark as unpaid", `failed` → toggle ke `paid`/`unpaid`.
  /// Selalu bisa diretry: row tidak disabled setelah gagal.
  Future<void> _showLedgerActions(
    BuildContext context,
    WidgetRef ref,
    BuildContext rowContext,
    Transaction tx,
  ) async {
    final isFailed = tx.paymentStatus == 'failed';
    final isPaid = tx.paymentStatus == 'paid';
    final selected = await showMenu<bool>(
      context: context,
      position: _menuPosition(context, rowContext),
      color: const Color(0xFF141414),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      items: [
        PopupMenuItem<bool>(
          value: true,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isFailed
                    ? CxIcons.refreshRounded
                    : (isPaid
                          ? CxIcons.undoRounded
                          : CxIcons.checkCircleOutlineRounded),
                size: 18,
                color: isFailed
                    ? const Color(0xFFFBBF24)
                    : (isPaid
                          ? const Color(0xFFFBBF24)
                          : const Color(0xFF34D399)),
              ),
              const SizedBox(width: 10),
              Text(
                isFailed
                    ? 'Retry payment status'
                    : (isPaid ? 'Mark as unpaid' : 'Mark as paid'),
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
    if (selected != true || !context.mounted) return;

    final nextStatus = isFailed ? 'unpaid' : (isPaid ? 'unpaid' : 'paid');
    // Controller melakukan update optimistis; pill status berubah lebih dulu
    // lalu dikembalikan bila mutation ke backend gagal.
    final ok = await ref
        .read(transactionsStoreProvider.notifier)
        .updatePaymentStatus(tx, paymentStatus: nextStatus);
    if (!context.mounted) return;
    final message = ok
        ? (isFailed
              ? nextStatus == 'paid'
                    ? 'Marked as paid'
                    : 'Marked as unpaid'
              : (isPaid ? 'Marked as unpaid' : 'Marked as paid'))
        : 'Failed to update payment status';
    _toast(context, message);
  }

  /// Posisi popup menu relatif terhadap overlay, dihitung dari render box
  /// baris yang di-long-press.
  RelativeRect _menuPosition(BuildContext context, BuildContext rowContext) {
    final box = rowContext.findRenderObject() as RenderBox?;
    final overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox?;
    if (box == null || overlay == null) {
      return const RelativeRect.fromLTRB(24, 240, 24, 0);
    }
    final topLeft = box.localToGlobal(Offset.zero, ancestor: overlay);
    return RelativeRect.fromRect(
      Rect.fromLTWH(topLeft.dx, topLeft.dy, box.size.width, box.size.height),
      Offset.zero & overlay.size,
    );
  }

  void _toast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontSize: 12.5)),
        backgroundColor: Colors.black87,
        behavior: SnackBarBehavior.floating,
      ),
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

/// Ikon chip filter buku besar.
///
/// Diselaraskan dengan [txTone] supaya tipe transaksi punya ikon yang sama di
/// chip filter dan di baris ledger — `all`/`failed` memakai ikon daftar/error
/// karena keduanya bukan tipe transaksi.
IconData _filterIcon(BookkeepingFilter filter) => switch (filter) {
  BookkeepingFilter.all => CxIcons.listAltRounded,
  BookkeepingFilter.income => CxIcons.arrowUpwardRounded,
  BookkeepingFilter.expense => CxIcons.arrowDownwardRounded,
  BookkeepingFilter.transfer => CxIcons.swapHorizRounded,
  BookkeepingFilter.failed => CxIcons.errorOutlineRounded,
};

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
    this.onLongPress,
    this.onDoubleTap,
  });

  final Transaction tx;
  final double balance;
  final String currency;
  final VoidCallback? onTap;

  /// Aksi long-press baris (mobile): membuka popup menu ubah status pembayaran.
  final VoidCallback? onLongPress;

  /// Aksi double-tap baris (desktop) — aksi yang sama dengan [onLongPress].
  final VoidCallback? onDoubleTap;

  @override
  Widget build(BuildContext context) {
    final tone = txTone(tx.type);
    final amount = formatMoney(txAmount(tx), currency);
    final capital = _capitalOf(tx);

    final card = CxCard(
      variant: CxCardVariant.csGlassSurface,
      radius: 16,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          // ikon section — penanda tipe transaksi; warna & ikon dari `txTone`
          // supaya konsisten dengan tab Debt.
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
          // keterangan section — nama transaksi + meta (status bayar, tipe,
          // modal, jam). Dibatasi satu baris masing-masing agar tinggi baris
          // stabil walau deskripsi panjang.
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
                Row(
                  children: [
                    // Status pembayaran transaksi — padanan `paymentStatus`
                    // (`TransactionPaymentStatus`) dari backend.
                    PaymentStatusPill(status: tx.paymentStatus),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        // Digabung satu baris dengan pemisah agar tidak
                        // menambah tinggi; modal hanya muncul bila ada.
                        [
                          tone.label,
                          if (capital != null)
                            'capital ${formatMoney(capital, currency)}',
                          DateFormat('HH:mm').format(tx.createdAt),
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
          // nominal section — angka transaksi di atas, saldo berjalan pada
          // titik transaksi ini di bawahnya.
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

    // Satu `GestureDetector` untuk seluruh gesture baris: tap (buka detail),
    // long-press (mobile) dan double-tap (desktop) untuk menu aksi. Digabung
    // di satu arena supaya Flutter bisa menunda tap saat menunggu tap kedua;
    // bila `onDoubleTap` null (mobile) tap tetap instan.
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      onLongPress: onLongPress,
      onDoubleTap: onDoubleTap,
      child: card,
    );
  }
}
