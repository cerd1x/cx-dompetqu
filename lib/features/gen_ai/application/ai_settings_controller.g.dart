// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_settings_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AiSettingsController)
final aiSettingsControllerProvider = AiSettingsControllerProvider._();

final class AiSettingsControllerProvider
    extends $AsyncNotifierProvider<AiSettingsController, AiSettings> {
  AiSettingsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiSettingsControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiSettingsControllerHash();

  @$internal
  @override
  AiSettingsController create() => AiSettingsController();
}

String _$aiSettingsControllerHash() =>
    r'202e07dd875f639c9bc045b52eb8ee8bc516f234';

abstract class _$AiSettingsController extends $AsyncNotifier<AiSettings> {
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
