/// Kredensial utama pengunci aplikasi (PIN atau pola).
enum LockCredential {
  pin,
  pattern;

  String get label => switch (this) {
    LockCredential.pin => 'PIN',
    LockCredential.pattern => 'Pola',
  };
}

/// State aplikasi lock screen.
///
/// [credential] = kredensial wajib (PIN/pola).
/// [biometricEnabled] = opsi tambahan: buka cepat via sidik jari/Face ID.
class AppLockState {
  const AppLockState({
    this.isEnabled = false,
    this.credential = LockCredential.pin,
    this.biometricEnabled = false,
    this.locked = true,
    this.failedAttempts = 0,
    this.lockoutUntil,
  });

  final bool isEnabled;
  final LockCredential credential;
  final bool biometricEnabled;
  final bool locked;
  final int failedAttempts;
  final DateTime? lockoutUntil;

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
