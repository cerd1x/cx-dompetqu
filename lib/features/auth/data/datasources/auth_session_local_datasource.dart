import '../../../../core/network/cookie_aware_client.dart';

abstract interface class AuthSessionLocalDataSource {
  Future<void> restore();
  bool get isSessionValid;
  String? get refreshToken;
  Future<bool> refreshSession();
  Future<void> saveTokens(String session, String refreshToken);
  Future<void> clear();
}

class CookieAuthSessionLocalDataSource implements AuthSessionLocalDataSource {
  const CookieAuthSessionLocalDataSource(this._client);

  final CookieAwareClient _client;

  @override
  Future<void> restore() => _client.restore();

  @override
  bool get isSessionValid => _client.isSessionValid;

  @override
  String? get refreshToken => _client.refreshToken;

  @override
  Future<bool> refreshSession() => _client.refreshSession();

  @override
  Future<void> saveTokens(String session, String refreshToken) async {
    await _client.setToken(session);
    await _client.setRefreshToken(refreshToken);
  }

  @override
  Future<void> clear() => _client.clear();
}
