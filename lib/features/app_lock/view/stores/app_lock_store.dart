import 'dart:async';

import 'package:cx_dompetqiu/core/logger/app_logger.dart';
import 'package:cx_dompetqiu/features/app_lock/domain/models/app_lock_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'app_lock_repository_provider.dart';

part 'generated/app_lock_store.g.dart';

const int _kMaxFailedAttempts = 5;
const Duration _kLockoutDuration = Duration(minutes: 1);

/// Store untuk state & logika app lock.
@Riverpod(keepAlive: true)
class AppLockStore extends _$AppLockStore {
  final AppLogger _log = AppLogger.instance;
  Timer? _lockoutTimer;

  @override
  Future<AppLockState> build() async {
    ref.onDispose(() => _lockoutTimer?.cancel());
    final repository = ref.read(appLockRepositoryProvider);
    try {
      await repository.ensureUsable();
      final enabled = await repository.isEnabled();
      final credential = await repository.getCredential();
      final biometricEnabled = await repository.isBiometricEnabled();
      _log.success(
        'App lock dimuat (enabled: $enabled, biometric: $biometricEnabled)',
        tag: 'AppLockStore',
      );
      return AppLockState(
        isEnabled: enabled,
        credential: credential,
        biometricEnabled: biometricEnabled,
        locked: enabled,
      );
    } catch (e) {
      _log.error('Gagal memuat app lock', tag: 'AppLockStore', error: e);
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Setup
  // ---------------------------------------------------------------------------

  /// Menyimpan PIN sebagai kredensial utama (opsional ditambah biometrik).
  Future<void> setupPin(String pin, {bool biometricEnabled = false}) async {
    final repository = ref.read(appLockRepositoryProvider);
    try {
      await repository.savePin(pin);
      await repository.setBiometricEnabled(biometricEnabled);
      await repository.setEnabled(true);
    } catch (e) {
      _log.error('Gagal setup PIN', tag: 'AppLockStore', error: e);
      rethrow;
    }
    _log.success('PIN berhasil disimpan', tag: 'AppLockStore');
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
    final repository = ref.read(appLockRepositoryProvider);
    try {
      await repository.savePattern(pattern);
      await repository.setBiometricEnabled(biometricEnabled);
      await repository.setEnabled(true);
    } catch (e) {
      _log.error('Gagal setup pola', tag: 'AppLockStore', error: e);
      rethrow;
    }
    _log.success('Pola berhasil disimpan', tag: 'AppLockStore');
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
    final repository = ref.read(appLockRepositoryProvider);
    try {
      await repository.setBiometricEnabled(true);
    } catch (e) {
      _log.error('Gagal aktifkan biometrik', tag: 'AppLockStore', error: e);
      rethrow;
    }
    state = AsyncValue.data(current.copyWith(biometricEnabled: true));
  }

  /// Menonaktifkan opsi biometrik (kredensial PIN/pola tetap aktif).
  Future<void> disableBiometric() async {
    final current = state.value;
    if (current == null) return;
    final repository = ref.read(appLockRepositoryProvider);
    try {
      await repository.setBiometricEnabled(false);
    } catch (e) {
      _log.error('Gagal matikan biometrik', tag: 'AppLockStore', error: e);
      rethrow;
    }
    state = AsyncValue.data(current.copyWith(biometricEnabled: false));
  }

  Future<void> disableLock() async {
    final repository = ref.read(appLockRepositoryProvider);
    try {
      await repository.clearAll();
    } catch (e) {
      _log.error('Gagal nonaktifkan lock', tag: 'AppLockStore', error: e);
      rethrow;
    }
    _log.warn('App lock dinonaktifkan', tag: 'AppLockStore');
    state = AsyncValue.data(const AppLockState());
  }

  // ---------------------------------------------------------------------------
  // Unlock
  // ---------------------------------------------------------------------------

  Future<bool> unlockWithPin(String pin) async {
    if (state.value?.isLockedOut == true) return false;

    final ok = await ref.read(appLockRepositoryProvider).verifyPin(pin);

    if (ok) {
      _resetAttempts();
      _setLocked(false);
      return true;
    }

    _log.warn('PIN salah', tag: 'AppLockStore');
    _incrementFailedAttempts();
    return false;
  }

  Future<bool> unlockWithPattern(List<int> pattern) async {
    if (state.value?.isLockedOut == true) return false;

    final ok = await ref.read(appLockRepositoryProvider).verifyPattern(pattern);

    if (ok) {
      _resetAttempts();
      _setLocked(false);
      return true;
    }

    _log.warn('Pola salah', tag: 'AppLockStore');
    _incrementFailedAttempts();
    return false;
  }

  /// Autentikasi biometrik penuh (memunculkan prompt OS) lalu membuka kunci.
  ///
  /// Hanya panggil jika biometrik BELUM diverifikasi di UI. Jika pemanggil
  /// hanya memverifikasi via `LocalAuthentication` (mis. `CxButtonBiometric`),
  /// gunakan [completeUnlock] agar prompt tidak muncul dua kali.
  Future<bool> unlockWithBiometric() async {
    final current = state.value;
    if (current?.isLockedOut == true) return false;

    final ok = await ref
        .read(appLockRepositoryProvider)
        .authenticateBiometric();
    if (!ok) {
      _log.warn('Biometrik gagal', tag: 'AppLockStore');
      return false;
    }
    _log.success('Biometrik berhasil', tag: 'AppLockStore');
    _resetAttempts();
    _setLocked(false);
    return true;
  }

  /// Menyelesaikan unlock tanpa memunculkan prompt autentikasi lagi.
  ///
  /// Dipanggil setelah biometrik berhasil diverifikasi oleh `CxButtonBiometric`.
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
        current.copyWith(failedAttempts: attempts, lockoutUntil: lockoutUntil),
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
