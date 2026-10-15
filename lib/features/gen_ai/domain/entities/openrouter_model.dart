class OpenRouterModel {
  const OpenRouterModel({
    required this.id,
    required this.name,
    this.contextLength,
  });

  final String id;
  final String name;
  final int? contextLength;
}
