import '../entities/ai_skill.dart';

abstract interface class AiSkillsRepository {
  Future<List<AiSkill>> loadAll();
  Future<List<AiSkill>> create({
    required String name,
    required String instructions,
  });
  Future<List<AiSkill>> importFromUrl({
    required String name,
    required String url,
  });
  Future<List<AiSkill>> remove(String id);
}
