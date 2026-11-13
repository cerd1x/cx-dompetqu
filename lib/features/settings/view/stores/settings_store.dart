import 'package:cx_dompetqiu/core/logger/app_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:cx_dompetqiu/features/settings/domain/models/app_settings.dart';
import 'settings_repository_provider.dart';
part 'generated/settings_store.g.dart';

/// Pengaturan lokal (dark mode dan mata uang) yang dipersist ke
/// `SharedPreferences`. Default dark mode `true` — app saat ini dark-first.
@Riverpod(keepAlive: true)
class SettingsStore extends _$SettingsStore {
  final AppLogger _log = AppLogger.instance;

  @override
  Future<AppSettings> build() async {
    try {
      final settings = AppSettings(
        darkMode: await ref.watch(settingsRepositoryProvider).loadDarkMode(),
        currency: await ref.watch(settingsRepositoryProvider).loadCurrency(),
      );
      _log.success('Pengaturan dimuat', tag: 'SettingsStore');
      return settings;
    } catch (e) {
      _log.error('Gagal memuat pengaturan', tag: 'SettingsStore', error: e);
      rethrow;
    }
  }

  Future<void> setDarkMode(bool value) async {
    state = AsyncValue.data(
      state.value?.copyWith(darkMode: value) ?? AppSettings(darkMode: value),
    );
    try {
      await ref.read(settingsRepositoryProvider).saveDarkMode(value);
      _log.success('Dark mode disimpan: $value', tag: 'SettingsStore');
    } catch (e) {
      _log.error('Gagal simpan dark mode', tag: 'SettingsStore', error: e);
      rethrow;
    }
  }

  Future<void> setCurrency(String code) async {
    state = AsyncValue.data(
      state.value?.copyWith(currency: code) ?? AppSettings(currency: code),
    );
    try {
      await ref.read(settingsRepositoryProvider).saveCurrency(code);
      _log.success('Mata uang disimpan: $code', tag: 'SettingsStore');
    } catch (e) {
      _log.error('Gagal simpan mata uang', tag: 'SettingsStore', error: e);
      rethrow;
    }
  }
}
