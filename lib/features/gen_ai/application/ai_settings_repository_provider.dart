import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../data/datasources/openrouter_model_remote_datasource.dart';
import '../data/repositories/openrouter_model_repository_impl.dart';
import '../domain/repositories/openrouter_model_repository.dart';
import '../data/datasources/ai_settings_local_datasource.dart';
import '../data/repositories/ai_settings_repository_impl.dart';
import '../domain/repositories/ai_settings_repository.dart';

final aiSettingsRepositoryProvider = Provider<AiSettingsRepository>((ref) {
  return AiSettingsRepositoryImpl(SharedPreferencesAiSettingsDataSource());
});

final openRouterModelRepositoryProvider = Provider<OpenRouterModelRepository>((
  ref,
) {
  final client = http.Client();
  ref.onDispose(client.close);
  return OpenRouterModelRepositoryImpl(
    HttpOpenRouterModelRemoteDataSource(client),
  );
});
