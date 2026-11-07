import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:dompetqu/features/transactions/domain/models/transaction.dart';
import 'package:dompetqu/features/transactions/view/stores/transactions_store.dart';

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
}

/// Store tab Bookkeeping — bulan/filter aktif + data turunan buku besar.
///
/// Sumber data tetap `transactionsStoreProvider`; store ini menontonnya supaya
/// ringkasan ikut segar setelah transaksi ditambah/diubah. Pagination dimatikan
/// lewat `ensureAllLoaded()` karena ringkasan bulanan butuh transaksi di luar
/// halaman yang tampil.
@Riverpod(keepAlive: true)
class BookkeepingStore extends _$BookkeepingStore {
  DateTime _month = _startOfMonth(DateTime.now());
  BookkeepingFilter _filter = BookkeepingFilter.all;

  @override
  BookkeepingState build() {
    final transactions = ref.watch(transactionsStoreProvider);

    // Defer ke microtask: `ensureAllLoaded()` mengubah state provider lain,
    // sementara `build()` masih berjalan (riverpod 3). Aman dipanggil tiap
    // build — `ensureAllLoaded()` no-op ketika daftar sudah dimuat penuh
    // (mis. setelah layar lain mengaktifkan lagi mode pagination).
    Future.microtask(() {
      if (!ref.mounted) return;
      ref.read(transactionsStoreProvider.notifier).ensureAllLoaded();
    });

    return _derive(transactions.items, loading: transactions.loading);
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

  /// Hitung ulang data turunan dari state transaksi terkini (tanpa menunggu
  /// `build()` dijalankan ulang).
  void _refresh() {
    if (!ref.mounted) return;
    final transactions = ref.read(transactionsStoreProvider);
    state = _derive(transactions.items, loading: transactions.loading);
  }

  BookkeepingState _derive(List<Transaction> all, {required bool loading}) {
    final items = _monthItems(all);
    final counts = _computeCounts(all);
    var income = 0.0;
    var expense = 0.0;
    for (final tx in items) {
      final amount = tx.amountValue;
      if (tx.type == 'income') income += amount;
      if (tx.type == 'expense') expense += amount;
    }

    final balances = <String, double>{};
    var running = 0.0;
    for (final tx in items.reversed) {
      running += switch (tx.type) {
        'income' => tx.amountValue,
        'expense' => -tx.amountValue,
        _ => 0.0,
      };
      balances[tx.id] = running;
    }

    final groups = <String, List<Transaction>>{};
    for (final tx in items) {
      (groups[DateFormat('yyyy-MM-dd').format(tx.createdAt)] ??= []).add(tx);
    }

    final entries = <LedgerEntry>[];
    groups.forEach((_, list) {
      entries
        ..add(LedgerDayHeader(date: list.first.createdAt, count: list.length))
        ..addAll(list.map(LedgerTransactionRow.new));
    });

    return BookkeepingState(
      month: _month,
      filter: _filter,
      items: items,
      income: income,
      expense: expense,
      balances: balances,
      entries: entries,
      loading: loading,
      counts: counts,
    );
  }

  /// Hitung jumlah transaksi per filter untuk bulan [_month].
  Map<BookkeepingFilter, int> _computeCounts(List<Transaction> all) {
    final map = <BookkeepingFilter, int>{};
    for (final f in BookkeepingFilter.values) {
      if (f == BookkeepingFilter.failed) {
        map[f] = 0;
        continue;
      }
      final type = f.transactionType;
      int c = 0;
      for (final tx in all) {
        if (tx.createdAt.year != _month.year ||
            tx.createdAt.month != _month.month) {
          continue;
        }
        if (type == null || tx.type == type) c++;
      }
      map[f] = c;
    }
    return map;
  }

  /// Transaksi pada bulan terpilih, terbaru dulu, sesuai filter aktif.
  List<Transaction> _monthItems(List<Transaction> all) {
    final type = _filter.transactionType;
    final filtered = all.where((tx) {
      if (tx.createdAt.year != _month.year ||
          tx.createdAt.month != _month.month) {
        return false;
      }
      // Tab Failed memakai Payment dari backend (`paymentsByStatus`), jadi
      // tidak ada transaksi lokal yang cocok.
      if (_filter == BookkeepingFilter.failed) return false;
      return type == null || tx.type == type;
    }).toList();
    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return filtered;
  }

  static DateTime _startOfMonth(DateTime date) =>
      DateTime(date.year, date.month);
}
