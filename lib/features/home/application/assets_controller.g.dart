// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assets_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AssetsController)
final assetsControllerProvider = AssetsControllerProvider._();

final class AssetsControllerProvider
    extends $NotifierProvider<AssetsController, AssetsState> {
  AssetsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'assetsControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$assetsControllerHash();

  @$internal
  @override
  AssetsController create() => AssetsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AssetsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AssetsState>(value),
    );
  }
}

String _$assetsControllerHash() => r'09a61f2087104de289bf31126c8ed0f04c662436';

abstract class _$AssetsController extends $Notifier<AssetsState> {
  AssetsState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AssetsState, AssetsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AssetsState, AssetsState>,
              AssetsState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
