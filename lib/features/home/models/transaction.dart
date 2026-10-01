import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.freezed.dart';
part 'transaction.g.dart';

/// Padanan `Transaction` di schema GraphQL (`services/domain/transactions`).
@freezed
abstract class Transaction with _$Transaction {
  const factory Transaction({
    @JsonKey(fromJson: _toId) required String id,
    @Default('income') String type,
    @Default('IDR 0') String amount,
    String? capital,
    String? description,
    String? category,
    PaymentMethod? paymentMethod,
    @JsonKey(fromJson: _toId) String? customerId,
    @Default('success') String status,
    @JsonKey(fromJson: _dateOrNow) required DateTime createdAt,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  const Transaction._();

  String get displayName => description ?? category ?? type;
}

String _toId(dynamic v) => v.toString();

DateTime _dateOrNow(dynamic v) =>
    DateTime.tryParse((v as String?) ?? '') ?? DateTime.now();

@freezed
abstract class PaymentMethod with _$PaymentMethod {
  const factory PaymentMethod({
    @Default('cash') String type,
    @JsonKey(fromJson: _paymentMethodToId) String? assetId,
  }) = _PaymentMethod;

  factory PaymentMethod.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodFromJson(json);
}

String? _paymentMethodToId(dynamic v) => v?.toString();
