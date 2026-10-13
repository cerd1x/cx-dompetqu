abstract interface class SettingsRepository {
  Future<bool> loadDarkMode();
  Future<String> loadCurrency();
  Future<void> saveDarkMode(bool value);
  Future<void> saveCurrency(String code);
}
