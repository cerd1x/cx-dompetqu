import 'package:dompetqu/features/gen_ai/domain/entities/openrouter_model.dart';

abstract interface class OpenRouterModelRepository {
  Future<List<OpenRouterModel>> loadModels({
    required String baseUrl,
    required String apiKey,
    Map<String, String> headers = const {},
  });
}
