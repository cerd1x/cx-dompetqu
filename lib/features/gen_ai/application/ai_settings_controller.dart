import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/entities/ai_settings.dart';
import 'ai_settings_repository_provider.dart';

part 'ai_settings_controller.g.dart';

@Riverpod(keepAlive: true)
class AiSettingsController extends _$AiSettingsController {
  @override
  Future<AiSettings> build() => ref.read(aiSettingsRepositoryProvider).load();

  Future<void> setProvider(AiModelProvider provider) async {
    final repository = ref.read(aiSettingsRepositoryProvider);
    await repository.saveProvider(provider);
    final updated = await repository.load();
    if (!ref.mounted) return;
    state = AsyncValue.data(updated);
  }

  Future<void> setApiKey(String value) async {
    final current = state.value ?? const AiSettings();
    await ref
        .read(aiSettingsRepositoryProvider)
        .saveApiKey(current.provider, value);
    if (!ref.mounted) return;
    state = AsyncValue.data(current.copyWith(apiKey: value));
  }

  Future<void> setModel(String value) async {
    final current = state.value ?? const AiSettings();
    await ref
        .read(aiSettingsRepositoryProvider)
        .saveModel(current.provider, value);
    if (!ref.mounted) return;
    state = AsyncValue.data(current.copyWith(model: value));
  }

  Future<void> setBaseUrl(String value) async {
    final current = state.value ?? const AiSettings();
    await ref
        .read(aiSettingsRepositoryProvider)
        .saveBaseUrl(current.provider, value);
    if (!ref.mounted) return;
    state = AsyncValue.data(current.copyWith(baseUrl: value));
  }

  Future<void> setAiBubbleVisibility(bool visible) async {
    await ref
        .read(aiSettingsRepositoryProvider)
        .saveAiBubbleVisibility(visible);
    if (!ref.mounted) return;
    final current = state.value ?? const AiSettings();
    state = AsyncValue.data(current.copyWith(showAiBubble: visible));
  }
}
