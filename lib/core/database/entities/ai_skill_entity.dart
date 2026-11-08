import 'package:objectbox/objectbox.dart';

/// Skill AI — {id, name, instructions}.
@Entity()
class AiSkillEntity {
  AiSkillEntity({
    this.id = 0,
    this.skillId = '',
    this.name = '',
    this.instructions = '',
  });

  int id = 0;

  @Index()
  @Unique()
  String skillId = '';
  String name = '';
  String instructions = '';
}
