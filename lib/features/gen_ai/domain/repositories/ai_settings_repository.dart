import '../entities/ai_settings.dart';

abstract interface class AiSettingsRepository {
  Future<AiSettings> load();
  Future<void> saveApiKey(String value);
  Future<void> saveModel(String value);
}
