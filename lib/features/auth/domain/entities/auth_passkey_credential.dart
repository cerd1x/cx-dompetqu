class AuthPasskeyCredential {
  const AuthPasskeyCredential({
    required this.id,
    this.deviceName,
    this.createdAt,
  });

  final String id;
  final String? deviceName;
  final DateTime? createdAt;
}
