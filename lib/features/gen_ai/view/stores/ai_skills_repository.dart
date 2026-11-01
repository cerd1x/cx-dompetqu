import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:dompetqu/features/gen_ai/view/stores/skill_store_repository_provider.dart';
import 'package:dompetqu/features/gen_ai/adapters/datasources/ai_skill_import_datasource.dart';
import 'package:dompetqu/features/gen_ai/adapters/datasources/ai_skills_local_datasource.dart';
import 'package:dompetqu/features/gen_ai/adapters/repositories/ai_skills_repository_impl.dart';
import 'package:dompetqu/features/gen_ai/domain/repositories/ai_skills_repository.dart';

part 'generated/ai_skills_repository.g.dart';

@Riverpod(keepAlive: true)
AiSkillsRepository aiSkillsRepository(Ref ref) {
  return LocalAiSkillsRepository(
    ref.read(aiSkillsLocalDatasourceProvider),
    ref.read(aiSkillImportDatasourceProvider),
    ref.read(skillStoreRepositoryProvider),
  );
}
