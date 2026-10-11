import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_controller.g.dart';

const String kThemePrefsKey = 'theme';
const String kCurrencyPrefsKey = 'currency';

/// Preferensi lokal aplikasi — padanan `SettingStore` di web
/// (`setting_store.svelte.ts`: darkMode + selectedCurrency).
class AppSettings {
  const AppSettings({
    this.darkMode = true,
    this.currency = 'IDR',
  });

  final bool darkMode;
  final String currency;

  AppSettings copyWith({
    bool? darkMode,
    String? currency,
  }) => AppSettings(
    darkMode: darkMode ?? this.darkMode,
    currency: currency ?? this.currency,
  );
}

/// Pengaturan lokal (dark mode dan mata uang) yang dipersist ke
/// `SharedPreferences`. Default dark mode `true` — app saat ini dark-first.
@Riverpod(keepAlive: true)
class SettingsController extends _$SettingsController {
  @override
  Future<AppSettings> build() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString(kThemePrefsKey);
    final currency = prefs.getString(kCurrencyPrefsKey);
    return AppSettings(
      darkMode: theme == null || theme == 'dark',
      currency: currency ?? 'IDR',
    );
  }

  Future<void> setDarkMode(bool value) async {
    state = AsyncValue.data(
      state.value?.copyWith(darkMode: value) ?? AppSettings(darkMode: value),
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kThemePrefsKey, value ? 'dark' : 'light');
  }

  Future<void> setCurrency(String code) async {
    state = AsyncValue.data(
      state.value?.copyWith(currency: code) ?? AppSettings(currency: code),
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kCurrencyPrefsKey, code);
  }
}
