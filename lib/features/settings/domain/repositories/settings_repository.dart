abstract interface class SettingsRepository {
  Future<bool> loadDarkMode();
  Future<String> loadCurrency();
  Future<bool> loadShowFps();
  Future<void> saveDarkMode(bool value);
  Future<void> saveCurrency(String code);
  Future<void> saveShowFps(bool value);
}
