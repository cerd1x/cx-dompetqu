import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cx_dompetqiu/core/network/cookie_aware_client.dart';
import 'package:cx_dompetqiu/features/auth/adapters/datasources/auth_session_local_datasource.dart';
import 'package:cx_dompetqiu/features/auth/adapters/datasources/auth_remote_source.dart';
import 'package:cx_dompetqiu/features/auth/adapters/datasources/passkey_service.dart';
import 'package:cx_dompetqiu/features/auth/adapters/repositories/auth_repository_impl.dart';
import 'package:cx_dompetqiu/features/auth/domain/repositories/auth_repository.dart';
import 'package:cx_dompetqiu/features/auth/domain/usecases/auth_use_cases.dart';

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
