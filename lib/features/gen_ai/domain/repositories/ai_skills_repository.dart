import 'package:dompetqu/features/gen_ai/domain/entities/ai_skill.dart';
import 'package:dompetqu/features/gen_ai/domain/entities/skill_store_entry.dart';

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

  /// Menambahkan skill dari toko skills.sh; instruksi (isi `SKILL.md`) diunduh
  /// lewat [SkillStoreRepository] memakai entri yang dipilih user.
  Future<List<AiSkill>> importFromStore(SkillStoreEntry entry);

  Future<List<AiSkill>> remove(String id);
}
