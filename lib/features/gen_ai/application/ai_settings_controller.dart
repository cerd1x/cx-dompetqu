import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/logger/app_logger.dart';
import '../domain/entities/ai_settings.dart';
import 'ai_settings_repository_provider.dart';

part 'generated/ai_settings_controller.g.dart';

@Riverpod(keepAlive: true)
class AiSettingsController extends _$AiSettingsController {
  final AppLogger _log = AppLogger.instance;

  @override
  Future<AiSettings> build() async {
    _log.debug('Memuat pengaturan AI.', tag: 'AiSettingsController');
    try {
      final settings = await ref.read(aiSettingsRepositoryProvider).load();
      _log.info(
        'Pengaturan AI dimuat.',
        tag: 'AiSettingsController',
        extras: {'provider': settings.provider.name},
      );
      return settings;
    } catch (error, stackTrace) {
      _log.error(
        'Gagal memuat pengaturan AI.',
        tag: 'AiSettingsController',
        error: error.runtimeType.toString(),
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<void> setProvider(AiModelProvider provider) async {
    final repository = ref.read(aiSettingsRepositoryProvider);
    final updated = await repository.changeProvider(provider);
    if (!ref.mounted) return;
    state = AsyncValue.data(updated);
    _log.info(
      'Provider AI diganti.',
      tag: 'AiSettingsController',
      extras: {'provider': provider.name},
    );
  }

  Future<void> reload() async {
    final updated = await ref.read(aiSettingsRepositoryProvider).load();
    if (!ref.mounted) return;
    state = AsyncValue.data(updated);
    _log.debug('Pengaturan AI dimuat ulang.', tag: 'AiSettingsController');
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
    _log.info('API key AI disimpan.', tag: 'AiSettingsController');
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
    _log.info('Model AI disimpan.', tag: 'AiSettingsController');
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
    _log.info('Base URL AI disimpan.', tag: 'AiSettingsController');
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
    _log.info(
      'Custom headers AI disimpan.',
      tag: 'AiSettingsController',
      extras: {'headerCount': headers.length},
    );
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
    _log.info(
      'Opsi custom headers AI disimpan.',
      tag: 'AiSettingsController',
      extras: {'enabled': include},
    );
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
    _log.info(
      'Mode model kustom AI diperbarui.',
      tag: 'AiSettingsController',
      extras: {'enabled': useCustom},
    );
  }

  Future<void> setAiBubbleVisibility(bool visible) async {
    await ref
        .read(aiSettingsRepositoryProvider)
        .saveAiBubbleVisibility(visible);
    if (!ref.mounted) return;
    final current = state.value ?? const AiSettings();
    state = AsyncValue.data(current.copyWith(showAiBubble: visible));
    _log.info(
      'Visibilitas AI Bubble diperbarui.',
      tag: 'AiSettingsController',
      extras: {'visible': visible},
    );
  }
}
