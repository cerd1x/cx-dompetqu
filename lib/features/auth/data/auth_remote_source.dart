import 'package:graphql/client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/graphql/graphql_providers.dart';
import '../../../core/logger/app_logger.dart';
import '../models/passkey.dart';
import '../models/user.dart';

part 'auth_remote_source.g.dart';

class AuthException implements Exception {
  AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Remote source GraphQL untuk auth — padanan `auth_source.ts` + `passkey_source.ts`.
///
/// Operasi dipisah per intent (data retrieval vs. side-effect) supaya cache
/// GraphQL tidak mengganggu — mengikuti pola urql di web.
class AuthRemoteSource {
  AuthRemoteSource(this._client);

  final GraphQLClient _client;
  final AppLogger _log = AppLogger.instance;

  static const _signUpMutation = r'''
    mutation SignUp($input: SignUpInput!) {
      signUp(input: $input) { user { id name username } session refreshToken }
    }
  ''';

  static const _signInMutation = r'''
    mutation SignIn($input: SignInInput!) {
      signIn(input: $input) { user { id name username } session refreshToken }
    }
  ''';

  static const _signOutMutation = r'''
    mutation SignOut { signOut }
  ''';

  static const _meQuery = r'''
    query Me { me { id name username avatarUrl } }
  ''';

  static const _checkAuthorizedQuery = r'''
    query CheckAuthorized { checkAuthorized }
  ''';

  static const _passkeyAuthenticationOptionsQuery = r'''
    query PasskeyAuthenticationOptions {
      passkeyAuthenticationOptions { options challenge }
    }
  ''';

  static const _passkeyRegistrationOptionsQuery = r'''
    query PasskeyRegistrationOptions {
      passkeyRegistrationOptions { options challenge }
    }
  ''';

  static const _passkeysQuery = r'''
    query Passkeys { passkeys { id deviceName createdAt } }
  ''';

  static const _signInWithPassKeyMutation = r'''
    mutation SignInWithPassKey($input: SignInWithPassKeyInput!) {
      signInWithPassKey(input: $input) { user { id name username } session refreshToken }
    }
  ''';

  static const _registerPasskeyMutation = r'''
    mutation RegisterPasskey($input: RegisterPasskeyInput!) {
      registerPasskey(input: $input)
    }
  ''';

  static const _deletePasskeyMutation = r'''
    mutation DeletePasskey($credentialId: String!) {
      deletePasskey(credentialId: $credentialId)
    }
  ''';

