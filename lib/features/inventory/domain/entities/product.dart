class Product {
  const Product({
    this.id,
    required this.name,
    this.description,
    this.price = 0,
    this.capital,
    this.margin,
    this.currency = 'IDR',
    this.stock = 0,
    this.trackStock = false,
    this.createdAt,
    this.updatedAt,
  });

  final String? id;
  final String name;
  final String? description;
  final num price;
  final num? capital;
  final num? margin;
  final String currency;
  final int stock;
  final bool trackStock;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get isLowStock => trackStock && stock < 5;

  String get stockLabel => trackStock ? '$stock' : 'Unlimited';
}
