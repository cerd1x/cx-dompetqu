import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/logger/app_logger.dart';
import '../domain/entities/ai_settings.dart';
import '../domain/entities/ai_settings_profile_collection.dart';
import 'ai_settings_controller.dart';
import 'ai_settings_repository_provider.dart';

part 'ai_settings_profiles_controller.g.dart';

@Riverpod(keepAlive: true)
class AiSettingsProfilesController extends _$AiSettingsProfilesController {
  final AppLogger _log = AppLogger.instance;

  @override
  Future<AiSettingsProfileCollection> build() async {
    _log.debug('Memuat profil AI.', tag: 'AiSettingsProfilesController');
    try {
      final collection = await ref
          .read(aiSettingsRepositoryProvider)
          .loadProfiles();
      _log.info(
        'Profil AI dimuat.',
        tag: 'AiSettingsProfilesController',
        extras: {'profileCount': collection.profiles.length},
      );
      return collection;
    } catch (error, stackTrace) {
      _log.error(
        'Gagal memuat profil AI.',
        tag: 'AiSettingsProfilesController',
        error: error.runtimeType.toString(),
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<void> createProfile(String name, AiSettings settings) async {
    final collection = await ref
        .read(aiSettingsRepositoryProvider)
        .createProfile(name, settings);
    if (!ref.mounted) return;
    await ref.read(aiSettingsControllerProvider.notifier).reload();
    if (!ref.mounted) return;
    state = AsyncValue.data(collection);
    _log.info(
      'Profil AI dibuat.',
      tag: 'AiSettingsProfilesController',
      extras: {'profileCount': collection.profiles.length},
    );
  }

  Future<void> activateProfile(String profileId) async {
    final collection = await ref
        .read(aiSettingsRepositoryProvider)
        .activateProfile(profileId);
    if (!ref.mounted) return;
    await ref.read(aiSettingsControllerProvider.notifier).reload();
    if (!ref.mounted) return;
    state = AsyncValue.data(collection);
    _log.info(
      'Profil AI diaktifkan.',
      tag: 'AiSettingsProfilesController',
      extras: {'profileCount': collection.profiles.length},
    );
  }

  Future<void> updateProfile(String profileId, AiSettings settings) async {
    final collection = await ref
        .read(aiSettingsRepositoryProvider)
        .updateProfile(profileId, settings);
    if (!ref.mounted) return;
    await ref.read(aiSettingsControllerProvider.notifier).reload();
    if (!ref.mounted) return;
    state = AsyncValue.data(collection);
    _log.info(
      'Profil AI diperbarui.',
      tag: 'AiSettingsProfilesController',
      extras: {'profileCount': collection.profiles.length},
    );
  }

  Future<void> deleteProfile(String profileId) async {
    final collection = await ref
        .read(aiSettingsRepositoryProvider)
        .deleteProfile(profileId);
    if (!ref.mounted) return;
    state = AsyncValue.data(collection);
    _log.info(
      'Profil AI dihapus.',
      tag: 'AiSettingsProfilesController',
      extras: {'profileCount': collection.profiles.length},
    );
  }
}
