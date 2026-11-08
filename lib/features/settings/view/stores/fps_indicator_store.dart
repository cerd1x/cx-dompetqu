import 'package:dompetqu/core/logger/app_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'settings_repository_provider.dart';

/// Status tampil/sembunyi indikator FPS.
///
/// Dipersist ke `SharedPreferences` lewat [SettingsRepository] (key
/// `show_fps`), bukan lewat `AppSettings` freezed — supaya toggle ini bisa
/// ditambahkan tanpa codegen (`build_runner`) dan tidak memaksa regenerasi
/// `.freezed.dart`.
///
/// Default **ON** (`true`): key belum pernah ditulis (null) dianggap tampil,
/// sesuai keputusan agar indikator FPS tampil terus-menerus.
///
/// Ini provider Riverpod **manual** (bukan `@riverpod` codegen) karena
/// menambahkan codegen store baru berarti menjalankan `build_runner`, yang
/// di repo ini hanya dilakukan oleh user.
final fpsIndicatorStoreProvider =
    AsyncNotifierProvider<FpsIndicatorNotifier, bool>(FpsIndicatorNotifier.new);

class FpsIndicatorNotifier extends AsyncNotifier<bool> {
  final AppLogger _log = AppLogger.instance;

  @override
  Future<bool> build() async {
    try {
      final value = await ref.watch(settingsRepositoryProvider).loadShowFps();
      _log.success('FPS indicator dimuat: $value', tag: 'FpsIndicatorStore');
      return value;
    } catch (e) {
      _log.error(
        'Gagal memuat FPS indicator',
        tag: 'FpsIndicatorStore',
        error: e,
      );
      rethrow;
    }
  }

  /// Toggle tampil/sembunyi indikator FPS dan persist ke prefs.
  Future<void> setVisible(bool value) async {
    // Optimistic update supaya UI langsung merespons; penyimpanan menyusul.
    state = AsyncValue.data(value);
    try {
      await ref.read(settingsRepositoryProvider).saveShowFps(value);
      _log.success('FPS indicator disimpan: $value', tag: 'FpsIndicatorStore');
    } catch (e) {
      _log.error(
        'Gagal simpan FPS indicator',
        tag: 'FpsIndicatorStore',
        error: e,
      );
      rethrow;
    }
  }
}
