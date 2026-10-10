import 'package:flutter/material.dart';

/// Peran pengirim pesan di percakapan AI.
enum AiRole { user, assistant }

/// Satu pesan dalam percakapan AI — dipakai controller & remote source
/// (Gemini) untuk membangun konteks percakapan.
@immutable
class AiMessage {
  const AiMessage({required this.role, required this.text, required this.at});

  final AiRole role;
  final String text;
  final DateTime at;
}
