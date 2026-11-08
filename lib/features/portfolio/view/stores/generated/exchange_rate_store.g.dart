// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../exchange_rate_store.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Store nilai tukar aktif.
///
/// Rate di-fetch dari sumber global (Frankfurter) dan dipakai UI untuk
/// konversi tampilan nilai portofolio ke mata uang lain.

@ProviderFor(ExchangeRateStore)
final exchangeRateStoreProvider = ExchangeRateStoreProvider._();

/// Store nilai tukar aktif.
///
/// Rate di-fetch dari sumber global (Frankfurter) dan dipakai UI untuk
/// konversi tampilan nilai portofolio ke mata uang lain.
final class ExchangeRateStoreProvider
    extends $AsyncNotifierProvider<ExchangeRateStore, ExchangeRate> {
  /// Store nilai tukar aktif.
  ///
  /// Rate di-fetch dari sumber global (Frankfurter) dan dipakai UI untuk
  /// konversi tampilan nilai portofolio ke mata uang lain.
  ExchangeRateStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exchangeRateStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exchangeRateStoreHash();

  @$internal
  @override
  ExchangeRateStore create() => ExchangeRateStore();
}

String _$exchangeRateStoreHash() => r'ac53561468bec758c0eaddc142ad328e4e80742f';

/// Store nilai tukar aktif.
///
/// Rate di-fetch dari sumber global (Frankfurter) dan dipakai UI untuk
/// konversi tampilan nilai portofolio ke mata uang lain.

abstract class _$ExchangeRateStore extends $AsyncNotifier<ExchangeRate> {
  FutureOr<ExchangeRate> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ExchangeRate>, ExchangeRate>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ExchangeRate>, ExchangeRate>,
              AsyncValue<ExchangeRate>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
