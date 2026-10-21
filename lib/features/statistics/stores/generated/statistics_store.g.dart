// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../statistics_store.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(StatisticsStore)
final statisticsStoreProvider = StatisticsStoreProvider._();

final class StatisticsStoreProvider
    extends $NotifierProvider<StatisticsStore, StatisticsState> {
  StatisticsStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'statisticsStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$statisticsStoreHash();

  @$internal
  @override
  StatisticsStore create() => StatisticsStore();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StatisticsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StatisticsState>(value),
    );
  }
}

String _$statisticsStoreHash() => r'abe7101aea717f80ffcc67ec8ba236a4259cd095';

abstract class _$StatisticsStore extends $Notifier<StatisticsState> {
  StatisticsState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<StatisticsState, StatisticsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<StatisticsState, StatisticsState>,
              StatisticsState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
