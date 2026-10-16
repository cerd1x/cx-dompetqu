import '../entities/ai_settings.dart';
import '../entities/ai_settings_profile_collection.dart';

abstract interface class AiSettingsRepository {
  Future<AiSettings> load();
  Future<String> encryptSettings(AiSettings settings);
  Future<AiSettings> changeProvider(AiModelProvider provider);
  Future<AiSettingsProfileCollection> loadProfiles();
  Future<AiSettingsProfileCollection> createProfile(
    String name,
    AiSettings settings,
  );
  Future<AiSettingsProfileCollection> activateProfile(String profileId);
  Future<AiSettingsProfileCollection> deleteProfile(String profileId);
  Future<void> syncActiveProfile(AiSettings settings);
  Future<void> saveApiKey(AiModelProvider provider, String value);
  Future<void> saveModel(AiModelProvider provider, String value);
  Future<void> saveBaseUrl(AiModelProvider provider, String value);
  Future<void> saveCustomHeaders(
    AiModelProvider provider,
    Map<String, String> headers,
  );
  Future<void> saveIncludeCustomHeaders(AiModelProvider provider, bool include);
  Future<void> saveUseCustomModel(AiModelProvider provider, bool useCustom);
  Future<void> saveAiBubbleVisibility(bool visible);
}
