// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../reports_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider untuk data source laporan berbasis ObjectBox.

@ProviderFor(reportsObjectboxDataSource)
final reportsObjectboxDataSourceProvider =
    ReportsObjectboxDataSourceProvider._();

/// Provider untuk data source laporan berbasis ObjectBox.

final class ReportsObjectboxDataSourceProvider
    extends
        $FunctionalProvider<
          ReportsObjectboxDataSource,
          ReportsObjectboxDataSource,
          ReportsObjectboxDataSource
        >
    with $Provider<ReportsObjectboxDataSource> {
  /// Provider untuk data source laporan berbasis ObjectBox.
  ReportsObjectboxDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reportsObjectboxDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reportsObjectboxDataSourceHash();

  @$internal
  @override
  $ProviderElement<ReportsObjectboxDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ReportsObjectboxDataSource create(Ref ref) {
    return reportsObjectboxDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReportsObjectboxDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReportsObjectboxDataSource>(value),
    );
  }
}

String _$reportsObjectboxDataSourceHash() =>
    r'94763e28dad983acbdda158902df490efa32d460';

/// Provider untuk repository laporan (port).

@ProviderFor(reportsRepository)
final reportsRepositoryProvider = ReportsRepositoryProvider._();

/// Provider untuk repository laporan (port).

final class ReportsRepositoryProvider
    extends
        $FunctionalProvider<
          ReportsRepository,
          ReportsRepository,
          ReportsRepository
        >
    with $Provider<ReportsRepository> {
  /// Provider untuk repository laporan (port).
  ReportsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reportsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reportsRepositoryHash();

  @$internal
  @override
  $ProviderElement<ReportsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ReportsRepository create(Ref ref) {
    return reportsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReportsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReportsRepository>(value),
    );
  }
}

String _$reportsRepositoryHash() => r'b0c0682a5f692be865caec02d6fa8c96a2cc5fbd';
