import 'package:shared_preferences/shared_preferences.dart';

const String kThemePrefsKey = 'theme';
const String kCurrencyPrefsKey = 'currency';
const String kShowFpsPrefsKey = 'show_fps';

abstract interface class SettingsLocalDataSource {
  Future<String?> readString(String key);
  Future<void> writeString(String key, String value);
}

class SharedPreferencesSettingsDataSource implements SettingsLocalDataSource {
  const SharedPreferencesSettingsDataSource();

  @override
  Future<String?> readString(String key) async =>
      (await SharedPreferences.getInstance()).getString(key);

  @override
  Future<void> writeString(String key, String value) async {
    await (await SharedPreferences.getInstance()).setString(key, value);
  }
}
