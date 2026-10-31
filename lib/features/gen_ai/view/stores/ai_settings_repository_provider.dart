import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:dompetqu/features/gen_ai/adapters/datasources/ai_settings_crypto_service.dart';
import 'package:dompetqu/features/gen_ai/adapters/datasources/ai_settings_local_datasource.dart';
import 'package:dompetqu/features/gen_ai/adapters/datasources/openrouter_model_remote_datasource.dart';
import 'package:dompetqu/features/gen_ai/adapters/repositories/ai_settings_repository_impl.dart';
import 'package:dompetqu/features/gen_ai/adapters/repositories/openrouter_model_repository_impl.dart';
import 'package:dompetqu/features/gen_ai/domain/repositories/ai_settings_repository.dart';
import 'package:dompetqu/features/gen_ai/domain/repositories/openrouter_model_repository.dart';

part 'generated/ai_settings_repository_provider.g.dart';

@Riverpod(keepAlive: true)
AiSettingsRepository aiSettingsRepository(Ref ref) {
  return AiSettingsRepositoryImpl(
    SharedPreferencesAiSettingsDataSource(),
    AiSettingsCryptoService(
      keyStore: const FlutterSecureStorageAiSettingsKeyStore(),
    ),
  );
}

@Riverpod(keepAlive: true)
OpenRouterModelRepository openRouterModelRepository(Ref ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return OpenRouterModelRepositoryImpl(
    HttpOpenRouterModelRemoteDataSource(client),
  );
}
