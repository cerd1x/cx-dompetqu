class Asset {
  const Asset({
    required this.id,
    required this.name,
    this.type = 'ewallet',
    this.balance = 'IDR 0',
  });

  final String id;
  final String name;
  final String type;
  final String balance;
}
