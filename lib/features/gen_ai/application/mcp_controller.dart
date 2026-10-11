import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/mcp_server.dart';
import '../repositories/mcp_repository.dart';

part 'mcp_controller.g.dart';

@Riverpod(keepAlive: true)
class McpController extends _$McpController {
  bool _mutationInFlight = false;

  @override
  Future<List<McpServer>> build() {
    return ref.read(mcpRepositoryProvider).loadAll();
  }

  Future<void> add({
    required String name,
    required String url,
  }) async {
    await _mutate(
      (repository) => repository.add(name: name, url: url),
    );
  }

  Future<void> remove(String id) async {
    await _mutate((repository) => repository.remove(id));
  }

  Future<void> _mutate(
    Future<List<McpServer>> Function(McpRepository repository) operation,
  ) async {
    if (_mutationInFlight) {
      throw StateError('Perubahan MCP sedang diproses.');
    }
    _mutationInFlight = true;
    try {
      final updated = await operation(ref.read(mcpRepositoryProvider));
      if (!ref.mounted) return;
      state = AsyncValue.data(updated);
    } finally {
      if (ref.mounted) {
        _mutationInFlight = false;
      }
    }
  }
}
