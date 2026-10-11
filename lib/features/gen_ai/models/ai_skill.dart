class AiSkill {
  const AiSkill({
    required this.id,
    required this.name,
    required this.instructions,
  });

  final String id;
  final String name;
  final String instructions;

  factory AiSkill.fromJson(Map<String, dynamic> json) {
    return AiSkill(
      id: json['id'] as String,
      name: json['name'] as String,
      instructions: json['instructions'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'instructions': instructions,
  };
}
