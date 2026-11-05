import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:dompetqu/core/logger/app_logger.dart';
import 'package:dompetqu/features/dashboard/view/stores/home_repository_provider.dart';
import 'package:dompetqu/features/payments/domain/models/payment.dart';
import 'package:dompetqu/features/payments/view/stores/payments_repository_provider.dart';
import 'package:dompetqu/features/transactions/domain/models/transaction.dart';

part 'generated/finance_overview_store.freezed.dart';
part 'generated/finance_overview_store.g.dart';

/// State gabungan data keuangan: payment + transaction.
@freezed
abstract class FinanceOverviewState with _$FinanceOverviewState {
  const factory FinanceOverviewState({
    @Default([]) List<Transaction> transactions,
    @Default([]) List<Payment> payments,
    @Default(true) bool loading,
    String? error,
  }) = _FinanceOverviewState;
}

/// Store gabungan yang memuat data payment dan transaction secara paralel.
///
/// Pemrosesan daftar besar (normalisasi & dedupe) dijalankan di isolate
/// terpisah via [compute] agar UI isolate tidak diblokir saat payload
/// transaksi banyak.
@Riverpod(keepAlive: true)
class FinanceOverviewStore extends _$FinanceOverviewStore {
  @override
  FinanceOverviewState build() {
    Future.microtask(load);
    return const FinanceOverviewState();
  }

  Future<void>? _inFlight;

  /// Muat payment dan transaction secara paralel, lalu gabungkan ke state.
  Future<void> load() async {
    final pending = _inFlight;
    if (pending != null) return pending;
    state = state.copyWith(loading: true, error: null);
    final future = _fetch();
    _inFlight = future;
    future.whenComplete(() {
      if (_inFlight == future) _inFlight = null;
    });
    return future;
  }

  Future<void> _fetch() async {
    try {
      final results = await Future.wait([
        ref.read(homeRepositoryProvider).transactions(),
        ref.read(paymentsRepositoryProvider).byStatus('failed'),
      ]);

      if (!ref.mounted) return;

      final rawTransactions = results[0] as List<Transaction>;
      final payments = results[1] as List<Payment>;

      // Normalisasi & dedupe transaksi di isolate terpisah — payload besar
      // tidak memblokir UI isolate.
      final normalized = await compute(
        _normalizeTransactions,
        rawTransactions.map((t) => _transactionToMap(t)).toList(),
      );

      state = state.copyWith(
        transactions: normalized
            .map((e) => _transactionFromMap(e))
            .toList(growable: false),
        payments: payments,
        loading: false,
      );

      AppLogger.instance.success(
        'finance overview dimuat (transaksi ${rawTransactions.length}, '
        'payment ${payments.length})',
        tag: 'FinanceOverviewStore',
      );
    } catch (e) {
      if (!ref.mounted) return;
      AppLogger.instance.error(
        'Gagal load finance overview',
        tag: 'FinanceOverviewStore',
        error: e,
      );
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}

/// Konversi domain [Transaction] ke [Map<String, dynamic>] untuk dikirim ke
/// isolate (compute tidak boleh melewati objek Dart yang tidak bisa di-serialize
/// crossing isolate boundary, termasuk objek Freezed).
Map<String, dynamic> _transactionToMap(Transaction t) => {
  'id': t.id,
  'type': t.type,
  'amount': t.amount,
  'capital': t.capital,
  'description': t.description,
  'category': t.category,
  'paymentMethod': t.paymentMethod?.type,
  'customerId': t.customerId,
  'status': t.status,
  'paymentStatus': t.paymentStatus,
  'createdAt': t.createdAt.toIso8601String(),
};

/// Konversi [Map<String, dynamic>] kembali menjadi domain [Transaction]
/// (dipanggil di UI isolate setelah compute selesai).
Transaction _transactionFromMap(Map<String, dynamic> m) => Transaction(
  id: m['id'] as String,
  type: (m['type'] as String?) ?? 'income',
  amount: (m['amount'] as String?) ?? 'IDR 0',
  capital: m['capital'] as String?,
  description: m['description'] as String?,
  category: m['category'] as String?,
  paymentMethod: (m['paymentMethod'] as String?) != null
      ? PaymentMethod(type: m['paymentMethod'] as String)
      : null,
  customerId: m['customerId'] as String?,
  status: (m['status'] as String?) ?? 'success',
  paymentStatus: (m['paymentStatus'] as String?) ?? 'unpaid',
  createdAt:
      DateTime.tryParse(m['createdAt'] as String? ?? '') ?? DateTime.now(),
);

/// Normalisasi daftar transaksi di isolate — buang duplikat berdasarkan id
/// dan urutkan terbaru dulu. [items] berupa `List<Map<String, dynamic>>`.
List<Map<String, dynamic>> _normalizeTransactions(
  List<Map<String, dynamic>> items,
) {
  final seen = <String>{};
  final result = <Map<String, dynamic>>[];
  for (final item in items) {
    final id = item['id'] as String?;
    if (id == null || seen.contains(id)) continue;
    seen.add(id);
    result.add(item);
  }
  result.sort((a, b) {
    final da = DateTime.tryParse(a['createdAt'] as String? ?? '');
    final db = DateTime.tryParse(b['createdAt'] as String? ?? '');
    if (da == null && db == null) return 0;
    if (da == null) return 1;
    if (db == null) return -1;
    return db.compareTo(da);
  });
  return result;
}
