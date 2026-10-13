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
}
