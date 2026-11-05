import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:dompetqu/core/utils/balance.dart';

part 'generated/transaction.freezed.dart';

/// Satu transaksi pada domain aplikasi — padanan data model
/// `features/transactions/adapters/models/transaction.dart` (tanpa JSON: konversi
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

  /// Nominal transaksi sebagai angka — parsing aman untuk string "ISO VALUE";
  /// format tak dikenal dianggap 0 agar ringkasan/ledger tidak error.
  ///
  /// Sebelumnya helper ini hidup di widget Order (`txAmount`), dipindah ke
  /// domain supaya store (bukan cuma UI) bisa menghitung ringkasan tanpa
  /// mengimpor layer `view/`.
  num get amountValue {
    try {
      return Balance.parse(amount).value;
    } on FormatException {
      return 0;
    }
  }
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
