// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Product _$ProductFromJson(Map<String, dynamic> json) => _Product(
  id: _toId(json['id']),
  name: json['name'] as String,
  description: json['description'] as String?,
  price: json['price'] as num? ?? 0,
  capital: json['capital'] as num?,
  margin: json['margin'] as num?,
  currency: json['currency'] as String? ?? 'IDR',
  stock: json['stock'] == null ? 0 : _stockFromJson(json['stock']),
  trackStock: json['trackStock'] as bool? ?? false,
  createdAt: _date(json['createdAt']),
  updatedAt: _date(json['updatedAt']),
);

Map<String, dynamic> _$ProductToJson(_Product instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'price': instance.price,
  'capital': instance.capital,
  'margin': instance.margin,
  'currency': instance.currency,
  'stock': instance.stock,
  'trackStock': instance.trackStock,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
