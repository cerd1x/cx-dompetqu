import 'package:cx_dompetqiu/features/gen_ai/domain/models/openrouter_model.dart';

abstract interface class OpenRouterModelRepository {
  Future<List<OpenRouterModel>> loadModels({
    required String baseUrl,
    required String apiKey,
    Map<String, String> headers = const {},
  });
}
