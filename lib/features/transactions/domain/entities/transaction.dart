class Transaction {
  const Transaction({
    required this.id,
    this.type = 'income',
    this.amount = 'IDR 0',
    this.capital,
    this.description,
    this.category,
    this.paymentMethod,
    this.customerId,
    this.status = 'success',
    required this.createdAt,
  });

  final String id;
  final String type;
  final String amount;
  final String? capital;
  final String? description;
  final String? category;
  final PaymentMethod? paymentMethod;
  final String? customerId;
  final String status;
  final DateTime createdAt;

  String get displayName => description ?? category ?? type;
}

class PaymentMethod {
  const PaymentMethod({this.type = 'cash', this.assetId});

  final String type;
  final String? assetId;
}
