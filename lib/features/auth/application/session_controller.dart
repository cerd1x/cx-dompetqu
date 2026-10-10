import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/graphql/graphql_providers.dart';
import '../../../core/logger/app_logger.dart';
import '../../../core/network/cookie_aware_client.dart';
import '../data/auth_remote_source.dart';
import '../data/passkey_service.dart';
import '../models/user.dart';

part 'session_controller.g.dart';

enum AuthStatus { unknown, unauthenticated, authenticated }

class SessionState {
  const SessionState({
    this.status = AuthStatus.unknown,
    this.user,
    this.error,
    this.busy = false,
  });

  final AuthStatus status;
  final User? user;
  final String? error;
  final bool busy;

  bool get isAuthenticated => status == AuthStatus.authenticated;

  SessionState copyWith({
    AuthStatus? status,
    User? user,
    String? error,
    bool? busy,
  }) => SessionState(
    status: status ?? this.status,
    user: user ?? this.user,
    error: error ?? this.error,
    busy: busy ?? this.busy,
  );
}

/// State session global — padanan session/`userStore` di web.
@Riverpod(keepAlive: true)
class SessionController extends _$SessionController {
  AuthRemoteSource get _source => ref.read(authRemoteSourceProvider);

  PasskeyService get _passkey => ref.read(passkeyServiceProvider);

  CookieAwareClient get _cookieClient => ref.read(cookieAwareClientProvider);

  AppLogger get _log => AppLogger.instance;

  @override
  SessionState build() {
    restore();
    return const SessionState();
  }

  /// Restore session saat app start: cek cookie + ambil profil user.
  Future<void> restore() async {
    state = const SessionState(status: AuthStatus.unknown);
    try {
      await _cookieClient.restore();
      // Refresh `__sst__` memakai `__rft__` bila session sudah usang.
      if (!_cookieClient.isSessionValid && _cookieClient.refreshToken != null) {
        _log.info('Session usang — refresh memakai __rft__', tag: 'Session');
        await _cookieClient.refreshSession();
      }
      final authorized = await _source.checkAuthorized();
      if (!authorized) {
        _log.debug('Sesi tidak terotorisasi', tag: 'Session');
        state = const SessionState(status: AuthStatus.unauthenticated);
        return;
      }
      final user = await _source.me();
      _log.debug(
        'Sesi direstore: ${user?.username ?? 'tanpa user'}',
        tag: 'Session',
      );
      state = SessionState(
        status: user == null
            ? AuthStatus.unauthenticated
            : AuthStatus.authenticated,
        user: user,
      );
    } on AuthException catch (e) {
      _log.warn('Restore sesi gagal: ${e.message}', tag: 'Session');
      state = SessionState(
        status: AuthStatus.unauthenticated,
        error: e.message,
      );
    } catch (e) {
      _log.error('Restore sesi error tak terduga', tag: 'Session', error: e);
      state = const SessionState(status: AuthStatus.unauthenticated);
    }
  }

  Future<bool> signIn({
    required String username,
    required String password,
  }) async {
    state = state.copyWith(busy: true, error: null);
    try {
      final result = await _source.signIn(
        username: username,
        password: password,
      );
      _log.success('Sign in: ${result.user.username}', tag: 'Session');
      await _cookieClient.setToken(result.session);
      await _cookieClient.setRefreshToken(result.refreshToken);
      state = SessionState(status: AuthStatus.authenticated, user: result.user);
      return true;
    } on AuthException catch (e) {
      _log.warn('Sign in gagal: ${e.message}', tag: 'Session');
      state = state.copyWith(busy: false, error: e.message);
      return false;
    }
  }

  Future<bool> signUp({
    required String name,
    required String username,
    required String password,
  }) async {
    state = state.copyWith(busy: true, error: null);
    try {
      final result = await _source.signUp(
        name: name,
        username: username,
        password: password,
      );
      _log.success('Sign up: ${result.user.username}', tag: 'Session');
      await _cookieClient.setToken(result.session);
      await _cookieClient.setRefreshToken(result.refreshToken);
      state = SessionState(status: AuthStatus.authenticated, user: result.user);
      return true;
    } on AuthException catch (e) {
      _log.warn('Sign up gagal: ${e.message}', tag: 'Session');
      state = state.copyWith(busy: false, error: e.message);
      return false;
    }
  }

  Future<bool> signInWithPasskey() async {
    state = state.copyWith(busy: true, error: null);
    try {
      final result = await _passkey.signInWithPasskey();
      _log.success('Passkey sign in: ${result.user.username}', tag: 'Session');
      await _cookieClient.setToken(result.session);
      await _cookieClient.setRefreshToken(result.refreshToken);
      state = SessionState(status: AuthStatus.authenticated, user: result.user);
      return true;
    } on AuthException catch (e) {
      _log.warn('Passkey sign in gagal: ${e.message}', tag: 'Session');
      state = state.copyWith(busy: false, error: e.message);
      return false;
    } catch (e) {
      _log.error('Passkey sign in error tak terduga', tag: 'Session', error: e);
      state = state.copyWith(
        busy: false,
        error: 'Passkey authentication failed',
      );
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      await _source.signOut();
      _log.info('Sign out server OK', tag: 'Session');
    } on AuthException catch (e) {
      _log.warn('Sign out server gagal: ${e.message}', tag: 'Session');
      // tetap lanjut logout lokal walaupun server menolak
    }
    await _cookieClient.clear();
    state = const SessionState(status: AuthStatus.unauthenticated);
  }

  void clearError() => state = state.copyWith(error: null);
}
