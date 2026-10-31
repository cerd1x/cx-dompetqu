import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dompetqu/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:dompetqu/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:dompetqu/features/settings/domain/repositories/settings_repository.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepositoryImpl(const SharedPreferencesSettingsDataSource());
});
