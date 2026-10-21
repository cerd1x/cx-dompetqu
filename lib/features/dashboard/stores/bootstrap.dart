import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../assets/stores/assets_store.dart';
import '../../contacts/stores/contacts_store.dart';
import '../../inventory/stores/inventory_store.dart';
import '../../statistics/stores/statistics_store.dart';
import '../../transactions/stores/transactions_store.dart';

/// Warm-up semua data di background tanpa memblokir frame pertama.
///
/// Dipanggil dari `HomeShell` setelah frame pertama & saat user sign-in.
/// Setiap provider sudah auto-load di `build()`, pemanggilan ini bersifat
/// idempotent (guard loading di store).
void bootstrapDompetData(WidgetRef ref) {
  ref.read(contactsStoreProvider.notifier).load();
  ref.read(inventoryStoreProvider.notifier).load();
  ref.read(assetsStoreProvider.notifier).load();
  ref.read(transactionsStoreProvider.notifier).load();
  ref.read(statisticsStoreProvider.notifier).load();
}

/// Reset cache data saat sign-out, agar akun berikutnya memuat data baru.
///
/// `invalidate` membangun ulang Notifier → `build()` kembali auto-load.
void resetDompetData(WidgetRef ref) {
  ref.invalidate(contactsStoreProvider);
  ref.invalidate(inventoryStoreProvider);
  ref.invalidate(assetsStoreProvider);
  ref.invalidate(transactionsStoreProvider);
  ref.invalidate(statisticsStoreProvider);
}
