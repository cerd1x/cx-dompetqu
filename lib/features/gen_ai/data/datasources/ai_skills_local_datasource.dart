import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/ai_skill.dart';

part 'ai_skills_local_datasource.g.dart';

abstract interface class AiSkillsLocalDatasource {
  Future<List<AiSkill>> loadAll();
  Future<void> saveAll(List<AiSkill> skills);
}

@Riverpod(keepAlive: true)
AiSkillsLocalDatasource aiSkillsLocalDatasource(Ref ref) {
  return SharedPreferencesAiSkillsLocalDatasource();
}

class SharedPreferencesAiSkillsLocalDatasource
    implements AiSkillsLocalDatasource {
  static const _storageKey = 'ai_skills';

  @override
  Future<List<AiSkill>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_storageKey);
    if (stored == null) return const [];
    final decoded = jsonDecode(stored);
    if (decoded is! List) {
      throw const FormatException('Data skill tersimpan tidak valid.');
    }
    return decoded
        .map(
          (entry) => AiSkill.fromJson(
            Map<String, dynamic>.from(entry as Map),
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<void> saveAll(List<AiSkill> skills) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = await prefs.setString(
      _storageKey,
      jsonEncode(skills.map((skill) => skill.toJson()).toList()),
    );
    if (!saved) {
      throw StateError('Skill tidak berhasil disimpan.');
    }
  }
}
