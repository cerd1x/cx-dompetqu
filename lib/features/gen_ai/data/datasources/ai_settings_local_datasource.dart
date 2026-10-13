import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/ai_settings.dart' show AiModelProvider;

abstract interface class AiSettingsLocalDataSource {
  Future<AiModelProvider> loadProvider();
  Future<AiProviderSettingsData> loadProviderSettings(AiModelProvider provider);
  Future<void> saveProvider(AiModelProvider provider);
  Future<void> saveApiKey(AiModelProvider provider, String value);
  Future<void> saveModel(AiModelProvider provider, String value);
  Future<void> saveBaseUrl(AiModelProvider provider, String value);
}

class AiProviderSettingsData {
  const AiProviderSettingsData({
    required this.apiKey,
    required this.model,
    required this.baseUrl,
  });

  final String apiKey;
  final String model;
  final String baseUrl;
}

class SharedPreferencesAiSettingsDataSource
    implements AiSettingsLocalDataSource {
  @override
  Future<AiProviderSettingsData> loadProviderSettings(
    AiModelProvider provider,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    return AiProviderSettingsData(
      apiKey:
          prefs.getString(_apiKeyKey(provider)) ??
          (provider == AiModelProvider.googleAi
              ? prefs.getString('ai_api_key')
              : null) ??
          '',
      model:
          prefs.getString(_modelKey(provider)) ??
          (provider == AiModelProvider.googleAi
              ? prefs.getString('ai_model')
              : null) ??
          provider.defaultModel,
      baseUrl:
          prefs.getString(_baseUrlKey(provider)) ??
          'http://localhost:11434/v1',
    );
  }

  @override
  Future<void> saveProvider(AiModelProvider provider) async {
    await (await SharedPreferences.getInstance()).setString(
      'ai_model_provider',
      provider.name,
    );
  }

  @override
  Future<void> saveApiKey(AiModelProvider provider, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiKeyKey(provider), value);
    if (provider == AiModelProvider.googleAi) {
      await prefs.setString('ai_api_key', value);
    }
  }

  @override
  Future<void> saveModel(AiModelProvider provider, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_modelKey(provider), value);
    if (provider == AiModelProvider.googleAi) {
      await prefs.setString('ai_model', value);
    }
  }

  @override
  Future<void> saveBaseUrl(AiModelProvider provider, String value) async {
    await (await SharedPreferences.getInstance()).setString(
      _baseUrlKey(provider),
      value,
    );
  }

  static String _apiKeyKey(AiModelProvider provider) =>
      'ai_${provider.storageKey}_api_key';
  static String _modelKey(AiModelProvider provider) =>
      'ai_${provider.storageKey}_model';
  static String _baseUrlKey(AiModelProvider provider) =>
      'ai_${provider.storageKey}_base_url';

  @override
  Future<AiModelProvider> loadProvider() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('ai_model_provider');
    if (name == null) return AiModelProvider.googleAi;
    for (final provider in AiModelProvider.values) {
      if (provider.name == name) return provider;
    }
    throw FormatException('Provider AI tersimpan tidak dikenal: $name');
  }
}
