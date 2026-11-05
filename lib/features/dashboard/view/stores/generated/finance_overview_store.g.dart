// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../finance_overview_store.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Store gabungan yang memuat data payment dan transaction secara paralel.
///
/// Pemrosesan daftar besar (normalisasi & dedupe) dijalankan di isolate
/// terpisah via [compute] agar UI isolate tidak diblokir saat payload
/// transaksi banyak.

@ProviderFor(FinanceOverviewStore)
final financeOverviewStoreProvider = FinanceOverviewStoreProvider._();

/// Store gabungan yang memuat data payment dan transaction secara paralel.
///
/// Pemrosesan daftar besar (normalisasi & dedupe) dijalankan di isolate
/// terpisah via [compute] agar UI isolate tidak diblokir saat payload
/// transaksi banyak.
final class FinanceOverviewStoreProvider
    extends $NotifierProvider<FinanceOverviewStore, FinanceOverviewState> {
  /// Store gabungan yang memuat data payment dan transaction secara paralel.
  ///
  /// Pemrosesan daftar besar (normalisasi & dedupe) dijalankan di isolate
  /// terpisah via [compute] agar UI isolate tidak diblokir saat payload
  /// transaksi banyak.
  FinanceOverviewStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'financeOverviewStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$financeOverviewStoreHash();

  @$internal
  @override
  FinanceOverviewStore create() => FinanceOverviewStore();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FinanceOverviewState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FinanceOverviewState>(value),
    );
  }
}

String _$financeOverviewStoreHash() =>
    r'2fc18732adc622f687443bc473be8db80109e583';

/// Store gabungan yang memuat data payment dan transaction secara paralel.
///
/// Pemrosesan daftar besar (normalisasi & dedupe) dijalankan di isolate
/// terpisah via [compute] agar UI isolate tidak diblokir saat payload
/// transaksi banyak.

abstract class _$FinanceOverviewStore extends $Notifier<FinanceOverviewState> {
  FinanceOverviewState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<FinanceOverviewState, FinanceOverviewState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FinanceOverviewState, FinanceOverviewState>,
              FinanceOverviewState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
