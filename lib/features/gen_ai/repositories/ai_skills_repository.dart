import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/datasources/ai_skill_import_datasource.dart';
import '../data/datasources/ai_skills_local_datasource.dart';
import '../data/repositories/ai_skills_repository_impl.dart';
import '../domain/repositories/ai_skills_repository.dart';

part 'ai_skills_repository.g.dart';

@Riverpod(keepAlive: true)
AiSkillsRepository aiSkillsRepository(Ref ref) {
  return LocalAiSkillsRepository(
    ref.read(aiSkillsLocalDatasourceProvider),
    ref.read(aiSkillImportDatasourceProvider),
  );
}
