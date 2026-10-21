// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../ai_settings_profiles_store.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AiSettingsProfilesStore)
final aiSettingsProfilesStoreProvider = AiSettingsProfilesStoreProvider._();

final class AiSettingsProfilesStoreProvider
    extends
        $AsyncNotifierProvider<
          AiSettingsProfilesStore,
          AiSettingsProfileCollection
        > {
  AiSettingsProfilesStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiSettingsProfilesStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiSettingsProfilesStoreHash();

  @$internal
  @override
  AiSettingsProfilesStore create() => AiSettingsProfilesStore();
}

String _$aiSettingsProfilesStoreHash() =>
    r'072a6970b78bae2028317c9d09fa324929366b22';

abstract class _$AiSettingsProfilesStore
    extends $AsyncNotifier<AiSettingsProfileCollection> {
  FutureOr<AiSettingsProfileCollection> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<AiSettingsProfileCollection>,
              AiSettingsProfileCollection
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<AiSettingsProfileCollection>,
                AiSettingsProfileCollection
              >,
              AsyncValue<AiSettingsProfileCollection>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
