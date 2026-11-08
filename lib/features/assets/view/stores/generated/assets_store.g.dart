// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../assets_store.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AssetsStore)
final assetsStoreProvider = AssetsStoreProvider._();

final class AssetsStoreProvider
    extends $NotifierProvider<AssetsStore, AssetsState> {
  AssetsStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'assetsStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$assetsStoreHash();

  @$internal
  @override
  AssetsStore create() => AssetsStore();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AssetsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AssetsState>(value),
    );
  }
}

String _$assetsStoreHash() => r'393d6e43168f4e2ead05d66566bf734f5a6f72a7';

abstract class _$AssetsStore extends $Notifier<AssetsState> {
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
