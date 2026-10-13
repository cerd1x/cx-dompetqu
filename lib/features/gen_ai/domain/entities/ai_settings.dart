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
}

class AiSettings {
  const AiSettings({
    this.provider = AiModelProvider.googleAi,
    this.apiKey = '',
    this.model = kDefaultAiModel,
    this.baseUrl = 'http://localhost:11434/v1',
  });

  final AiModelProvider provider;
  final String apiKey;
  final String model;
  final String baseUrl;

  AiSettings copyWith({
    AiModelProvider? provider,
    String? apiKey,
    String? model,
    String? baseUrl,
  }) => AiSettings(
    provider: provider ?? this.provider,
    apiKey: apiKey ?? this.apiKey,
    model: model ?? this.model,
    baseUrl: baseUrl ?? this.baseUrl,
  );
}
