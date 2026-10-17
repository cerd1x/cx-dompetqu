// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_settings_profiles_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AiSettingsProfilesController)
final aiSettingsProfilesControllerProvider =
    AiSettingsProfilesControllerProvider._();

final class AiSettingsProfilesControllerProvider
    extends
        $AsyncNotifierProvider<
          AiSettingsProfilesController,
          AiSettingsProfileCollection
        > {
  AiSettingsProfilesControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiSettingsProfilesControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiSettingsProfilesControllerHash();

  @$internal
  @override
  AiSettingsProfilesController create() => AiSettingsProfilesController();
}

String _$aiSettingsProfilesControllerHash() =>
    r'8d6e99e05954d7bad170c90e7630cc7ce1358aa6';

abstract class _$AiSettingsProfilesController
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
