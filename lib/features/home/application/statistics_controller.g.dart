// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(StatisticsController)
final statisticsControllerProvider = StatisticsControllerProvider._();

final class StatisticsControllerProvider
    extends $NotifierProvider<StatisticsController, StatisticsState> {
  StatisticsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'statisticsControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$statisticsControllerHash();

  @$internal
  @override
  StatisticsController create() => StatisticsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StatisticsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StatisticsState>(value),
    );
  }
}

String _$statisticsControllerHash() =>
    r'a0a61652a70d8dc90300041e9c5c7c1280f6406c';

abstract class _$StatisticsController extends $Notifier<StatisticsState> {
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
