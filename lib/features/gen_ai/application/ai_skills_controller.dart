import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/ai_skill.dart';
import '../repositories/ai_skills_repository.dart';

part 'ai_skills_controller.g.dart';

@Riverpod(keepAlive: true)
class AiSkillsController extends _$AiSkillsController {
  bool _mutationInFlight = false;

  @override
  Future<List<AiSkill>> build() {
    return ref.read(aiSkillsRepositoryProvider).loadAll();
  }

  Future<void> create({
    required String name,
    required String instructions,
  }) async {
    await _mutate(
      (repository) => repository.create(
        name: name,
        instructions: instructions,
      ),
    );
  }

  Future<void> importFromUrl({
    required String name,
    required String url,
  }) async {
    await _mutate(
      (repository) => repository.importFromUrl(name: name, url: url),
    );
  }

  Future<void> remove(String id) async {
    await _mutate((repository) => repository.remove(id));
  }

  Future<void> _mutate(
    Future<List<AiSkill>> Function(AiSkillsRepository repository) operation,
  ) async {
    if (_mutationInFlight) {
      throw StateError('Perubahan skill sedang diproses.');
    }
    _mutationInFlight = true;
    try {
      final updated = await operation(ref.read(aiSkillsRepositoryProvider));
      if (!ref.mounted) return;
      state = AsyncValue.data(updated);
    } finally {
      if (ref.mounted) {
        _mutationInFlight = false;
      }
    }
  }
}
