import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:cx_dompetqiu/core/logger/app_logger.dart';
import 'package:cx_dompetqiu/features/transactions/domain/models/transaction.dart';
import 'package:cx_dompetqiu/features/order/view/stores/bookkeeping_repository_provider.dart';
import 'package:cx_dompetqiu/features/order/domain/models/bookkeeping_ledger.dart'
    as domain_bookkeeping;

part 'generated/bookkeeping_store.g.dart';

/// Filter tipe transaksi pada buku besar — padanan chip di tab Bookkeeping.
///
/// [failed] **bukan** filter `paymentStatus` transaksi lokal: tab Failed
/// mengambil `Payment` langsung dari backend (`paymentsByStatus`), jadi
/// [transactionType] sengaja `null` untuk filter ini.
enum BookkeepingFilter {
  all('All', 0),
  income('Income', 0),
  expense('Expense', 0),
  transfer('Transfer', 0),
  failed('Failed', 0);

  const BookkeepingFilter(this.label, this.count);

  /// Label yang tampil di chip filter.
  final String label;
  final int count;

  /// Nilai `Transaction.type` yang cocok dengan filter ini; `null` berarti
  /// tidak memfilter tipe (atau sumber datanya bukan transaksi).
  String? get transactionType => switch (this) {
    BookkeepingFilter.income => 'income',
    BookkeepingFilter.expense => 'expense',
    BookkeepingFilter.transfer => 'transfer',
    BookkeepingFilter.all || BookkeepingFilter.failed => null,
  };
}

/// Satu entri datar pada buku besar: header hari atau baris transaksi.
///
/// Di-flatten supaya `ListView.builder` tetap lazy (header dan baris berbagi
/// satu indeks).
sealed class LedgerEntry {
  const LedgerEntry();
}

/// Header satu hari beserta jumlah transaksi di hari itu.
class LedgerDayHeader extends LedgerEntry {
  const LedgerDayHeader({required this.date, required this.count});

  final DateTime date;
  final int count;
}

/// Baris transaksi pada buku besar.
class LedgerTransactionRow extends LedgerEntry {
  const LedgerTransactionRow(this.transaction);

  final Transaction transaction;
}

/// State tab Bookkeeping: bulan & filter aktif beserta data turunannya.
///
/// Ringkasan, saldo berjalan, dan grup tanggal dihitung sekali di store —
/// bukan tiap frame di `build` widget — karena daftar transaksi bulanan bisa
/// panjang dan perhitungannya ikut berulang saat filter/bulan berubah.
class BookkeepingState {
  const BookkeepingState({
    required this.month,
    required this.filter,
    this.items = const [],
    this.income = 0,
    this.expense = 0,
    this.balances = const {},
    this.entries = const [],
    this.counts = const {},
    this.loading = false,
  });

  /// Bulan yang sedang dilihat (selalu tanggal 1).
  final DateTime month;

  /// Filter tipe transaksi yang aktif.
  final BookkeepingFilter filter;

  /// Transaksi bulan terpilih untuk [filter] aktif, terbaru dulu.
  final List<Transaction> items;

  /// Total nominal transaksi `income` pada [items].
  final double income;

  /// Total nominal transaksi `expense` pada [items].
  final double expense;

  /// Saldo berjalan per id transaksi — dihitung dari transaksi terlama ke
  /// terbaru di bulan aktif, supaya tiap baris tahu saldo pada titik itu.
  final Map<String, double> balances;

  /// Entri buku besar yang sudah di-flatten (header hari + baris).
  final List<LedgerEntry> entries;
  final Map<BookkeepingFilter, int> counts;

  /// `true` selama daftar transaksi sumber masih dimuat.
  final bool loading;

  /// Selisih [income] dan [expense].
  double get profit => income - expense;

  /// Apakah [month] adalah bulan berjalan (tombol "Next month" dimatikan).
  bool get isCurrentMonth {
    final now = DateTime.now();
    return month.year == now.year && month.month == now.month;
  }

  BookkeepingState copyWith({
    DateTime? month,
    BookkeepingFilter? filter,
    List<Transaction>? items,
    double? income,
    double? expense,
    Map<String, double>? balances,
    List<LedgerEntry>? entries,
    Map<BookkeepingFilter, int>? counts,
    bool? loading,
  }) {
    return BookkeepingState(
      month: month ?? this.month,
      filter: filter ?? this.filter,
      items: items ?? this.items,
      income: income ?? this.income,
      expense: expense ?? this.expense,
      balances: balances ?? this.balances,
      entries: entries ?? this.entries,
      counts: counts ?? this.counts,
      loading: loading ?? this.loading,
    );
  }
}

