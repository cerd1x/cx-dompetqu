import 'package:dompetqu/features/settings/domain/repositories/settings_repository.dart';
import 'package:dompetqu/features/settings/data/datasources/settings_local_datasource.dart';

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
  Future<bool> loadShowFps() async =>
      // Default ON: key belum pernah ditulis (null) dianggap tampil,
      // sesuai permintaan indikator FPS tampil terus-menerus.
      (await _local.readString(kShowFpsPrefsKey)) != 'off';

  @override
  Future<void> saveDarkMode(bool value) =>
      _local.writeString(kThemePrefsKey, value ? 'dark' : 'light');

  @override
  Future<void> saveCurrency(String code) =>
      _local.writeString(kCurrencyPrefsKey, code);

  @override
  Future<void> saveShowFps(bool value) =>
      _local.writeString(kShowFpsPrefsKey, value ? 'on' : 'off');
}
