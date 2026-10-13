import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/cookie_aware_client.dart';
import '../data/datasources/auth_session_local_datasource.dart';
import '../data/auth_remote_source.dart';
import '../data/passkey_service.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/auth_use_cases.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.watch(authRemoteSourceProvider),
    ref.watch(passkeyServiceProvider),
    CookieAuthSessionLocalDataSource(ref.watch(cookieAwareClientProvider)),
  );
});

final authUseCasesProvider = Provider<AuthUseCases>((ref) {
  return AuthUseCases(ref.watch(authRepositoryProvider));
});
