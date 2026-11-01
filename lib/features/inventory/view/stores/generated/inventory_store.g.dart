// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../inventory_store.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(InventoryStore)
final inventoryStoreProvider = InventoryStoreProvider._();

final class InventoryStoreProvider
    extends $NotifierProvider<InventoryStore, InventoryState> {
  InventoryStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inventoryStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inventoryStoreHash();

  @$internal
  @override
  InventoryStore create() => InventoryStore();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InventoryState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InventoryState>(value),
    );
  }
}

String _$inventoryStoreHash() => r'eb2cec17db2361876a749c74c3f81de1b09f2be2';

abstract class _$InventoryStore extends $Notifier<InventoryState> {
  InventoryState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<InventoryState, InventoryState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<InventoryState, InventoryState>,
              InventoryState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
