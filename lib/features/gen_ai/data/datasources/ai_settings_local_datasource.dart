import 'package:shared_preferences/shared_preferences.dart';

import '../../models/ai_settings.dart';

abstract interface class AiSettingsLocalDataSource {
  Future<AiSettings> load();
  Future<void> saveApiKey(String value);
  Future<void> saveModel(String value);
}

class SharedPreferencesAiSettingsDataSource
    implements AiSettingsLocalDataSource {
  @override
  Future<AiSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    return AiSettings(
      apiKey: prefs.getString(kAiApiKeyPrefsKey) ?? '',
      model: prefs.getString(kAiModelPrefsKey) ?? kDefaultAiModel,
    );
  }

  @override
  Future<void> saveApiKey(String value) async {
    await (await SharedPreferences.getInstance()).setString(
      kAiApiKeyPrefsKey,
      value,
    );
  }

  @override
  Future<void> saveModel(String value) async {
    await (await SharedPreferences.getInstance()).setString(
      kAiModelPrefsKey,
      value,
    );
  }
}
