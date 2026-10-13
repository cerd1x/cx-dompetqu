import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/entities/ai_settings.dart';
import 'ai_settings_repository_provider.dart';

part 'ai_settings_controller.g.dart';

@Riverpod(keepAlive: true)
class AiSettingsController extends _$AiSettingsController {
  @override
  Future<AiSettings> build() => ref.read(aiSettingsRepositoryProvider).load();

  Future<void> setApiKey(String value) async {
    await ref.read(aiSettingsRepositoryProvider).saveApiKey(value);
    if (!ref.mounted) return;
    final current = state.value ?? const AiSettings();
    state = AsyncValue.data(current.copyWith(apiKey: value));
  }

  Future<void> setModel(String value) async {
    await ref.read(aiSettingsRepositoryProvider).saveModel(value);
    if (!ref.mounted) return;
    final current = state.value ?? const AiSettings();
    state = AsyncValue.data(current.copyWith(model: value));
  }
}
