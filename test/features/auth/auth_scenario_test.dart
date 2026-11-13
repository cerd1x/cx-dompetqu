import 'package:flutter_test/flutter_test.dart';

import 'package:cx_dompetqiu/features/auth/adapters/mappers/user_mapper.dart';
import 'package:cx_dompetqiu/features/auth/adapters/models/user.dart' as data;
import 'package:cx_dompetqiu/features/auth/domain/models/auth_failure.dart';
import 'package:cx_dompetqiu/features/auth/domain/models/auth_passkey_credential.dart';
import 'package:cx_dompetqiu/features/auth/domain/models/auth_user.dart';
import 'package:cx_dompetqiu/features/auth/domain/repositories/auth_repository.dart';
import 'package:cx_dompetqiu/features/auth/domain/usecases/auth_use_cases.dart';

class _FakeAuthRepository implements AuthRepository {
  AuthUser? session;
  String? lastDeviceName;
  int signOutCalls = 0;
  bool passkeySupported = true;

  final List<AuthPasskeyCredential> credentials = [
    AuthPasskeyCredential(id: 'pk-1', deviceName: 'Laptop'),
  ];

  @override
  Future<AuthUser?> restoreSession() async => session;

  @override
  Future<AuthUser> signIn({
    required String username,
    required String password,
  }) async {
    if (password != 'secret') throw const AuthFailure('Password salah');
    return AuthUser(id: 'u1', name: 'Cerdix', username: username);
  }

  @override
  Future<AuthUser> signUp({
    required String name,
    required String username,
    required String password,
  }) async => AuthUser(id: 'u2', name: name, username: username);

  @override
  Future<AuthUser> signInWithPasskey() async =>
      AuthUser(id: 'u3', name: 'Passkey User', username: 'passkey');

  @override
  Future<void> signOut() async => signOutCalls++;

  @override
  Future<bool> isPasskeySupported() async => passkeySupported;

  @override
  Future<void> registerPasskey({String? deviceName}) async =>
      lastDeviceName = deviceName;

  @override
  Future<List<AuthPasskeyCredential>> passkeys() async =>
      List.of(credentials);

  @override
  Future<bool> deletePasskey(String credentialId) async {
    final before = credentials.length;
    credentials.removeWhere((c) => c.id == credentialId);
    return credentials.length != before;
  }
}

void main() {
  group('Skenario pemetaan user', () {
    test('User adapter dipetakan ke AuthUser domain', () {
      final user = data.User(
        id: '42',
        name: 'Cerdix',
        username: 'cerd1x',
        avatarUrl: 'https://example.com/a.png',
      );

      final entity = user.toEntity();

      expect(entity.id, '42');
      expect(entity.name, 'Cerdix');
      expect(entity.username, 'cerd1x');
      expect(entity.avatarUrl, 'https://example.com/a.png');
    });

    test('avatarUrl opsional tetap null', () {
      final entity = data.User(
        id: '1',
        name: 'Anon',
        username: 'anon',
      ).toEntity();

      expect(entity.avatarUrl, isNull);
    });
  });

  group('Skenario AuthUseCases', () {
    test('signIn berhasil mengembalikan user', () async {
      final useCases = AuthUseCases(_FakeAuthRepository());

      final user = await useCases.signIn(
        username: 'cerd1x',
        password: 'secret',
      );

      expect(user.username, 'cerd1x');
    });

    test('signIn gagal melempar AuthFailure dari repository', () async {
      final useCases = AuthUseCases(_FakeAuthRepository());

      await expectLater(
        useCases.signIn(username: 'cerd1x', password: 'salah'),
        throwsA(
          isA<AuthFailure>().having(
            (e) => e.message,
            'message',
            'Password salah',
          ),
        ),
      );
    });

    test('signUp meneruskan nama & username', () async {
      final user = await AuthUseCases(_FakeAuthRepository()).signUp(
        name: 'Nama Baru',
        username: 'baru',
        password: 'x',
      );

      expect(user.id, 'u2');
      expect(user.name, 'Nama Baru');
      expect(user.username, 'baru');
    });

    test('restoreSession null saat belum login', () async {
      final useCases = AuthUseCases(_FakeAuthRepository());

      expect(await useCases.restoreSession(), isNull);
    });

    test('signOut didelegasikan ke repository', () async {
      final repository = _FakeAuthRepository();

      await AuthUseCases(repository).signOut();

      expect(repository.signOutCalls, 1);
    });

    test('alur passkey: dukungan, register, daftar, hapus', () async {
      final repository = _FakeAuthRepository();
      final useCases = AuthUseCases(repository);

      expect(await useCases.isPasskeySupported(), isTrue);
      await useCases.registerPasskey(deviceName: '  Laptop  ');
      expect(repository.lastDeviceName, '  Laptop  ');

      final user = await useCases.signInWithPasskey();
      expect(user.username, 'passkey');

      final credentials = await useCases.passkeys();
      expect(credentials.single.id, 'pk-1');

      expect(await useCases.deletePasskey('pk-1'), isTrue);
      expect(await useCases.deletePasskey('pk-1'), isFalse);
    });

    test('passkey tidak didukung dilaporkan apa adanya', () async {
      final repository = _FakeAuthRepository()..passkeySupported = false;

      expect(await AuthUseCases(repository).isPasskeySupported(), isFalse);
    });
  });

  group('Skenario AuthFailure', () {
    test('toString mengembalikan pesan', () {
      const failure = AuthFailure('Sesi kedaluwarsa');

      expect(failure.toString(), 'Sesi kedaluwarsa');
      expect(failure, isA<Exception>());
    });
  });
}
