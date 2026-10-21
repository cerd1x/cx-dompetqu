import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/app_lock_storage.dart';
import '../data/datasources/local_biometric_datasource.dart';
import '../data/repositories/app_lock_repository_impl.dart';
import '../domain/repositories/app_lock_repository.dart';

final appLockRepositoryProvider = Provider<AppLockRepository>((ref) {
  return AppLockRepositoryImpl(
    ref.watch(appLockStorageProvider),
    LocalAppLockBiometricDataSource(),
  );
});
