// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions_remote_source.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(transactionsRemoteSource)
final transactionsRemoteSourceProvider = TransactionsRemoteSourceProvider._();

final class TransactionsRemoteSourceProvider
    extends
        $FunctionalProvider<
          TransactionsRemoteSource,
          TransactionsRemoteSource,
          TransactionsRemoteSource
        >
    with $Provider<TransactionsRemoteSource> {
  TransactionsRemoteSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transactionsRemoteSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transactionsRemoteSourceHash();

  @$internal
  @override
  $ProviderElement<TransactionsRemoteSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TransactionsRemoteSource create(Ref ref) {
    return transactionsRemoteSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TransactionsRemoteSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TransactionsRemoteSource>(value),
    );
  }
}

String _$transactionsRemoteSourceHash() =>
    r'b9a20ad941f910d6682bbf5b61234f245631246f';
