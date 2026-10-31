import 'package:dompetqu/features/gen_ai/domain/entities/openrouter_model.dart';
import 'package:dompetqu/features/gen_ai/domain/repositories/openrouter_model_repository.dart';
import 'package:dompetqu/features/gen_ai/adapters/datasources/openrouter_model_remote_datasource.dart';

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