/// Store tab Bookkeeping — bulan/filter aktif + data turunan buku besar.
///
/// Mengambil data dari [bookkeepingRepositoryProvider] secara asinkron
/// daripada mengkomputi dari `transactionsStoreProvider` secara lokal.
@Riverpod(keepAlive: true)
class BookkeepingStore extends _$BookkeepingStore {
  DateTime _month = _startOfMonth(DateTime.now());
  BookkeepingFilter _filter = BookkeepingFilter.all;

  @override
  BookkeepingState build() {
    // Initial state: loading tanpa data. _refresh() dipanggil dari initDidChange
    // atau user interaksi (pindah bulan/filter).
    // Defer ke microtask untuk load data pertama kali.
    Future.microtask(() {
      if (ref.mounted) {
        _loadLedger();
      }
    });
    return BookkeepingState(month: _month, filter: _filter, loading: true);
  }

  /// Geser bulan yang dilihat sebesar [delta] bulan (-1 mundur, +1 maju).
  void shiftMonth(int delta) {
    _month = DateTime(_month.year, _month.month + delta);
    _refresh();
  }

  /// Kembali ke bulan berjalan.
  void jumpToCurrentMonth() {
    _month = _startOfMonth(DateTime.now());
    _refresh();
  }

  /// Ganti filter tipe transaksi.
  void selectFilter(BookkeepingFilter filter) {
    if (_filter == filter) return;
    _filter = filter;
    _refresh();
  }

  /// Muat ulang data dari server sesuai bulan & filter aktif.
  void _refresh() {
    if (!ref.mounted) return;
    _loadLedger();
  }

  Future<void> _loadLedger() async {
    if (!ref.mounted) return;
    final repo = ref.read(bookkeepingRepositoryProvider);
    state = state.copyWith(loading: true);
    try {
      // Map store filter to domain filter (skip 'failed' as it uses separate API)
      if (_filter == BookkeepingFilter.failed) {
        state = state.copyWith(loading: false);
        return;
      }
      final domainFilter = _mapToDomainFilter(_filter);
      final ledger = await repo.getLedger(
        month: _formatMonth(_month),
        filter: domainFilter,
        timezoneOffsetMinutes: 420, // WIB default
      );

      // Extract all transactions from day groups
      final allTx = <Transaction>[];
      for (final group in ledger.groups) {
        for (final entry in group.entries) {
          allTx.add(entry.transaction);
        }
      }

      // Compute balances from running balance in entries
      final balances = <String, double>{};
      for (final group in ledger.groups) {
        for (final entry in group.entries) {
          balances[entry.transaction.id] = _parseMoneyAmount(
            entry.runningBalance,
          );
        }
      }

      // Flatten entries into LedgerEntry list
      final entries = <LedgerEntry>[];
      for (final group in ledger.groups) {
        entries.add(
          LedgerDayHeader(
            date: DateTime.parse(group.date),
            count: group.transactionCount,
          ),
        );
        for (final entry in group.entries) {
          entries.add(LedgerTransactionRow(entry.transaction));
        }
      }

      // Parse summaries to get income/expense totals
      double totalIncome = 0;
      double totalExpense = 0;
      for (final summary in ledger.summaries) {
        totalIncome += _parseMoneyAmount(summary.income);
        totalExpense += _parseMoneyAmount(summary.expense);
      }

      state = state.copyWith(
        month: _month,
        filter: _filter,
        items: allTx,
        income: totalIncome,
        expense: totalExpense,
        balances: balances,
        entries: entries,
        loading: false,
      );
    } catch (e) {
      if (!ref.mounted) return;
      AppLogger.instance.error(
        'Gagal load ledger',
        tag: 'BookkeepingStore',
        error: e,
      );
      state = state.copyWith(loading: false);
    }
  }

  /// Parse Money string "IDR 15000" → 15000.0
  double _parseMoneyAmount(String money) {
    final parts = money.split(' ');
    if (parts.length >= 2) {
      try {
        return double.tryParse(parts.sublist(1).join(' ')) ?? 0.0;
      } catch (_) {
        return 0.0;
      }
    }
    return 0.0;
  }

  /// Format DateTime to YYYY-MM string for API
  String _formatMonth(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}';
  }

  /// Map store-level BookkeepingFilter to domain-level BookkeepingFilter.
  /// Store has 'failed' which uses separate API; map others to domain enum.
  domain_bookkeeping.BookkeepingFilter _mapToDomainFilter(
    BookkeepingFilter filter,
  ) {
    return switch (filter) {
      BookkeepingFilter.all => domain_bookkeeping.BookkeepingFilter.all,
      BookkeepingFilter.income => domain_bookkeeping.BookkeepingFilter.income,
      BookkeepingFilter.expense => domain_bookkeeping.BookkeepingFilter.expense,
      BookkeepingFilter.transfer =>
        domain_bookkeeping.BookkeepingFilter.transfer,
      BookkeepingFilter.failed => domain_bookkeeping.BookkeepingFilter.all,
    };
  }

  static DateTime _startOfMonth(DateTime date) =>
      DateTime(date.year, date.month);
}
