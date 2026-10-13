import '../../domain/entities/app_lock_state.dart';
import '../../domain/repositories/app_lock_repository.dart';
import '../datasources/app_lock_datasources.dart';

class AppLockRepositoryImpl implements AppLockRepository {
  const AppLockRepositoryImpl(this._local, this._biometric);

  final AppLockLocalDataSource _local;
  final AppLockBiometricDataSource _biometric;

  @override
  Future<void> ensureUsable() => _local.ensureUsable();

  @override
  Future<bool> isEnabled() => _local.isEnabled();

  @override
  Future<LockCredential> getCredential() => _local.getCredential();

  @override
  Future<bool> isBiometricEnabled() => _local.isBiometricEnabled();

  @override
  Future<bool> verifyPin(String pin) => _local.verifyPin(pin);

  @override
  Future<bool> verifyPattern(List<int> pattern) =>
      _local.verifyPattern(pattern);

  @override
  Future<void> setEnabled(bool value) => _local.setEnabled(value);

  @override
  Future<void> setBiometricEnabled(bool value) =>
      _local.setBiometricEnabled(value);

  @override
  Future<void> savePin(String pin) => _local.savePin(pin);

  @override
  Future<void> savePattern(List<int> pattern) => _local.savePattern(pattern);

  @override
  Future<void> clearAll() => _local.clearAll();

  @override
  Future<bool> authenticateBiometric() => _biometric.authenticate();
}
