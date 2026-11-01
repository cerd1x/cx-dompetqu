// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../payments_remote_source.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(paymentsRemoteSource)
final paymentsRemoteSourceProvider = PaymentsRemoteSourceProvider._();

final class PaymentsRemoteSourceProvider
    extends
        $FunctionalProvider<
          PaymentsRemoteSource,
          PaymentsRemoteSource,
          PaymentsRemoteSource
        >
    with $Provider<PaymentsRemoteSource> {
  PaymentsRemoteSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'paymentsRemoteSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$paymentsRemoteSourceHash();

  @$internal
  @override
  $ProviderElement<PaymentsRemoteSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PaymentsRemoteSource create(Ref ref) {
    return paymentsRemoteSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PaymentsRemoteSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PaymentsRemoteSource>(value),
    );
  }
}

String _$paymentsRemoteSourceHash() =>
    r'020a37d5c19a9b1ec348f76dcf801c79d3db2d64';
