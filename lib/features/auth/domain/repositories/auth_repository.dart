import 'package:dompetqu/features/auth/domain/models/auth_passkey_credential.dart';
import 'package:dompetqu/features/auth/domain/models/auth_user.dart';

abstract interface class AuthRepository {
  Future<AuthUser?> restoreSession();

  Future<AuthUser> signIn({required String username, required String password});

  Future<AuthUser> signUp({
    required String name,
    required String username,
    required String password,
  });

  Future<AuthUser> signInWithPasskey();

  Future<void> signOut();

  Future<bool> isPasskeySupported();

  Future<void> registerPasskey({String? deviceName});

  Future<List<AuthPasskeyCredential>> passkeys();

  Future<bool> deletePasskey(String credentialId);
}
