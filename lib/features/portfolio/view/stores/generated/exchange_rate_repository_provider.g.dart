// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../exchange_rate_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider repository yang memakai adapter Frankfurter.
///
/// Ganti adapter cukup di sini (mis. sumber lain yang berbayar/berapi-key).

@ProviderFor(exchangeRateRepository)
final exchangeRateRepositoryProvider = ExchangeRateRepositoryProvider._();

/// Provider repository yang memakai adapter Frankfurter.
///
/// Ganti adapter cukup di sini (mis. sumber lain yang berbayar/berapi-key).

final class ExchangeRateRepositoryProvider
    extends
        $FunctionalProvider<
          ExchangeRateRepository,
          ExchangeRateRepository,
          ExchangeRateRepository
        >
    with $Provider<ExchangeRateRepository> {
  /// Provider repository yang memakai adapter Frankfurter.
  ///
  /// Ganti adapter cukup di sini (mis. sumber lain yang berbayar/berapi-key).
  ExchangeRateRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exchangeRateRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exchangeRateRepositoryHash();

  @$internal
  @override
  $ProviderElement<ExchangeRateRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ExchangeRateRepository create(Ref ref) {
    return exchangeRateRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExchangeRateRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExchangeRateRepository>(value),
    );
  }
}

String _$exchangeRateRepositoryHash() =>
    r'1efbcdd184b81a042988d20ddc9fe3640ede1557';
