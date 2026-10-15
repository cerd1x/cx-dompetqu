import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_settings.freezed.dart';

const String kDefaultAiModel = 'gemini-2.5-flash';

enum AiModelProvider {
  googleAi,
  anthropic,
  openAi,
  ollama;

  String get label => switch (this) {
    AiModelProvider.googleAi => 'Google AI',
    AiModelProvider.anthropic => 'Anthropic',
    AiModelProvider.openAi => 'OpenAI',
    AiModelProvider.ollama => 'Ollama',
  };

  String get defaultModel => switch (this) {
    AiModelProvider.googleAi => kDefaultAiModel,
    AiModelProvider.anthropic => 'claude-sonnet-4-5',
    AiModelProvider.openAi => 'gpt-5-mini',
    AiModelProvider.ollama => 'llama3.2',
  };

  String get storageKey => switch (this) {
    AiModelProvider.googleAi => 'google_ai',
    AiModelProvider.anthropic => 'anthropic',
    AiModelProvider.openAi => 'open_ai',
    AiModelProvider.ollama => 'ollama',
  };

  String get defaultBaseUrl => switch (this) {
    AiModelProvider.googleAi => 'https://generativelanguage.googleapis.com',
    AiModelProvider.anthropic => 'https://api.anthropic.com',
    AiModelProvider.openAi => 'https://api.openai.com/v1',
    AiModelProvider.ollama => 'http://localhost:11434/v1',
  };
}

@freezed
sealed class AiSettings with _$AiSettings {
  const factory AiSettings({
    @Default(AiModelProvider.googleAi) AiModelProvider provider,
    @Default('') String apiKey,
    @Default(kDefaultAiModel) String model,
    @Default('https://generativelanguage.googleapis.com') String baseUrl,
    @Default(true) bool showAiBubble,
    @Default(false) bool includeCustomHeaders,
    @Default(<String, String>{}) Map<String, String> customHeaders,
    @Default(false) bool useCustomModel,
  }) = _AiSettings;
}
