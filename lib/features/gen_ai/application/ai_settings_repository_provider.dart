import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/datasources/ai_settings_crypto_service.dart';
import '../data/datasources/ai_settings_local_datasource.dart';
import '../data/datasources/openrouter_model_remote_datasource.dart';
import '../data/repositories/ai_settings_repository_impl.dart';
import '../data/repositories/openrouter_model_repository_impl.dart';
import '../domain/repositories/ai_settings_repository.dart';
import '../domain/repositories/openrouter_model_repository.dart';

part 'ai_settings_repository_provider.g.dart';

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
