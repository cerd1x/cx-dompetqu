import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cx_dompetqiu/features/settings/adapters/datasources/settings_local_datasource.dart';
import 'package:cx_dompetqiu/features/settings/adapters/repositories/settings_repository_impl.dart';
import 'package:cx_dompetqiu/features/settings/domain/repositories/settings_repository.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepositoryImpl(const ObjectBoxSettingsDataSource());
});
