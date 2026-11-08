// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../reports_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider untuk data source mock laporan.

@ProviderFor(reportsMockDataSource)
final reportsMockDataSourceProvider = ReportsMockDataSourceProvider._();

/// Provider untuk data source mock laporan.

final class ReportsMockDataSourceProvider
    extends
        $FunctionalProvider<
          ReportsMockDataSource,
          ReportsMockDataSource,
          ReportsMockDataSource
        >
    with $Provider<ReportsMockDataSource> {
  /// Provider untuk data source mock laporan.
  ReportsMockDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reportsMockDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reportsMockDataSourceHash();

  @$internal
  @override
  $ProviderElement<ReportsMockDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ReportsMockDataSource create(Ref ref) {
    return reportsMockDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReportsMockDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReportsMockDataSource>(value),
    );
  }
}

String _$reportsMockDataSourceHash() =>
    r'9b69cf315ab649438714d1e1eac2d2aa33341285';

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

String _$reportsRepositoryHash() => r'7b1ccd649d329ea297840699ef334626642d6a83';
