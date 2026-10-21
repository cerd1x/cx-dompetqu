// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../mcp_store.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(McpStore)
final mcpStoreProvider = McpStoreProvider._();

final class McpStoreProvider
    extends $AsyncNotifierProvider<McpStore, List<McpServer>> {
  McpStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mcpStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mcpStoreHash();

  @$internal
  @override
  McpStore create() => McpStore();
}

String _$mcpStoreHash() => r'92b1f88494a714bb4ed1f666bc1ddf74f72cc4dc';

abstract class _$McpStore extends $AsyncNotifier<List<McpServer>> {
  FutureOr<List<McpServer>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<McpServer>>, List<McpServer>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<McpServer>>, List<McpServer>>,
              AsyncValue<List<McpServer>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
