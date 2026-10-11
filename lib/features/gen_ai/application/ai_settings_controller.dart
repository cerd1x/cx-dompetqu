import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/ai_settings.dart';

part 'ai_settings_controller.g.dart';

@Riverpod(keepAlive: true)
class AiSettingsController extends _$AiSettingsController {
  @override
  Future<AiSettings> build() async {
    final prefs = await SharedPreferences.getInstance();
    return AiSettings(
      apiKey: prefs.getString(kAiApiKeyPrefsKey) ?? '',
      model: prefs.getString(kAiModelPrefsKey) ?? kDefaultAiModel,
    );
  }

  Future<void> setApiKey(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kAiApiKeyPrefsKey, value);
    if (!ref.mounted) return;
    final current = state.value ?? const AiSettings();
    state = AsyncValue.data(current.copyWith(apiKey: value));
  }

  Future<void> setModel(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kAiModelPrefsKey, value);
    if (!ref.mounted) return;
    final current = state.value ?? const AiSettings();
    state = AsyncValue.data(current.copyWith(model: value));
  }

}
