import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dompetqu/core/network/cookie_aware_client.dart';
import 'package:dompetqu/features/auth/adapters/datasources/auth_session_local_datasource.dart';
import 'package:dompetqu/features/auth/adapters/auth_remote_source.dart';
import 'package:dompetqu/features/auth/adapters/passkey_service.dart';
import 'package:dompetqu/features/auth/adapters/repositories/auth_repository_impl.dart';
import 'package:dompetqu/features/auth/domain/repositories/auth_repository.dart';
import 'package:dompetqu/features/auth/domain/usecases/auth_use_cases.dart';

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
