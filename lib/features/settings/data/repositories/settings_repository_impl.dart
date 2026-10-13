import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_datasource.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this._local);

  final SettingsLocalDataSource _local;

  @override
  Future<bool> loadDarkMode() async {
    final theme = await _local.readString(kThemePrefsKey);
    return theme == null || theme == 'dark';
  }

  @override
  Future<String> loadCurrency() async =>
      await _local.readString(kCurrencyPrefsKey) ?? 'IDR';

  @override
  Future<void> saveDarkMode(bool value) =>
      _local.writeString(kThemePrefsKey, value ? 'dark' : 'light');

  @override
  Future<void> saveCurrency(String code) =>
      _local.writeString(kCurrencyPrefsKey, code);
}
