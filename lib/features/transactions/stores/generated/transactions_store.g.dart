// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../transactions_store.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TransactionsStore)
final transactionsStoreProvider = TransactionsStoreProvider._();

final class TransactionsStoreProvider
    extends $NotifierProvider<TransactionsStore, TransactionsState> {
  TransactionsStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transactionsStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transactionsStoreHash();

  @$internal
  @override
  TransactionsStore create() => TransactionsStore();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TransactionsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TransactionsState>(value),
    );
  }
}

String _$transactionsStoreHash() => r'a81c8b30a24d5c6f0ab6386a118f7b2d245a6fac';

abstract class _$TransactionsStore extends $Notifier<TransactionsState> {
  TransactionsState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<TransactionsState, TransactionsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TransactionsState, TransactionsState>,
              TransactionsState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
