import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/logger/app_logger.dart';
import '../domain/entities/auth_user.dart';
import '../domain/failures/auth_failure.dart';
import 'auth_providers.dart';

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
  final AuthUser? user;
  final String? error;
  final bool busy;

  bool get isAuthenticated => status == AuthStatus.authenticated;

  SessionState copyWith({
    AuthStatus? status,
    AuthUser? user,
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
      final user = await ref.read(authUseCasesProvider).restoreSession();
      if (user == null) {
        _log.debug('Sesi tidak terotorisasi', tag: 'Session');
        state = const SessionState(status: AuthStatus.unauthenticated);
        return;
      }
      _log.debug('Sesi direstore: ${user.username}', tag: 'Session');
      state = SessionState(status: AuthStatus.authenticated, user: user);
    } on AuthFailure catch (e) {
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
      final user = await ref
          .read(authUseCasesProvider)
          .signIn(username: username, password: password);
      _log.success('Sign in: ${user.username}', tag: 'Session');
      state = SessionState(status: AuthStatus.authenticated, user: user);
      return true;
    } on AuthFailure catch (e) {
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
      final user = await ref
          .read(authUseCasesProvider)
          .signUp(name: name, username: username, password: password);
      _log.success('Sign up: ${user.username}', tag: 'Session');
      state = SessionState(status: AuthStatus.authenticated, user: user);
      return true;
    } on AuthFailure catch (e) {
      _log.warn('Sign up gagal: ${e.message}', tag: 'Session');
      state = state.copyWith(busy: false, error: e.message);
      return false;
    }
  }

  Future<bool> signInWithPasskey() async {
    state = state.copyWith(busy: true, error: null);
    try {
      final user = await ref.read(authUseCasesProvider).signInWithPasskey();
      _log.success('Passkey sign in: ${user.username}', tag: 'Session');
      state = SessionState(status: AuthStatus.authenticated, user: user);
      return true;
    } on AuthFailure catch (e) {
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
      await ref.read(authUseCasesProvider).signOut();
      _log.info('Sign out server OK', tag: 'Session');
    } on AuthFailure catch (e) {
      _log.warn('Sign out server gagal: ${e.message}', tag: 'Session');
      // tetap lanjut logout lokal walaupun server menolak
    }
    state = const SessionState(status: AuthStatus.unauthenticated);
  }

  void clearError() => state = state.copyWith(error: null);
}
