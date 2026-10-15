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
    final updated = await repository.changeProvider(provider);
    if (!ref.mounted) return;
    state = AsyncValue.data(updated);
  }

  Future<void> reload() async {
    final updated = await ref.read(aiSettingsRepositoryProvider).load();
    if (!ref.mounted) return;
    state = AsyncValue.data(updated);
  }

  Future<void> setApiKey(String value) async {
    final current = state.value ?? const AiSettings();
    await ref
        .read(aiSettingsRepositoryProvider)
        .saveApiKey(current.provider, value);
    if (!ref.mounted) return;
    final updated = current.copyWith(apiKey: value);
    await ref.read(aiSettingsRepositoryProvider).syncActiveProfile(updated);
    if (!ref.mounted) return;
    state = AsyncValue.data(updated);
  }

  Future<void> setModel(String value) async {
    final current = state.value ?? const AiSettings();
    await ref
        .read(aiSettingsRepositoryProvider)
        .saveModel(current.provider, value);
    if (!ref.mounted) return;
    final updated = current.copyWith(model: value);
    await ref.read(aiSettingsRepositoryProvider).syncActiveProfile(updated);
    if (!ref.mounted) return;
    state = AsyncValue.data(updated);
  }

  Future<void> setBaseUrl(String value) async {
    final current = state.value ?? const AiSettings();
    await ref
        .read(aiSettingsRepositoryProvider)
        .saveBaseUrl(current.provider, value);
    if (!ref.mounted) return;
    final updated = current.copyWith(baseUrl: value);
    await ref.read(aiSettingsRepositoryProvider).syncActiveProfile(updated);
    if (!ref.mounted) return;
    state = AsyncValue.data(updated);
  }

  Future<void> setCustomHeaders(Map<String, String> headers) async {
    final current = state.value ?? const AiSettings();
    await ref
        .read(aiSettingsRepositoryProvider)
        .saveCustomHeaders(current.provider, headers);
    if (!ref.mounted) return;
    final updated = current.copyWith(customHeaders: headers);
    await ref.read(aiSettingsRepositoryProvider).syncActiveProfile(updated);
    if (!ref.mounted) return;
    state = AsyncValue.data(updated);
  }

  Future<void> setIncludeCustomHeaders(bool include) async {
    final current = state.value ?? const AiSettings();
    await ref
        .read(aiSettingsRepositoryProvider)
        .saveIncludeCustomHeaders(current.provider, include);
    if (!ref.mounted) return;
    final updated = current.copyWith(includeCustomHeaders: include);
    await ref.read(aiSettingsRepositoryProvider).syncActiveProfile(updated);
    if (!ref.mounted) return;
    state = AsyncValue.data(updated);
  }

  Future<void> setUseCustomModel(bool useCustom) async {
    final current = state.value ?? const AiSettings();
    await ref
        .read(aiSettingsRepositoryProvider)
        .saveUseCustomModel(current.provider, useCustom);
    if (!ref.mounted) return;
    final updated = current.copyWith(useCustomModel: useCustom);
    await ref.read(aiSettingsRepositoryProvider).syncActiveProfile(updated);
    if (!ref.mounted) return;
    state = AsyncValue.data(updated);
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
