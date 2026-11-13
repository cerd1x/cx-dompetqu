import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cx_dompetqiu/features/app_lock/adapters/datasources/app_lock_datasources.dart';
import 'package:cx_dompetqiu/features/app_lock/adapters/repositories/app_lock_repository_impl.dart';
import 'package:cx_dompetqiu/features/app_lock/domain/models/app_lock_state.dart';
import 'package:cx_dompetqiu/features/app_lock/domain/repositories/app_lock_repository.dart';
import 'package:cx_dompetqiu/features/app_lock/view/stores/app_lock_repository_provider.dart';
import 'package:cx_dompetqiu/features/app_lock/view/stores/app_lock_store.dart';

class _FakeLocal implements AppLockLocalDataSource {
  _FakeLocal({
    this.enabled = true,
    this.credential = LockCredential.pin,
    this.biometric = false,
    this.validPin = '1234',
    this.validPattern = const [0, 1, 2],
  });

  bool enabled;
  LockCredential credential;
  bool biometric;
  String validPin;
  List<int> validPattern;
  bool cleared = false;

  @override
  Future<void> ensureUsable() async {}

  @override
  Future<bool> isEnabled() async => enabled;

  @override
  Future<LockCredential> getCredential() async => credential;

  @override
  Future<bool> isBiometricEnabled() async => biometric;

  @override
  Future<bool> verifyPin(String pin) async => pin == validPin;

  @override
  Future<bool> verifyPattern(List<int> pattern) async {
    if (pattern.length != validPattern.length) return false;
    for (var i = 0; i < pattern.length; i++) {
      if (pattern[i] != validPattern[i]) return false;
    }
    return true;
  }

  @override
  Future<void> setEnabled(bool value) async => enabled = value;

  @override
  Future<void> setBiometricEnabled(bool value) async => biometric = value;

  @override
  Future<void> savePin(String pin) async {
    credential = LockCredential.pin;
    validPin = pin;
  }

  @override
  Future<void> savePattern(List<int> pattern) async {
    credential = LockCredential.pattern;
    validPattern = pattern;
  }

  @override
  Future<void> clearAll() async {
    cleared = true;
    enabled = false;
    biometric = false;
    credential = LockCredential.pin;
  }
}

class _FakeBiometric implements AppLockBiometricDataSource {
  _FakeBiometric({this.result = true});

  bool result;

  @override
  Future<bool> authenticate() async => result;
}

class _FakeRepository implements AppLockRepository {
  _FakeRepository({this.pin = '1234'});

  String pin;
  bool enabled = true;
  bool biometricEnabled = false;
  LockCredential credential = LockCredential.pin;
  int verifyCalls = 0;
  bool biometricResult = true;
  bool cleared = false;

  @override
  Future<void> ensureUsable() async {}

  @override
  Future<bool> isEnabled() async => enabled;

  @override
  Future<LockCredential> getCredential() async => credential;

  @override
  Future<bool> isBiometricEnabled() async => biometricEnabled;

  @override
  Future<bool> verifyPin(String value) async {
    verifyCalls++;
    return value == pin;
  }

  @override
  Future<bool> verifyPattern(List<int> pattern) async => pattern == [0, 1, 2];

  @override
  Future<void> setEnabled(bool value) async => enabled = value;

  @override
  Future<void> setBiometricEnabled(bool value) async =>
      biometricEnabled = value;

  @override
  Future<void> savePin(String value) async {
    pin = value;
    credential = LockCredential.pin;
  }

  @override
  Future<void> savePattern(List<int> pattern) async =>
      credential = LockCredential.pattern;

  @override
  Future<void> clearAll() async {
    cleared = true;
    enabled = false;
    biometricEnabled = false;
  }

  @override
  Future<bool> authenticateBiometric() async => biometricResult;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Skenario state app lock', () {
    test('default: aktif? tidak, terkunci, kredensial PIN', () {
      const state = AppLockState();

      expect(state.isEnabled, isFalse);
      expect(state.locked, isTrue);
      expect(state.credential, LockCredential.pin);
      expect(state.failedAttempts, 0);
      expect(state.isLockedOut, isFalse);
    });

    test('isLockedOut hanya true sebelum waktu lockout lewat', () {
      final future = AppLockState(
        lockoutUntil: DateTime.now().add(const Duration(minutes: 1)),
      );
      final past = AppLockState(
        lockoutUntil: DateTime.now().subtract(const Duration(minutes: 1)),
      );

      expect(future.isLockedOut, isTrue);
      expect(past.isLockedOut, isFalse);
    });

