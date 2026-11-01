import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:dompetqu/core/logger/app_logger.dart';
import 'package:dompetqu/features/payments/domain/models/payment.dart';
import 'package:dompetqu/features/payments/view/stores/payments_repository_provider.dart';

part 'generated/failed_payments_store.g.dart';

/// Payment berstatus `failed` pada [month] — query langsung ke backend
/// (`paymentsByStatus(status: failed)`), bukan filter transaksi lokal.
///
/// Read-only: retry payment belum diekspos di UI. Provider auto-dispose,
/// jadi daftar diambil ulang setiap tab Failed dibuka atau bulan diganti.
@riverpod
Future<List<Payment>> failedPayments(Ref ref, DateTime month) async {
  final log = AppLogger.instance;
  final repository = ref.watch(paymentsRepositoryProvider);
  final payments = await repository.byStatus('failed');

  final start = DateTime(month.year, month.month);
  final end = DateTime(month.year, month.month + 1);
  final items = payments
      .where((p) => !p.createdAt.isBefore(start) && p.createdAt.isBefore(end))
      .toList()
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  log.success('payment failed dimuat (${items.length})', tag: 'PaymentsStore');
  return items;
}
