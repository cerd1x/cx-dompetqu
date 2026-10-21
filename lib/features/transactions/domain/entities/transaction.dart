import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/transaction.freezed.dart';

/// Satu transaksi pada domain aplikasi — padanan data model
/// `features/transactions/data/models/transaction.dart` (tanpa JSON: konversi
/// ada di mapper/repository, bukan di domain).
@freezed
abstract class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    @Default('income') String type,
    @Default('IDR 0') String amount,
    String? capital,
    String? description,
    String? category,
    PaymentMethod? paymentMethod,
    String? customerId,
    @Default('success') String status,
    // Status pembayaran transaksi (`paid`/`unpaid`) — enum
    // `TransactionPaymentStatus` di backend; default DB `unpaid`.
    @Default('unpaid') String paymentStatus,
    required DateTime createdAt,
  }) = _Transaction;

  const Transaction._();

  String get displayName => description ?? category ?? type;
}

/// Metode pembayaran pada transaksi — `type` adalah wire value backend dan
/// WAJIB salah satu nilai dari enum `PaymentMethodType`
/// (`domain/entities/payment_method_type.dart`), yang juga memuat label UI.
@freezed
abstract class PaymentMethod with _$PaymentMethod {
  const factory PaymentMethod({@Default('cash') String type, String? assetId}) =
      _PaymentMethod;

  const PaymentMethod._();
}
