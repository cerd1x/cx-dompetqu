// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics_remote_source.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(statisticsRemoteSource)
final statisticsRemoteSourceProvider = StatisticsRemoteSourceProvider._();

final class StatisticsRemoteSourceProvider
    extends
        $FunctionalProvider<
          StatisticsRemoteSource,
          StatisticsRemoteSource,
          StatisticsRemoteSource
        >
    with $Provider<StatisticsRemoteSource> {
  StatisticsRemoteSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'statisticsRemoteSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$statisticsRemoteSourceHash();

  @$internal
  @override
  $ProviderElement<StatisticsRemoteSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  StatisticsRemoteSource create(Ref ref) {
    return statisticsRemoteSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StatisticsRemoteSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StatisticsRemoteSource>(value),
    );
  }
}

String _$statisticsRemoteSourceHash() =>
    r'b0b22c01000c02413fff91f1be27e35d96ced2d6';
