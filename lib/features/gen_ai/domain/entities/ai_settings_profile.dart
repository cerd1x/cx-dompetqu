import 'ai_settings.dart';

class AiSettingsProfile {
  const AiSettingsProfile({
    required this.id,
    required this.name,
    required this.provider,
    required this.apiKey,
    required this.model,
    required this.baseUrl,
    required this.includeCustomHeaders,
    required this.customHeaders,
    required this.useCustomModel,
  });

  final String id;
  final String name;
  final AiModelProvider provider;
  final String apiKey;
  final String model;
  final String baseUrl;
  final bool includeCustomHeaders;
  final Map<String, String> customHeaders;
  final bool useCustomModel;

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
