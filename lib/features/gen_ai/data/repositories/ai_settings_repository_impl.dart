import '../../domain/entities/ai_settings.dart' as domain;
import '../../domain/repositories/ai_settings_repository.dart';
import '../datasources/ai_settings_local_datasource.dart';

class AiSettingsRepositoryImpl implements AiSettingsRepository {
  const AiSettingsRepositoryImpl(this._local);

  final AiSettingsLocalDataSource _local;

  @override
  Future<domain.AiSettings> load() async {
    final model = await _local.load();
    return domain.AiSettings(apiKey: model.apiKey, model: model.model);
  }

  @override
  Future<void> saveApiKey(String value) => _local.saveApiKey(value);

  @override
  Future<void> saveModel(String value) => _local.saveModel(value);
}
