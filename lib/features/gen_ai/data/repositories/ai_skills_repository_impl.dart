import '../datasources/ai_skill_import_datasource.dart';
import '../datasources/ai_skills_local_datasource.dart';
import '../../domain/entities/ai_skill.dart';
import '../../domain/entities/skill_store_entry.dart';
import '../../domain/repositories/ai_skills_repository.dart';
import '../../domain/repositories/skill_store_repository.dart';
import '../mappers/gen_ai_model_mapper.dart';
import '../../models/ai_skill.dart' as data;

class LocalAiSkillsRepository implements AiSkillsRepository {
  const LocalAiSkillsRepository(this._local, this._importer, this._store);

  final AiSkillsLocalDatasource _local;
  final AiSkillImportDatasource _importer;
  final SkillStoreRepository _store;

  @override
  Future<List<AiSkill>> loadAll() async =>
      (await _local.loadAll()).map((model) => model.toEntity()).toList();

  @override
  Future<List<AiSkill>> create({
    required String name,
    required String instructions,
  }) async {
    final normalizedName = name.trim();
    final normalizedInstructions = instructions.trim();
    if (normalizedName.isEmpty || normalizedInstructions.isEmpty) {
      throw const FormatException('Nama dan instruksi skill wajib diisi.');
    }
    final current = await _local.loadAll();
    final updated = [
      ...current,
      data.AiSkill(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        name: normalizedName,
        instructions: normalizedInstructions,
      ),
    ];
    await _local.saveAll(updated);
    return loadAll();
  }

  @override
  Future<List<AiSkill>> importFromUrl({
    required String name,
    required String url,
  }) async {
    final normalizedName = name.trim();
    if (normalizedName.isEmpty) {
      throw const FormatException('Nama skill wajib diisi.');
    }
    final uri = Uri.tryParse(url.trim());
    if (uri == null ||
        (uri.scheme != 'http' && uri.scheme != 'https') ||
        uri.host.isEmpty) {
      throw const FormatException('URL tidak valid. Gunakan URL http/https.');
    }
    final instructions = await _importer.fetchText(uri);
    return create(name: normalizedName, instructions: instructions);
  }

  @override
  Future<List<AiSkill>> importFromStore(SkillStoreEntry entry) async {
    final instructions = await _store.loadInstructions(entry);
    return create(name: entry.name, instructions: instructions);
  }

  @override
  Future<List<AiSkill>> remove(String id) async {
    final current = await _local.loadAll();
    await _local.saveAll(current.where((skill) => skill.id != id).toList());
    return loadAll();
  }
}
