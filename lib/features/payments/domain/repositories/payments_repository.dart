import 'package:cx_dompetqiu/features/payments/domain/models/payment.dart';

/// Port baca payment — domain tidak tahu GraphQL/HTTP.
///
/// Padanan `PaymentRepositoryPort` di
/// `cx-services/domain/payment/core/ports/`. Operasi tulis dibatasi pada
/// retry (`retryPayment`); `processPayment` belum dipakai layar mana pun.
abstract interface class PaymentsRepository {
  /// Payment milik pengguna dengan [status] tertentu (mis. `failed`).
  Future<List<Payment>> byStatus(String status);

  /// Coba ulang payment [id] dan kembalikan state terbarunya.
  Future<Payment> retry(String id);
}
