// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../mcp_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(McpController)
final mcpControllerProvider = McpControllerProvider._();

final class McpControllerProvider
    extends $AsyncNotifierProvider<McpController, List<McpServer>> {
  McpControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mcpControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mcpControllerHash();

  @$internal
  @override
  McpController create() => McpController();
}

String _$mcpControllerHash() => r'8c370063da4cca88f0dc9311b006614b8f95aabf';

abstract class _$McpController extends $AsyncNotifier<List<McpServer>> {
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
