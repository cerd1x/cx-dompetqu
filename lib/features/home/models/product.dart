import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

/// Padanan `Product` di schema GraphQL (`services/domain/products`).
@freezed
abstract class Product with _$Product {
  const Product._();

  const factory Product({
    @JsonKey(fromJson: _toId) String? id,
    required String name,
    String? description,
    @Default(0) num price,
    num? capital,
    num? margin,
    @Default('IDR') String currency,
    @JsonKey(fromJson: _stockFromJson) @Default(0) int stock,
    @Default(false) bool trackStock,
    @JsonKey(fromJson: _date) DateTime? createdAt,
    @JsonKey(fromJson: _date) DateTime? updatedAt,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  bool get isLowStock => trackStock && stock < 5;

  String get stockLabel => trackStock ? '$stock' : 'Unlimited';
}

String? _toId(dynamic v) => v?.toString();

int _stockFromJson(dynamic v) => (v as num?)?.toInt() ?? 0;

DateTime? _date(dynamic v) => v is String ? DateTime.tryParse(v) : null;
