// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../ai_settings_store.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AiSettingsStore)
final aiSettingsStoreProvider = AiSettingsStoreProvider._();

final class AiSettingsStoreProvider
    extends $AsyncNotifierProvider<AiSettingsStore, AiSettings> {
  AiSettingsStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiSettingsStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiSettingsStoreHash();

  @$internal
  @override
  AiSettingsStore create() => AiSettingsStore();
}

String _$aiSettingsStoreHash() => r'd393f046c3a5e7dfe5165b92f94a69c94bb13687';

abstract class _$AiSettingsStore extends $AsyncNotifier<AiSettings> {
  FutureOr<AiSettings> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AiSettings>, AiSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AiSettings>, AiSettings>,
              AsyncValue<AiSettings>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