  Future<({User user, String session, String refreshToken})> signUp({
    required String name,
    required String username,
    required String password,
  }) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(_signUpMutation),
        variables: {
          'input': {'name': name, 'username': username, 'password': password},
        },
      ),
    );
    final userJson = result.data?['signUp']?['user'];
    if (userJson == null) {
      throw AuthException(_errorMessage(result, fallback: 'Sign up failed'));
    }
    _log.success('signUp OK', tag: 'AuthRemoteSource');
    return (
      user: User.fromJson(userJson as Map<String, dynamic>),
      session: result.data?['signUp']?['session'] as String? ?? '',
      refreshToken: result.data?['signUp']?['refreshToken'] as String? ?? '',
    );
  }

  Future<({User user, String session, String refreshToken})> signIn({
    required String username,
    required String password,
  }) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(_signInMutation),
        variables: {
          'input': {'username': username, 'password': password},
        },
      ),
    );
    final userJson = result.data?['signIn']?['user'];
    if (userJson == null) {
      throw AuthException(_errorMessage(result, fallback: 'Sign in failed'));
    }
    _log.success('signIn OK', tag: 'AuthRemoteSource');
    return (
      user: User.fromJson(userJson as Map<String, dynamic>),
      session: result.data?['signIn']?['session'] as String? ?? '',
      refreshToken: result.data?['signIn']?['refreshToken'] as String? ?? '',
    );
  }

  Future<void> signOut() async {
    final result = await _client.mutate(
      MutationOptions(document: gql(_signOutMutation)),
    );
    if (result.hasException) {
      throw AuthException(_errorMessage(result, fallback: 'Sign out failed'));
    }
  }

  Future<bool> checkAuthorized() async {
    final result = await _client.query(
      QueryOptions(
        document: gql(_checkAuthorizedQuery),
        fetchPolicy: FetchPolicy.noCache,
      ),
    );
    return result.data?['checkAuthorized'] as bool? ?? false;
  }

  Future<User?> me() async {
    final result = await _client.query(
      QueryOptions(document: gql(_meQuery), fetchPolicy: FetchPolicy.noCache),
    );
    final userJson = result.data?['me'];
    if (userJson == null) return null;
    return User.fromJson(userJson as Map<String, dynamic>);
  }

  Future<PasskeyOptions> passkeyAuthenticationOptions() async {
    final result = await _client.query(
      QueryOptions(
        document: gql(_passkeyAuthenticationOptionsQuery),
        fetchPolicy: FetchPolicy.noCache,
      ),
    );
    final json = result.data?['passkeyAuthenticationOptions'];
    if (json == null) {
      throw AuthException('Failed to start passkey authentication');
    }
    return PasskeyOptions.fromJson(json as Map<String, dynamic>);
  }

  Future<PasskeyOptions> passkeyRegistrationOptions() async {
    final result = await _client.query(
      QueryOptions(
        document: gql(_passkeyRegistrationOptionsQuery),
        fetchPolicy: FetchPolicy.noCache,
      ),
    );
    final json = result.data?['passkeyRegistrationOptions'];
    if (json == null) {
      throw AuthException('Failed to start passkey registration');
    }
    return PasskeyOptions.fromJson(json as Map<String, dynamic>);
  }

  Future<({User user, String session, String refreshToken})> signInWithPassKey({
    required String challenge,
    required String credentialId,
    required String assertionResponse,
  }) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(_signInWithPassKeyMutation),
        variables: {
          'input': {
            'challenge': challenge,
            'credentialId': credentialId,
            'assertionResponse': assertionResponse,
          },
        },
      ),
    );
    final userJson = result.data?['signInWithPassKey']?['user'];
    if (userJson == null) {
      throw AuthException(
        _errorMessage(result, fallback: 'Sign in with passkey failed'),
      );
    }
    _log.success('signInWithPassKey OK', tag: 'AuthRemoteSource');
    return (
      user: User.fromJson(userJson as Map<String, dynamic>),
      session: result.data?['signInWithPassKey']?['session'] as String? ?? '',
      refreshToken:
          result.data?['signInWithPassKey']?['refreshToken'] as String? ?? '',
    );
  }

  Future<bool> registerPasskey({
    required String challenge,
    required String attestationResponse,
    String? deviceName,
  }) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(_registerPasskeyMutation),
        variables: {
          'input': {
            'challenge': challenge,
            'attestationResponse': attestationResponse,
            'deviceName': ?deviceName,
          },
        },
      ),
    );
    if (result.hasException) {
      throw AuthException(
        _errorMessage(result, fallback: 'Register passkey failed'),
      );
    }
    return result.data?['registerPasskey'] as bool? ?? false;
  }

  Future<List<PasskeyCredential>> passkeys() async {
    final result = await _client.query(
      QueryOptions(
        document: gql(_passkeysQuery),
        fetchPolicy: FetchPolicy.noCache,
      ),
    );
    final list = result.data?['passkeys'] as List<dynamic>? ?? const [];
    return list
        .map((e) => PasskeyCredential.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<bool> deletePasskey(String credentialId) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(_deletePasskeyMutation),
        variables: {'credentialId': credentialId},
      ),
    );
    if (result.hasException) {
      throw AuthException(
        _errorMessage(result, fallback: 'Delete passkey failed'),
      );
    }
    return result.data?['deletePasskey'] as bool? ?? false;
  }

  String _errorMessage(QueryResult result, {required String fallback}) {
    final exception = result.exception;
    if (exception == null) return fallback;
    final first = exception.graphqlErrors.isNotEmpty
        ? exception.graphqlErrors.first.message
        : null;
    final msg = first ?? fallback;
    _log.warn('Gagal: $msg', tag: 'AuthRemoteSource');
    return msg;
  }
}

@Riverpod(keepAlive: true)
AuthRemoteSource authRemoteSource(Ref ref) =>
    AuthRemoteSource(ref.watch(graphQLClientProvider));
