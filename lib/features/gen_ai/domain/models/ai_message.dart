import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/ai_message.freezed.dart';

enum AiRole { user, assistant }

/// Satu pesan pada percakapan dengan AI.
@freezed
abstract class AiMessage with _$AiMessage {
  const factory AiMessage({
    required AiRole role,
    required String text,
    required DateTime at,
  }) = _AiMessage;

  const AiMessage._();
}
