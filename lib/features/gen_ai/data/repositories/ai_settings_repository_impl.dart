import '../../domain/entities/ai_settings.dart' as domain;
import '../../domain/repositories/ai_settings_repository.dart';
import '../datasources/ai_settings_local_datasource.dart';

class AiSettingsRepositoryImpl implements AiSettingsRepository {
  const AiSettingsRepositoryImpl(this._local);

  final AiSettingsLocalDataSource _local;

  @override
  Future<domain.AiSettings> load() async {
    final provider = await _local.loadProvider();
    final settings = await _local.loadProviderSettings(provider);
    return domain.AiSettings(
      provider: provider,
      apiKey: settings.apiKey,
      model: settings.model,
      baseUrl: settings.baseUrl,
      showAiBubble: settings.showAiBubble,
    );
  }

  @override
  Future<void> saveProvider(domain.AiModelProvider provider) =>
      _local.saveProvider(provider);

  @override
  Future<void> saveApiKey(domain.AiModelProvider provider, String value) =>
      _local.saveApiKey(provider, value);

  @override
  Future<void> saveModel(domain.AiModelProvider provider, String value) =>
      _local.saveModel(provider, value);

  @override
  Future<void> saveBaseUrl(domain.AiModelProvider provider, String value) =>
      _local.saveBaseUrl(provider, value);

  @override
  Future<void> saveAiBubbleVisibility(bool visible) =>
      _local.saveAiBubbleVisibility(visible);
}
