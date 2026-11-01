import 'package:dompetqu/features/payments/domain/models/payment.dart';

/// Port baca payment — domain tidak tahu GraphQL/HTTP.
///
/// Padanan `PaymentRepositoryPort` di
/// `cx-services/domain/payment/core/ports/`. Hanya operasi baca yang dipakai
/// aplikasi; `retryPayment` belum diekspos karena tab Failed masih read-only.
abstract interface class PaymentsRepository {
  /// Payment milik pengguna dengan [status] tertentu (mis. `failed`).
  Future<List<Payment>> byStatus(String status);
}