    test('copyWith clearLockout menghapus waktu lockout', () {
      final state = AppLockState(
        failedAttempts: 5,
        lockoutUntil: DateTime.now().add(const Duration(minutes: 1)),
      );

      final cleared = state.copyWith(failedAttempts: 0, clearLockout: true);

      expect(cleared.failedAttempts, 0);
      expect(cleared.lockoutUntil, isNull);
      expect(cleared.isLockedOut, isFalse);
    });

    test('copyWith tanpa argumen mempertahankan nilai lama', () {
      const state = AppLockState(isEnabled: true, biometricEnabled: true);
      final same = state.copyWith();

      expect(same.isEnabled, isTrue);
      expect(same.biometricEnabled, isTrue);
    });
  });

  group('Skenario AppLockRepositoryImpl', () {
    test('mendelegasikan verifikasi PIN/pola dan biometrik', () async {
      final local = _FakeLocal(validPin: '9999');
      final biometric = _FakeBiometric(result: false);
      final repository = AppLockRepositoryImpl(local, biometric);

      expect(await repository.verifyPin('9999'), isTrue);
      expect(await repository.verifyPin('0000'), isFalse);
      expect(await repository.verifyPattern([0, 1, 2]), isTrue);
      expect(await repository.authenticateBiometric(), isFalse);
    });

    test('clearAll menonaktifkan lock di penyimpanan lokal', () async {
      final local = _FakeLocal();
      final repository = AppLockRepositoryImpl(local, _FakeBiometric());

      await repository.clearAll();

      expect(local.cleared, isTrue);
      expect(await repository.isEnabled(), isFalse);
    });
  });

  group('Skenario AppLockStore', () {
    ProviderContainer containerWith(_FakeRepository repository) {
      final container = ProviderContainer(
        overrides: [
          appLockRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);
      return container;
    }

    test('build memuat status lock dari repository', () async {
      final repository = _FakeRepository()..biometricEnabled = true;
      final container = containerWith(repository);

      final state = await container.read(appLockStoreProvider.future);

      expect(state.isEnabled, isTrue);
      expect(state.locked, isTrue);
      expect(state.biometricEnabled, isTrue);
    });

    test('PIN salah menambah failedAttempts, PIN benar mereset', () async {
      final repository = _FakeRepository();
      final container = containerWith(repository);
      await container.read(appLockStoreProvider.future);
      final notifier = container.read(appLockStoreProvider.notifier);

      expect(await notifier.unlockWithPin('0000'), isFalse);
      expect(container.read(appLockStoreProvider).value!.failedAttempts, 1);

      expect(await notifier.unlockWithPin('1234'), isTrue);
      final state = container.read(appLockStoreProvider).value!;
      expect(state.failedAttempts, 0);
      expect(state.locked, isFalse);
    });

    test('lima kali gagal mengunci sementara pengguna', () async {
      final repository = _FakeRepository();
      final container = containerWith(repository);
      await container.read(appLockStoreProvider.future);
      final notifier = container.read(appLockStoreProvider.notifier);

      for (var i = 0; i < 5; i++) {
        await notifier.unlockWithPin('0000');
      }

      final state = container.read(appLockStoreProvider).value!;
      expect(state.failedAttempts, 5);
      expect(state.isLockedOut, isTrue);
      // Saat lockout, verifikasi tidak dipanggil lagi.
      final callsBefore = repository.verifyCalls;
      expect(await notifier.unlockWithPin('1234'), isFalse);
      expect(repository.verifyCalls, callsBefore);
    });

    test('setupPin & disableLock memperbarui state', () async {
      final repository = _FakeRepository()..enabled = false;
      final container = containerWith(repository);
      await container.read(appLockStoreProvider.future);
      final notifier = container.read(appLockStoreProvider.notifier);

      await notifier.setupPin('4321', biometricEnabled: true);
      var state = container.read(appLockStoreProvider).value!;
      expect(state.isEnabled, isTrue);
      expect(state.credential, LockCredential.pin);
      expect(state.biometricEnabled, isTrue);
      expect(state.locked, isFalse);

      await notifier.disableLock();
      state = container.read(appLockStoreProvider).value!;
      expect(state.isEnabled, isFalse);
      expect(repository.cleared, isTrue);
    });

    test('unlockWithBiometric gagal tidak membuka kunci', () async {
      final repository = _FakeRepository()..biometricResult = false;
      final container = containerWith(repository);
      await container.read(appLockStoreProvider.future);
      final notifier = container.read(appLockStoreProvider.notifier);

      expect(await notifier.unlockWithBiometric(), isFalse);
      expect(container.read(appLockStoreProvider).value!.locked, isTrue);
    });
  });
}
