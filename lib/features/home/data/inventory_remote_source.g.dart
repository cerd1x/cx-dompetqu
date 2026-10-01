// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_remote_source.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(inventoryRemoteSource)
final inventoryRemoteSourceProvider = InventoryRemoteSourceProvider._();

final class InventoryRemoteSourceProvider
    extends
        $FunctionalProvider<
          InventoryRemoteSource,
          InventoryRemoteSource,
          InventoryRemoteSource
        >
    with $Provider<InventoryRemoteSource> {
  InventoryRemoteSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inventoryRemoteSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inventoryRemoteSourceHash();

  @$internal
  @override
  $ProviderElement<InventoryRemoteSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InventoryRemoteSource create(Ref ref) {
    return inventoryRemoteSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InventoryRemoteSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InventoryRemoteSource>(value),
    );
  }
}

String _$inventoryRemoteSourceHash() =>
    r'e240dde3696addefc6d5baf18552aecf7293139d';
