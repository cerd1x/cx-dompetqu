import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/payment.freezed.dart';

/// Satu pembayaran pada domain — padanan `Payment` di
/// `cx-services/domain/payment/core/model/payment.model.ts`.
///
/// Berbeda dari [Transaction]: payment mencatat status gerbang pembayaran
/// (`pending`/`processing`/`completed`/`failed`/`refunded`/`cancelled`) dan
/// punya kebijakan retry sendiri (`retryCount`/`maxRetries`), sedangkan
/// transaksi mencatat laporan keuangan.
///
/// [metadata] menyimpan detail tambahan dari backend (`PaymentMetadata` di
/// `payment.gql`), termasuk `lastError` dari gateway — satu-satunya sumber
/// pesan kegagalan asli karena `Payment` tidak punya kolom error sendiri.
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
    PaymentMetadata? metadata,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _Payment;

  const Payment._();

  /// Masih bisa di-retry sesuai kebijakan backend (`retry-policy.vo.ts`).
  bool get canRetry => retryCount < maxRetries;

  /// Judul baris: deskripsi payment, atau id sebagai fallback.
  String get displayName => description ?? 'Payment $id';
}

/// Metadata payment — cerminan `PaymentMetadata` di
/// `cx-services/domain/payment/adapters/driving/graphql/payment.gql`.
///
/// Semua field nullable: backend hanya mengisi yang relevan (mis. `lastError`
/// hanya terisi saat gateway menolak transaksi, `nextRetryDelayMs` hanya ada
/// ketika retry dijadwalkan).
@freezed
abstract class PaymentMetadata with _$PaymentMetadata {
  const factory PaymentMetadata({
    /// Jenis proses pembayaran (`general`/`OrderProductSale`).
    String? paymentType,

    /// Asset yang di-charge pada proses pembayaran (Float di GraphQL).
    double? assetId,

    /// Pesan kegagalan dari gateway — dipakai layar detail untuk penyebab.
    String? lastError,

    /// Jeda sebelum retry berikutnya (backoff `retry-policy.vo.ts`).
    double? nextRetryDelayMs,
  }) = _PaymentMetadata;
}
