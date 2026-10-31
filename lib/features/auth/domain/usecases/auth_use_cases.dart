import 'package:dompetqu/features/auth/domain/models/auth_passkey_credential.dart';
import 'package:dompetqu/features/auth/domain/models/auth_user.dart';
import 'package:dompetqu/features/auth/domain/repositories/auth_repository.dart';

class AuthUseCases {
  const AuthUseCases(this._repository);

  final AuthRepository _repository;

  Future<AuthUser?> restoreSession() => _repository.restoreSession();

  Future<AuthUser> signIn({
    required String username,
    required String password,
  }) => _repository.signIn(username: username, password: password);

  Future<AuthUser> signUp({
    required String name,
    required String username,
    required String password,
  }) => _repository.signUp(name: name, username: username, password: password);

  Future<AuthUser> signInWithPasskey() => _repository.signInWithPasskey();

  Future<void> signOut() => _repository.signOut();

  Future<bool> isPasskeySupported() => _repository.isPasskeySupported();

  Future<void> registerPasskey({String? deviceName}) =>
      _repository.registerPasskey(deviceName: deviceName);

  Future<List<AuthPasskeyCredential>> passkeys() => _repository.passkeys();

  Future<bool> deletePasskey(String credentialId) =>
      _repository.deletePasskey(credentialId);
}
