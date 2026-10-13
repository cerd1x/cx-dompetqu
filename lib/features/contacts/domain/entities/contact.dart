class Contact {
  const Contact({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.phones = const [],
    this.group,
    this.avatar,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final String? email;
  final String? phone;
  final List<String> phones;
  final String? group;
  final String? avatar;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}
