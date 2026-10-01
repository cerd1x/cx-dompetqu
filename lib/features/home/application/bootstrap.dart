import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'assets_controller.dart';
import 'contacts_controller.dart';
import 'inventory_controller.dart';
import 'statistics_controller.dart';
import 'transactions_controller.dart';

/// Warm-up semua data di background tanpa memblokir frame pertama.
///
/// Dipanggil dari `HomeShell` setelah frame pertama & saat user sign-in.
/// Setiap provider sudah auto-load di `build()`, pemanggilan ini bersifat
/// idempotent (guard loading di controller).
void bootstrapDompetData(WidgetRef ref) {
  ref.read(contactsControllerProvider.notifier).load();
  ref.read(inventoryControllerProvider.notifier).load();
  ref.read(assetsControllerProvider.notifier).load();
  ref.read(transactionsControllerProvider.notifier).load();
  ref.read(statisticsControllerProvider.notifier).load();
}

/// Reset cache data saat sign-out, agar akun berikutnya memuat data baru.
///
/// `invalidate` membangun ulang Notifier → `build()` kembali auto-load.
void resetDompetData(WidgetRef ref) {
  ref.invalidate(contactsControllerProvider);
  ref.invalidate(inventoryControllerProvider);
  ref.invalidate(assetsControllerProvider);
  ref.invalidate(transactionsControllerProvider);
  ref.invalidate(statisticsControllerProvider);
}
