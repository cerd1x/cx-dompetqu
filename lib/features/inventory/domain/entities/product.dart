import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/product.freezed.dart';

/// Satu produk inventori — padanan data model
/// `features/inventory/data/models/product.dart` (tanpa JSON: konversi ada di
/// mapper/repository, bukan di domain).
@freezed
abstract class Product with _$Product {
  const factory Product({
    String? id,
    required String name,
    String? description,
    @Default(0) num price,
    num? capital,
    num? margin,
    @Default('IDR') String currency,
    @Default(0) int stock,
    @Default(false) bool trackStock,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Product;

  const Product._();

  bool get isLowStock => trackStock && stock < 5;

  String get stockLabel => trackStock ? '$stock' : 'Unlimited';
}
