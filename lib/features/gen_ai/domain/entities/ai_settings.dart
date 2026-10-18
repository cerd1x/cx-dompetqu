import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../config/openrouter_config.dart';

part 'ai_settings.freezed.dart';

const String kDefaultAiModel = 'gemini-2.5-flash';

enum AiModelProvider {
  googleAi,
  anthropic,
  openAi,
  ollama,
  // Provider eksplisit; sebelumnya OpenRouter hanya terdeteksi lewat base URL.
  openRouter;

  String get label => switch (this) {
    AiModelProvider.googleAi => 'Google AI',
    AiModelProvider.anthropic => 'Anthropic',
    AiModelProvider.openAi => 'OpenAI',
    AiModelProvider.ollama => 'Ollama',
    AiModelProvider.openRouter => OpenRouterConfig.label,
  };

  String get defaultModel => switch (this) {
    AiModelProvider.googleAi => kDefaultAiModel,
    AiModelProvider.anthropic => 'claude-sonnet-4-5',
    AiModelProvider.openAi => 'gpt-5-mini',
    AiModelProvider.ollama => 'llama3.2',
    AiModelProvider.openRouter => OpenRouterConfig.defaultModel,
  };

  String get storageKey => switch (this) {
    AiModelProvider.googleAi => 'google_ai',
    AiModelProvider.anthropic => 'anthropic',
    AiModelProvider.openAi => 'open_ai',
    AiModelProvider.ollama => 'ollama',
    AiModelProvider.openRouter => OpenRouterConfig.storageKey,
  };

  String get defaultBaseUrl => switch (this) {
    AiModelProvider.googleAi => 'https://generativelanguage.googleapis.com',
    AiModelProvider.anthropic => 'https://api.anthropic.com',
    AiModelProvider.openAi => 'https://api.openai.com/v1',
    AiModelProvider.ollama => 'http://localhost:11434/v1',
    AiModelProvider.openRouter => OpenRouterConfig.baseUrl,
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

/// Mengubah pengaturan ke rangkaian properti berurutan yang dipisahkan `|`.
extension AiSettingsSerialization on AiSettings {
  /// Menghasilkan plaintext untuk dienkripsi oleh lapisan data sebelum dipakai.
  String toPipeDelimitedString() {
    final sortedHeaders = Map.fromEntries(
      customHeaders.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
    final values = [
      provider.name,
      apiKey,
      model,
      baseUrl,
      showAiBubble.toString(),
      includeCustomHeaders.toString(),
      jsonEncode(sortedHeaders),
      useCustomModel.toString(),
    ];

    return values.join('|');
  }
}
