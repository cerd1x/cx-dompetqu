import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/datasources/ai_skill_import_datasource.dart';
import '../data/datasources/ai_skills_local_datasource.dart';
import '../models/ai_skill.dart';

part 'ai_skills_repository.g.dart';

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

@Riverpod(keepAlive: true)
AiSkillsRepository aiSkillsRepository(Ref ref) {
  return LocalAiSkillsRepository(
    ref.read(aiSkillsLocalDatasourceProvider),
    ref.read(aiSkillImportDatasourceProvider),
  );
}

class LocalAiSkillsRepository implements AiSkillsRepository {
  const LocalAiSkillsRepository(this._local, this._importer);

  final AiSkillsLocalDatasource _local;
  final AiSkillImportDatasource _importer;

  @override
  Future<List<AiSkill>> loadAll() => _local.loadAll();

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
      AiSkill(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        name: normalizedName,
        instructions: normalizedInstructions,
      ),
    ];
    await _local.saveAll(updated);
    return _local.loadAll();
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
  Future<List<AiSkill>> remove(String id) async {
    final current = await _local.loadAll();
    final updated = current.where((skill) => skill.id != id).toList();
    await _local.saveAll(updated);
    return _local.loadAll();
  }
}
