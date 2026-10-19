import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/app_lock_state.freezed.dart';

/// Kredensial utama pengunci aplikasi (PIN atau pola).
enum LockCredential {
  pin,
  pattern;

  String get label => switch (this) {
    LockCredential.pin => 'PIN',
    LockCredential.pattern => 'Pola',
  };
}

/// Status penguncian aplikasi.
///
/// `copyWith` dibuat manual (generated copyWith dimatikan) karena ada
/// kebutuhan meng-clear `lockoutUntil` ke null lewat flag `clearLockout` —
/// generated copyWith Freezed tidak bisa meng-null-kan field nullable.
@Freezed(copyWith: false)
abstract class AppLockState with _$AppLockState {
  const factory AppLockState({
    @Default(false) bool isEnabled,
    @Default(LockCredential.pin) LockCredential credential,
    @Default(false) bool biometricEnabled,
    @Default(true) bool locked,
    @Default(0) int failedAttempts,
    DateTime? lockoutUntil,
  }) = _AppLockState;

  const AppLockState._();

  bool get isLockedOut =>
      lockoutUntil != null && DateTime.now().isBefore(lockoutUntil!);

  AppLockState copyWith({
    bool? isEnabled,
    LockCredential? credential,
    bool? biometricEnabled,
    bool? locked,
    int? failedAttempts,
    DateTime? lockoutUntil,
    bool clearLockout = false,
  }) => AppLockState(
    isEnabled: isEnabled ?? this.isEnabled,
    credential: credential ?? this.credential,
    biometricEnabled: biometricEnabled ?? this.biometricEnabled,
    locked: locked ?? this.locked,
    failedAttempts: failedAttempts ?? this.failedAttempts,
    lockoutUntil: clearLockout ? null : (lockoutUntil ?? this.lockoutUntil),
  );
}
