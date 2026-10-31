import 'package:dompetqu/features/app_lock/domain/models/app_lock_state.dart';

abstract interface class AppLockRepository {
  Future<void> ensureUsable();
  Future<bool> isEnabled();
  Future<LockCredential> getCredential();
  Future<bool> isBiometricEnabled();
  Future<bool> verifyPin(String pin);
  Future<bool> verifyPattern(List<int> pattern);
  Future<void> setEnabled(bool value);
  Future<void> setBiometricEnabled(bool value);
  Future<void> savePin(String pin);
  Future<void> savePattern(List<int> pattern);
  Future<void> clearAll();
  Future<bool> authenticateBiometric();
}
