import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:cx_dompetqiu/features/payments/adapters/datasources/payments_remote_source.dart';
import 'package:cx_dompetqiu/features/payments/adapters/repositories/payments_repository_impl.dart';
import 'package:cx_dompetqiu/features/payments/domain/repositories/payments_repository.dart';

part 'generated/payments_repository_provider.g.dart';

/// DI port payment — memakai generator agar nama provider konsisten dengan
/// fitur lain. `keepAlive` dipertahankan seperti provider manual sebelumnya:
/// repository hanya membungkus `paymentsRemoteSourceProvider` (juga keepAlive)
/// dan tidak menyimpan state, jadi tidak perlu dibangun ulang tiap layar.
@Riverpod(keepAlive: true)
PaymentsRepository paymentsRepository(Ref ref) {
  return PaymentsRepositoryImpl(ref.watch(paymentsRemoteSourceProvider));
}
