import '../../domain/entities/openrouter_model.dart';
import '../../domain/repositories/openrouter_model_repository.dart';
import '../datasources/openrouter_model_remote_datasource.dart';

class OpenRouterModelRepositoryImpl implements OpenRouterModelRepository {
  const OpenRouterModelRepositoryImpl(this._remoteDataSource);

  final OpenRouterModelRemoteDataSource _remoteDataSource;

  @override
  Future<List<OpenRouterModel>> loadModels({
    required String baseUrl,
    required String apiKey,
    Map<String, String> headers = const {},
  }) {
    return _remoteDataSource.loadModels(
      baseUrl: baseUrl,
      apiKey: apiKey,
      headers: headers,
    );
  }
}
