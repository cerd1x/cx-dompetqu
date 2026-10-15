import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/entities/ai_settings.dart';
import '../domain/entities/ai_settings_profile_collection.dart';
import 'ai_settings_controller.dart';
import 'ai_settings_repository_provider.dart';

part 'ai_settings_profiles_controller.g.dart';

@Riverpod(keepAlive: true)
class AiSettingsProfilesController extends _$AiSettingsProfilesController {
  @override
  Future<AiSettingsProfileCollection> build() {
    return ref.read(aiSettingsRepositoryProvider).loadProfiles();
  }

  Future<void> createProfile(String name, AiSettings settings) async {
    final collection = await ref
        .read(aiSettingsRepositoryProvider)
        .createProfile(name, settings);
    if (!ref.mounted) return;
    await ref.read(aiSettingsControllerProvider.notifier).reload();
    if (!ref.mounted) return;
    state = AsyncValue.data(collection);
  }

  Future<void> activateProfile(String profileId) async {
    final collection = await ref
        .read(aiSettingsRepositoryProvider)
        .activateProfile(profileId);
    if (!ref.mounted) return;
    await ref.read(aiSettingsControllerProvider.notifier).reload();
    if (!ref.mounted) return;
    state = AsyncValue.data(collection);
  }

  Future<void> deleteProfile(String profileId) async {
    final collection = await ref
        .read(aiSettingsRepositoryProvider)
        .deleteProfile(profileId);
    if (!ref.mounted) return;
    state = AsyncValue.data(collection);
  }
}
