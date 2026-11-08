// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../mcp_local_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(mcpLocalDatasource)
final mcpLocalDatasourceProvider = McpLocalDatasourceProvider._();

final class McpLocalDatasourceProvider
    extends
        $FunctionalProvider<
          McpLocalDatasource,
          McpLocalDatasource,
          McpLocalDatasource
        >
    with $Provider<McpLocalDatasource> {
  McpLocalDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mcpLocalDatasourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mcpLocalDatasourceHash();

  @$internal
  @override
  $ProviderElement<McpLocalDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  McpLocalDatasource create(Ref ref) {
    return mcpLocalDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(McpLocalDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<McpLocalDatasource>(value),
    );
  }
}

String _$mcpLocalDatasourceHash() =>
    r'08b3afda1e50979c3e693de8ae9da13cd1cab638';
