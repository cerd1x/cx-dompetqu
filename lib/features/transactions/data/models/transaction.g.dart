// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Transaction _$TransactionFromJson(Map<String, dynamic> json) => _Transaction(
  id: _toId(json['id']),
  type: json['type'] as String? ?? 'income',
  amount: json['amount'] as String? ?? 'IDR 0',
  capital: json['capital'] as String?,
  description: json['description'] as String?,
  category: json['category'] as String?,
  paymentMethod: json['paymentMethod'] == null
      ? null
      : PaymentMethod.fromJson(json['paymentMethod'] as Map<String, dynamic>),
  customerId: _toId(json['customerId']),
  status: json['status'] as String? ?? 'success',
  createdAt: _dateOrNow(json['createdAt']),
);

Map<String, dynamic> _$TransactionToJson(_Transaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'amount': instance.amount,
      'capital': instance.capital,
      'description': instance.description,
      'category': instance.category,
      'paymentMethod': instance.paymentMethod,
      'customerId': instance.customerId,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_PaymentMethod _$PaymentMethodFromJson(Map<String, dynamic> json) =>
    _PaymentMethod(
      type: json['type'] as String? ?? 'cash',
      assetId: _paymentMethodToId(json['assetId']),
    );

Map<String, dynamic> _$PaymentMethodToJson(_PaymentMethod instance) =>
    <String, dynamic>{'type': instance.type, 'assetId': instance.assetId};
