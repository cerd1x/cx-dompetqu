import '../entities/ai_settings.dart';

abstract interface class AiSettingsRepository {
  Future<AiSettings> load();
  Future<void> saveProvider(AiModelProvider provider);
  Future<void> saveApiKey(AiModelProvider provider, String value);
  Future<void> saveModel(AiModelProvider provider, String value);
  Future<void> saveBaseUrl(AiModelProvider provider, String value);
  Future<void> saveAiBubbleVisibility(bool visible);
}
