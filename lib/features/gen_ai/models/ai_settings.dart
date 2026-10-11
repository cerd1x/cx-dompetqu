const String kAiApiKeyPrefsKey = 'ai_api_key';
const String kAiModelPrefsKey = 'ai_model';
const String kDefaultAiModel = 'gemini-2.5-flash';

class AiSettings {
  const AiSettings({
    this.apiKey = '',
    this.model = kDefaultAiModel,
  });

  final String apiKey;
  final String model;

  AiSettings copyWith({
    String? apiKey,
    String? model,
  }) => AiSettings(
    apiKey: apiKey ?? this.apiKey,
    model: model ?? this.model,
  );
}
