import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/datasources/ai_settings_local_datasource.dart';
import '../data/repositories/ai_settings_repository_impl.dart';
import '../domain/repositories/ai_settings_repository.dart';

final aiSettingsRepositoryProvider = Provider<AiSettingsRepository>((ref) {
  return AiSettingsRepositoryImpl(SharedPreferencesAiSettingsDataSource());
});
