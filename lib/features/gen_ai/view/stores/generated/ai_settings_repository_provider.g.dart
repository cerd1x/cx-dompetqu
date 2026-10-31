// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../ai_settings_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(aiSettingsRepository)
final aiSettingsRepositoryProvider = AiSettingsRepositoryProvider._();

final class AiSettingsRepositoryProvider
    extends
        $FunctionalProvider<
          AiSettingsRepository,
          AiSettingsRepository,
          AiSettingsRepository
        >
    with $Provider<AiSettingsRepository> {
  AiSettingsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiSettingsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiSettingsRepositoryHash();

  @$internal
  @override
  $ProviderElement<AiSettingsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AiSettingsRepository create(Ref ref) {
    return aiSettingsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiSettingsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiSettingsRepository>(value),
    );
  }
}

String _$aiSettingsRepositoryHash() =>
    r'9b5f2042a2ec6d3c7fdfd58ba973274dc4043e04';

@ProviderFor(openRouterModelRepository)
final openRouterModelRepositoryProvider = OpenRouterModelRepositoryProvider._();

final class OpenRouterModelRepositoryProvider
    extends
        $FunctionalProvider<
          OpenRouterModelRepository,
          OpenRouterModelRepository,
          OpenRouterModelRepository
        >
    with $Provider<OpenRouterModelRepository> {
  OpenRouterModelRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'openRouterModelRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$openRouterModelRepositoryHash();

  @$internal
  @override
  $ProviderElement<OpenRouterModelRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OpenRouterModelRepository create(Ref ref) {
    return openRouterModelRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OpenRouterModelRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OpenRouterModelRepository>(value),
    );
  }
}

String _$openRouterModelRepositoryHash() =>
    r'e641fad6251516189be4396f12ac608f29632d82';
