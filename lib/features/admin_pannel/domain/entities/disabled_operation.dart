class DisabledOperation {
  const DisabledOperation({
    required this.operation,
    this.reason,
    this.disabledAt,
  });

  final String operation;
  final String? reason;
  final DateTime? disabledAt;
}
