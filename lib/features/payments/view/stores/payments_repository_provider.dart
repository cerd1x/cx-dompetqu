import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dompetqu/features/payments/adapters/datasources/payments_remote_source.dart';
import 'package:dompetqu/features/payments/adapters/repositories/payments_repository_impl.dart';
import 'package:dompetqu/features/payments/domain/repositories/payments_repository.dart';

/// DI port payment — mengikuti pola `orderRepositoryProvider` (provider manual;
/// konversi ke `@riverpod` menunggu batch codegen bersama `order`).
final paymentsRepositoryProvider = Provider<PaymentsRepository>((ref) {
  return PaymentsRepositoryImpl(ref.watch(paymentsRemoteSourceProvider));
});
