// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mcp_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(mcpRepository)
final mcpRepositoryProvider = McpRepositoryProvider._();

final class McpRepositoryProvider
    extends $FunctionalProvider<McpRepository, McpRepository, McpRepository>
    with $Provider<McpRepository> {
  McpRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mcpRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mcpRepositoryHash();

  @$internal
  @override
  $ProviderElement<McpRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  McpRepository create(Ref ref) {
    return mcpRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(McpRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<McpRepository>(value),
    );
  }
}

String _$mcpRepositoryHash() => r'ac4fde392c52f993ef7ed0ba7b4f8e5da37d1d20';
