import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:dompetqu/core/logger/app_logger.dart';
import 'package:dompetqu/features/gen_ai/domain/entities/ai_settings.dart';
import 'package:dompetqu/features/gen_ai/domain/entities/ai_settings_profile_collection.dart';
import 'ai_settings_store.dart';
import 'ai_settings_repository_provider.dart';

part 'generated/ai_settings_profiles_store.g.dart';

@Riverpod(keepAlive: true)
class AiSettingsProfilesStore extends _$AiSettingsProfilesStore {
  final AppLogger _log = AppLogger.instance;

  @override
  Future<AiSettingsProfileCollection> build() async {
    _log.debug('Memuat profil AI.', tag: 'AiSettingsProfilesStore');
    try {
      final collection = await ref
          .read(aiSettingsRepositoryProvider)
          .loadProfiles();
      _log.info(
        'Profil AI dimuat.',
        tag: 'AiSettingsProfilesStore',
        extras: {'profileCount': collection.profiles.length},
      );
      return collection;
    } catch (error, stackTrace) {
      _log.error(
        'Gagal memuat profil AI.',
        tag: 'AiSettingsProfilesStore',
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
    await ref.read(aiSettingsStoreProvider.notifier).reload();
    if (!ref.mounted) return;
    state = AsyncValue.data(collection);
    _log.info(
      'Profil AI dibuat.',
      tag: 'AiSettingsProfilesStore',
      extras: {'profileCount': collection.profiles.length},
    );
  }

  Future<void> activateProfile(String profileId) async {
    final collection = await ref
        .read(aiSettingsRepositoryProvider)
        .activateProfile(profileId);
    if (!ref.mounted) return;
    await ref.read(aiSettingsStoreProvider.notifier).reload();
    if (!ref.mounted) return;
    state = AsyncValue.data(collection);
    _log.info(
      'Profil AI diaktifkan.',
      tag: 'AiSettingsProfilesStore',
      extras: {'profileCount': collection.profiles.length},
    );
  }

  Future<void> updateProfile(String profileId, AiSettings settings) async {
    final collection = await ref
        .read(aiSettingsRepositoryProvider)
        .updateProfile(profileId, settings);
    if (!ref.mounted) return;
    await ref.read(aiSettingsStoreProvider.notifier).reload();
    if (!ref.mounted) return;
    state = AsyncValue.data(collection);
    _log.info(
      'Profil AI diperbarui.',
      tag: 'AiSettingsProfilesStore',
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
      tag: 'AiSettingsProfilesStore',
      extras: {'profileCount': collection.profiles.length},
    );
  }
}
