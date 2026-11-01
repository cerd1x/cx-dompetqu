import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/ai_skill.freezed.dart';

/// Satu skill yang terpasang/tersedia untuk agen AI.
@freezed
abstract class AiSkill with _$AiSkill {
  const factory AiSkill({
    required String id,
    required String name,
    required String instructions,
  }) = _AiSkill;

  const AiSkill._();
}
