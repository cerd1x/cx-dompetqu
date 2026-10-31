import 'package:dompetqu/features/app_lock/adapters/app_lock_storage.dart';
import 'package:dompetqu/features/app_lock/adapters/datasources/local_biometric_datasource.dart';
import 'package:dompetqu/features/app_lock/adapters/repositories/app_lock_repository_impl.dart';
import 'package:dompetqu/features/app_lock/domain/repositories/app_lock_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appLockRepositoryProvider = Provider<AppLockRepository>((ref) {
  return AppLockRepositoryImpl(
    ref.watch(appLockStorageProvider),
    LocalAppLockBiometricDataSource(),
  );
});
