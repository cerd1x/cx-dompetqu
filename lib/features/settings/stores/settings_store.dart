import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/entities/app_settings.dart';
import 'settings_repository_provider.dart';
part 'generated/settings_store.g.dart';

/// Pengaturan lokal (dark mode dan mata uang) yang dipersist ke
/// `SharedPreferences`. Default dark mode `true` — app saat ini dark-first.
@Riverpod(keepAlive: true)
class SettingsStore extends _$SettingsStore {
  @override
  Future<AppSettings> build() async => AppSettings(
    darkMode: await ref.watch(settingsRepositoryProvider).loadDarkMode(),
    currency: await ref.watch(settingsRepositoryProvider).loadCurrency(),
  );

  Future<void> setDarkMode(bool value) async {
    state = AsyncValue.data(
      state.value?.copyWith(darkMode: value) ?? AppSettings(darkMode: value),
    );
    await ref.read(settingsRepositoryProvider).saveDarkMode(value);
  }

  Future<void> setCurrency(String code) async {
    state = AsyncValue.data(
      state.value?.copyWith(currency: code) ?? AppSettings(currency: code),
    );
    await ref.read(settingsRepositoryProvider).saveCurrency(code);
  }
}
