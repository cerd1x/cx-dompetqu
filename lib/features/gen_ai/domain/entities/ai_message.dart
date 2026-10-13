enum AiRole { user, assistant }

class AiMessage {
  const AiMessage({required this.role, required this.text, required this.at});

  final AiRole role;
  final String text;
  final DateTime at;
}
