import '../../domain/entities/auth_passkey_credential.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/failures/auth_failure.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/auth_session_local_datasource.dart';
import '../datasources/passkey_datasource.dart';
import '../mappers/user_mapper.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(
    this._remoteSource,
    this._passkeyService,
    this._session,
  );

  final AuthRemoteDataSource _remoteSource;
  final PasskeyDataSource _passkeyService;
  final AuthSessionLocalDataSource _session;

  @override
  Future<AuthUser?> restoreSession() async {
    await _session.restore();
    if (!_session.isSessionValid && _session.refreshToken != null) {
      await _session.refreshSession();
    }
    if (!await _remoteSource.checkAuthorized()) return null;
    return (await _remoteSource.me())?.toEntity();
  }

  @override
  Future<AuthUser> signIn({
    required String username,
    required String password,
  }) async {
    final result = await _remoteSource.signIn(
      username: username,
      password: password,
    );
    await _saveTokens(result.session, result.refreshToken);
    return result.user.toEntity();
  }

  @override
  Future<AuthUser> signUp({
    required String name,
    required String username,
    required String password,
  }) async {
    final result = await _remoteSource.signUp(
      name: name,
      username: username,
      password: password,
    );
    await _saveTokens(result.session, result.refreshToken);
    return result.user.toEntity();
  }

  @override
  Future<AuthUser> signInWithPasskey() async {
    final result = await _passkeyService.signInWithPasskey();
    await _saveTokens(result.session, result.refreshToken);
    return result.user.toEntity();
  }

  @override
  Future<void> signOut() async {
    try {
      await _remoteSource.signOut();
    } on AuthFailure {
      await _session.clear();
      rethrow;
    }
    await _session.clear();
  }

  @override
  Future<bool> isPasskeySupported() => _passkeyService.isSupported;

  @override
  Future<void> registerPasskey({String? deviceName}) =>
      _passkeyService.registerPasskey(deviceName: deviceName);

  @override
  Future<List<AuthPasskeyCredential>> passkeys() async =>
      (await _passkeyService.passkeys())
          .map(
            (credential) => AuthPasskeyCredential(
              id: credential.id,
              deviceName: credential.deviceName,
              createdAt: credential.createdAt,
            ),
          )
          .toList();

  @override
  Future<bool> deletePasskey(String credentialId) =>
      _passkeyService.deletePasskey(credentialId);

  Future<void> _saveTokens(String session, String refreshToken) async {
    await _session.saveTokens(session, refreshToken);
  }
}
