import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/payment.freezed.dart';

/// Satu pembayaran pada domain — padanan `Payment` di
/// `cx-services/domain/payment/core/model/payment.model.ts`.
///
/// Berbeda dari [Transaction]: payment mencatat status gerbang pembayaran
/// (`pending`/`processing`/`completed`/`failed`/`refunded`/`cancelled`) dan
/// punya kebijakan retry sendiri (`retryCount`/`maxRetries`), sedangkan
/// transaksi mencatat laporan keuangan.
@freezed
abstract class Payment with _$Payment {
  const factory Payment({
    required String id,
    String? invoiceId,
    required double amount,
    @Default('IDR') String currency,
    @Default('cash') String method,
    @Default('pending') String status,
    String? gatewayRef,
    String? description,
    @Default(0) int retryCount,
    @Default(3) int maxRetries,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _Payment;

  const Payment._();

  /// Masih bisa di-retry sesuai kebijakan backend (`retry-policy.vo.ts`).
  bool get canRetry => retryCount < maxRetries;

  /// Judul baris: deskripsi payment, atau id sebagai fallback.
  String get displayName => description ?? 'Payment $id';
}
