import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_controller.g.dart';

const String kThemePrefsKey = 'theme';
const String kCurrencyPrefsKey = 'currency';
const String kAiApiKeyPrefsKey = 'ai_api_key';
const String kAiModelPrefsKey = 'ai_model';

const String kDefaultAiModel = 'gemini-2.5-flash';

/// Preferensi lokal aplikasi — padanan `SettingStore` di web
/// (`setting_store.svelte.ts`: darkMode + selectedCurrency).
class AppSettings {
  const AppSettings({
    this.darkMode = true,
    this.currency = 'IDR',
    this.aiApiKey = '',
    this.aiModel = kDefaultAiModel,
  });

  final bool darkMode;
  final String currency;
  final String aiApiKey;
  final String aiModel;

  AppSettings copyWith({
    bool? darkMode,
    String? currency,
    String? aiApiKey,
    String? aiModel,
  }) => AppSettings(
    darkMode: darkMode ?? this.darkMode,
    currency: currency ?? this.currency,
    aiApiKey: aiApiKey ?? this.aiApiKey,
    aiModel: aiModel ?? this.aiModel,
  );
}

/// Pengaturan lokal (dark mode, mata uang, AI) yang dipersist ke
/// `SharedPreferences`. Default dark mode `true` — app saat ini dark-first.
@Riverpod(keepAlive: true)
class SettingsController extends _$SettingsController {
  @override
  Future<AppSettings> build() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString(kThemePrefsKey);
    final currency = prefs.getString(kCurrencyPrefsKey);
    final aiApiKey = prefs.getString(kAiApiKeyPrefsKey) ?? '';
    final aiModel = prefs.getString(kAiModelPrefsKey) ?? kDefaultAiModel;
    return AppSettings(
      darkMode: theme == null || theme == 'dark',
      currency: currency ?? 'IDR',
      aiApiKey: aiApiKey,
      aiModel: aiModel,
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

  Future<void> setAiApiKey(String value) async {
    state = AsyncValue.data(
      state.value?.copyWith(aiApiKey: value) ?? AppSettings(aiApiKey: value),
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kAiApiKeyPrefsKey, value);
  }

  Future<void> setAiModel(String value) async {
    state = AsyncValue.data(
      state.value?.copyWith(aiModel: value) ?? AppSettings(aiModel: value),
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kAiModelPrefsKey, value);
  }
}
