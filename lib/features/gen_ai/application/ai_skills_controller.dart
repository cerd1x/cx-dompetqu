import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/logger/app_logger.dart';
import '../domain/entities/ai_skill.dart';
import '../domain/entities/skill_store_entry.dart';
import '../domain/repositories/ai_skills_repository.dart';
import '../repositories/ai_skills_repository.dart';

part 'generated/ai_skills_controller.g.dart';

@Riverpod(keepAlive: true)
class AiSkillsController extends _$AiSkillsController {
  final AppLogger _log = AppLogger.instance;
  bool _mutationInFlight = false;

  @override
  Future<List<AiSkill>> build() async {
    _log.debug('Memuat skill AI.', tag: 'AiSkillsController');
    try {
      final skills = await ref.read(aiSkillsRepositoryProvider).loadAll();
      _log.info(
        'Skill AI dimuat.',
        tag: 'AiSkillsController',
        extras: {'skillCount': skills.length},
      );
      return skills;
    } catch (error, stackTrace) {
      _log.error(
        'Gagal memuat skill AI.',
        tag: 'AiSkillsController',
        error: error.runtimeType.toString(),
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<void> create({
    required String name,
    required String instructions,
  }) async {
    await _mutate(
      (repository) => repository.create(name: name, instructions: instructions),
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

  /// Menambahkan skill dari toko skills.sh (mode scrape atau proxy).
  Future<void> importFromStore(SkillStoreEntry entry) async {
    await _mutate((repository) => repository.importFromStore(entry));
  }

  Future<void> remove(String id) async {
    await _mutate((repository) => repository.remove(id));
  }

  Future<void> _mutate(
    Future<List<AiSkill>> Function(AiSkillsRepository repository) operation,
  ) async {
    if (_mutationInFlight) {
      _log.warn(
        'Perubahan skill AI ditolak karena mutasi lain sedang berjalan.',
        tag: 'AiSkillsController',
      );
      throw StateError('Perubahan skill sedang diproses.');
    }
    _mutationInFlight = true;
    _log.debug('Memulai perubahan skill AI.', tag: 'AiSkillsController');
    try {
      final updated = await operation(ref.read(aiSkillsRepositoryProvider));
      if (!ref.mounted) return;
      state = AsyncValue.data(updated);
      _log.info(
        'Perubahan skill AI selesai.',
        tag: 'AiSkillsController',
        extras: {'skillCount': updated.length},
      );
    } catch (error, stackTrace) {
      _log.error(
        'Perubahan skill AI gagal.',
        tag: 'AiSkillsController',
        error: error.runtimeType.toString(),
        stackTrace: stackTrace,
      );
      rethrow;
    } finally {
      if (ref.mounted) {
        _mutationInFlight = false;
      }
    }
  }
}
