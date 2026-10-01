import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Kunci `SharedPreferences` untuk daftar id transaksi utang yang sudah lunas.
const String kSettledDebtsPrefsKey = 'settled_debt_ids';

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
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(kSettledDebtsPrefsKey) ?? const [];
    if (!ref.mounted) return;
    _loaded = true;
    state = stored.toSet();
  }

  /// Status [transactionId]: lunas bila id-nya ada di [state].
  DebtStatus statusOf(String transactionId) =>
      state.contains(transactionId) ? DebtStatus.settled : DebtStatus.outstanding;

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
    final prefs = await SharedPreferences.getInstance();
    final ids = state.toList()..sort();
    await prefs.setStringList(kSettledDebtsPrefsKey, ids);
  }

  /// Sudah selesai membaca `SharedPreferences` (menunggu write pertama selesai).
  bool get isReady => _loaded;
}

/// Penyimpanan lokal status pelunasan utang — dipakai tab Debt.
final debtSettlementsProvider =
    NotifierProvider<DebtSettlements, Set<String>>(DebtSettlements.new);