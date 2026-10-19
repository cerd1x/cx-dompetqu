import 'package:freezed_annotation/freezed_annotation.dart';

import 'ai_settings.dart';

part 'generated/ai_settings_profile.freezed.dart';

/// Satu profil pengaturan AI (named profile dari `AiSettings`).
@freezed
abstract class AiSettingsProfile with _$AiSettingsProfile {
  const factory AiSettingsProfile({
    required String id,
    required String name,
    required AiModelProvider provider,
    required String apiKey,
    required String model,
    required String baseUrl,
    required bool includeCustomHeaders,
    required Map<String, String> customHeaders,
    required bool useCustomModel,
  }) = _AiSettingsProfile;

  const AiSettingsProfile._();

  factory AiSettingsProfile.fromSettings({
    required String id,
    required String name,
    required AiSettings settings,
  }) {
    return AiSettingsProfile(
      id: id,
      name: name,
      provider: settings.provider,
      apiKey: settings.apiKey,
      model: settings.model,
      baseUrl: settings.baseUrl,
      includeCustomHeaders: settings.includeCustomHeaders,
      customHeaders: settings.customHeaders,
      useCustomModel: settings.useCustomModel,
    );
  }

  AiSettings toSettings({required bool showAiBubble}) => AiSettings(
    provider: provider,
    apiKey: apiKey,
    model: model,
    baseUrl: baseUrl,
    showAiBubble: showAiBubble,
    includeCustomHeaders: includeCustomHeaders,
    customHeaders: customHeaders,
    useCustomModel: useCustomModel,
  );

  AiSettingsProfile withSettings(AiSettings settings) =>
      AiSettingsProfile.fromSettings(id: id, name: name, settings: settings);
}
