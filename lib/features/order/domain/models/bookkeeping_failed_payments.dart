import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/bookkeeping_failed_payments.freezed.dart';

/// Hasil query `bookkeepingFailedPayments`.
@freezed
abstract class BookkeepingFailedPaymentsResult
    with _$BookkeepingFailedPaymentsResult {
  const factory BookkeepingFailedPaymentsResult({
    required String month,
    required List<BookkeepingFailedPayment> payments,
    required int totalCount,
    required int retryableCount,
  }) = _BookkeepingFailedPaymentsResult;
}

/// Payment berstatus failed dengan info retry.
@freezed
abstract class BookkeepingFailedPayment with _$BookkeepingFailedPayment {
  const factory BookkeepingFailedPayment({
    required String id,
    required String amount,
    required String method,
    required String status,
    String? gatewayRef,
    String? description,
    required int retryCount,
    required int maxRetries,
    required bool canRetry,
    String? lastError,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _BookkeepingFailedPayment;
}
