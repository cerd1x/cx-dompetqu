import 'package:get_it/get_it.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:cx_dompetqiu/core/database/entities/ai_skill_entity.dart';
import 'package:cx_dompetqiu/core/database/objectbox_database.dart';
import 'package:cx_dompetqiu/features/gen_ai/adapters/models/ai_skill.dart';

part 'generated/ai_skills_local_datasource.g.dart';

abstract interface class AiSkillsLocalDatasource {
  Future<List<AiSkill>> loadAll();
  Future<void> saveAll(List<AiSkill> skills);
}

@Riverpod(keepAlive: true)
AiSkillsLocalDatasource aiSkillsLocalDatasource(Ref ref) {
  return ObjectBoxAiSkillsLocalDatasource();
}

class ObjectBoxAiSkillsLocalDatasource implements AiSkillsLocalDatasource {
  ObjectBoxDatabase get _db => GetIt.instance.get<ObjectBoxDatabase>();

  @override
  Future<List<AiSkill>> loadAll() async {
    final entities = _db.aiSkillBox.getAll();
    return entities
        .map(
          (e) => AiSkill(
            id: e.skillId,
            name: e.name,
            instructions: e.instructions,
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<void> saveAll(List<AiSkill> skills) async {
    _db.aiSkillBox.removeAll();
    final entities = skills
        .map(
          (s) => AiSkillEntity(
            skillId: s.id,
            name: s.name,
            instructions: s.instructions,
          ),
        )
        .toList();
    _db.aiSkillBox.putMany(entities);
  }
}
