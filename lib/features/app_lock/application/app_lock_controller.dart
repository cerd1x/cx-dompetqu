import 'dart:async';

import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/app_lock_storage.dart';
import '../models/lock_method.dart';

part 'app_lock_controller.g.dart';

const int _kMaxFailedAttempts = 5;
const Duration _kLockoutDuration = Duration(minutes: 1);

/// Controller untuk state & logika app lock.
@Riverpod(keepAlive: true)
class AppLockController extends _$AppLockController {
  Timer? _lockoutTimer;
  final LocalAuthentication _localAuth = LocalAuthentication();

  @override
  Future<AppLockState> build() async {
    final storage = ref.read(appLockStorageProvider);
    await storage.ensureUsable();
    final enabled = await storage.isEnabled();
    final credential = await storage.getCredential();
    final biometricEnabled = await storage.isBiometricEnabled();
    return AppLockState(
      isEnabled: enabled,
      credential: credential,
      biometricEnabled: biometricEnabled,
      locked: enabled,
    );
  }

  // ---------------------------------------------------------------------------
  // Setup
  // ---------------------------------------------------------------------------

  /// Menyimpan PIN sebagai kredensial utama (opsional ditambah biometrik).
  Future<void> setupPin(String pin, {bool biometricEnabled = false}) async {
    final storage = ref.read(appLockStorageProvider);
    await storage.savePin(pin);
    await storage.setBiometricEnabled(biometricEnabled);
    await storage.setEnabled(true);
    state = AsyncValue.data(
      AppLockState(
        isEnabled: true,
        credential: LockCredential.pin,
        biometricEnabled: biometricEnabled,
        locked: false,
      ),
    );
  }

  /// Menyimpan pola sebagai kredensial utama (opsional ditambah biometrik).
  Future<void> setupPattern(
    List<int> pattern, {
    bool biometricEnabled = false,
  }) async {
    final storage = ref.read(appLockStorageProvider);
    await storage.savePattern(pattern);
    await storage.setBiometricEnabled(biometricEnabled);
    await storage.setEnabled(true);
    state = AsyncValue.data(
      AppLockState(
        isEnabled: true,
        credential: LockCredential.pattern,
        biometricEnabled: biometricEnabled,
        locked: false,
      ),
    );
  }

  /// Mengaktifkan biometrik sebagai opsi buka cepat di atas kredensial.
  Future<void> enableBiometric() async {
    final current = state.value;
    if (current == null || !current.isEnabled) return;
    final storage = ref.read(appLockStorageProvider);
    await storage.setBiometricEnabled(true);
    state = AsyncValue.data(current.copyWith(biometricEnabled: true));
  }

  /// Menonaktifkan opsi biometrik (kredensial PIN/pola tetap aktif).
  Future<void> disableBiometric() async {
    final current = state.value;
    if (current == null) return;
    final storage = ref.read(appLockStorageProvider);
    await storage.setBiometricEnabled(false);
    state = AsyncValue.data(current.copyWith(biometricEnabled: false));
  }

  Future<void> disableLock() async {
    final storage = ref.read(appLockStorageProvider);
    await storage.clearAll();
    state = AsyncValue.data(const AppLockState());
  }

  // ---------------------------------------------------------------------------
  // Unlock
  // ---------------------------------------------------------------------------

  Future<bool> unlockWithPin(String pin) async {
    if (state.value?.isLockedOut == true) return false;

    final storage = ref.read(appLockStorageProvider);
    final ok = await storage.verifyPin(pin);

    if (ok) {
      _resetAttempts();
      _setLocked(false);
      return true;
    }

    _incrementFailedAttempts();
    return false;
  }

  Future<bool> unlockWithPattern(List<int> pattern) async {
    if (state.value?.isLockedOut == true) return false;

    final storage = ref.read(appLockStorageProvider);
    final ok = await storage.verifyPattern(pattern);

    if (ok) {
      _resetAttempts();
      _setLocked(false);
      return true;
    }

    _incrementFailedAttempts();
    return false;
  }

  /// Autentikasi biometrik penuh (memunculkan prompt OS) lalu membuka kunci.
  ///
  /// Hanya panggil jika biometrik BELUM diverifikasi di UI. Jika pemanggil
  /// hanya memverifikasi via `LocalAuthentication` (mis. `BiometricButton`),
  /// gunakan [completeUnlock] agar prompt tidak muncul dua kali.
  Future<bool> unlockWithBiometric() async {
    final current = state.value;
    if (current?.isLockedOut == true) return false;

    try {
      final available = await _localAuth.canCheckBiometrics;
      if (!available) return false;

      final ok = await _localAuth.authenticate(
        localizedReason: 'Autentikasi untuk membuka aplikasi',
        persistAcrossBackgrounding: true,
        biometricOnly: true,
      );

      if (ok) {
        _resetAttempts();
        _setLocked(false);
        return true;
      }
      return false;
    } on PlatformException {
      return false;
    }
  }

  /// Menyelesaikan unlock tanpa memunculkan prompt autentikasi lagi.
  ///
  /// Dipanggil setelah biometrik berhasil diverifikasi oleh `BiometricButton`.
  void completeUnlock() {
    final current = state.value;
    if (current == null || current.isLockedOut) return;
    _resetAttempts();
    _setLocked(false);
  }

  Future<void> lock() async {
    final current = state.value;
    if (current == null || !current.isEnabled) return;
    state = AsyncValue.data(current.copyWith(locked: true));
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  void _setLocked(bool value) {
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(current.copyWith(locked: value));
  }

  void _incrementFailedAttempts() {
    final current = state.value;
    if (current == null) return;

    final attempts = current.failedAttempts + 1;
    if (attempts >= _kMaxFailedAttempts) {
      final lockoutUntil = DateTime.now().add(_kLockoutDuration);
      state = AsyncValue.data(
        current.copyWith(
          failedAttempts: attempts,
          lockoutUntil: lockoutUntil,
        ),
      );
      _startLockoutTimer(_kLockoutDuration);
    } else {
      state = AsyncValue.data(current.copyWith(failedAttempts: attempts));
    }
  }

  void _resetAttempts() {
    _lockoutTimer?.cancel();
    _lockoutTimer = null;
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(
      current.copyWith(failedAttempts: 0, clearLockout: true),
    );
  }

  void _startLockoutTimer(Duration duration) {
    _lockoutTimer?.cancel();
    _lockoutTimer = Timer(duration, () {
      _resetAttempts();
    });
  }
}