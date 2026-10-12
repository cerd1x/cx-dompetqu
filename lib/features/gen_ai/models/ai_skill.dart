import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_skill.freezed.dart';
part 'ai_skill.g.dart';

/// Satu skill AI — instruksi khusus yang disimpan per user. Dipakai
/// controller, repository, dan datasource (persist JSON di SharedPreferences).
@freezed
abstract class AiSkill with _$AiSkill {
  const factory AiSkill({
    required String id,
    required String name,
    required String instructions,
  }) = _AiSkill;

  factory AiSkill.fromJson(Map<String, dynamic> json) =>
      _$AiSkillFromJson(json);
}
