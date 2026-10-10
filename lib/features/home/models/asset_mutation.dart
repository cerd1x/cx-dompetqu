class AssetMutation {
  const AssetMutation({
    required this.id,
    required this.type,
    required this.amount,
    required this.currency,
    required this.balanceBefore,
    required this.balanceAfter,
    required this.description,
    required this.createdAt,
  });

  final String id;
  final String type;
  final String amount;
  final String currency;
  final String balanceBefore;
  final String balanceAfter;
  final String? description;
  final DateTime? createdAt;

  factory AssetMutation.fromJson(Map<String, dynamic> json) => AssetMutation(
    id: json['id'] as String,
    type: json['type'] as String,
    amount: json['amount']?.toString() ?? '',
    currency: json['currency'] as String? ?? '',
    balanceBefore: json['balanceBefore']?.toString() ?? '',
    balanceAfter: json['balanceAfter']?.toString() ?? '',
    description: json['description'] as String?,
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String),
  );
}
