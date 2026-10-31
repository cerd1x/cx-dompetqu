import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dompetqu/features/order/stores/debt_settlements_repository_provider.dart';

/// Status pelunasan satu utang — dipakai untuk menandai lunas/tunggakan.
enum DebtStatus { outstanding, settled }

/// Status pelunasan yang disimpan lokal — GraphQL tidak menyediakan flag "lunas"
/// pada transaksi (`UpdateTransactionInput` di `transaction.gql` tidak punya
/// `status`), jadi pelunasan dicatat di `SharedPreferences`, sementara pembayaran
///nya sendiri tetap ditulis ke ledger sebagai transaksi income.
class DebtSettlements extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    // Defer ke microtask: `SharedPreferences.getInstance()` async, sedangkan
    // `build()` harus sinkron (riverpod 3).
    Future.microtask(_load);
    return const {};
  }

  bool _loaded = false;

  Future<void> _load() async {
    final stored = await ref.read(debtSettlementsRepositoryProvider).load();
    if (!ref.mounted) return;
    _loaded = true;
    state = stored;
  }

  /// Status [transactionId]: lunas bila id-nya ada di [state].
  DebtStatus statusOf(String transactionId) => state.contains(transactionId)
      ? DebtStatus.settled
      : DebtStatus.outstanding;

  bool isSettled(String transactionId) => state.contains(transactionId);

  /// Tandai utang lunas (dipanggil setelah pembayaran berhasil dicatat).
  Future<void> markSettled(String transactionId) async {
    if (state.contains(transactionId)) return;
    state = {...state, transactionId};
    await _persist();
  }

  /// Batalkan status lunas (mis. salah tandai).
  Future<void> revert(String transactionId) async {
    if (!state.contains(transactionId)) return;
    state = {...state}..remove(transactionId);
    await _persist();
  }

  Future<void> _persist() async {
    await ref.read(debtSettlementsRepositoryProvider).save(state);
  }

  /// Sudah selesai membaca `SharedPreferences` (menunggu write pertama selesai).
  bool get isReady => _loaded;
}

/// Penyimpanan lokal status pelunasan utang — dipakai tab Debt.
final debtSettlementsProvider = NotifierProvider<DebtSettlements, Set<String>>(
  DebtSettlements.new,
);
