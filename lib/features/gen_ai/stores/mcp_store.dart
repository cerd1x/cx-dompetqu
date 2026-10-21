import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/logger/app_logger.dart';
import '../domain/entities/mcp_server.dart';
import '../domain/repositories/mcp_repository.dart';
import '../repositories/mcp_repository.dart';

part 'generated/mcp_store.g.dart';

@Riverpod(keepAlive: true)
class McpStore extends _$McpStore {
  final AppLogger _log = AppLogger.instance;
  bool _mutationInFlight = false;

  @override
  Future<List<McpServer>> build() async {
    _log.debug('Memuat server MCP.', tag: 'McpStore');
    try {
      final servers = await ref.read(mcpRepositoryProvider).loadAll();
      _log.info(
        'Server MCP dimuat.',
        tag: 'McpStore',
        extras: {'serverCount': servers.length},
      );
      return servers;
    } catch (error, stackTrace) {
      _log.error(
        'Gagal memuat server MCP.',
        tag: 'McpStore',
        error: error.runtimeType.toString(),
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<void> add({required String name, required String url}) async {
    await _mutate((repository) => repository.add(name: name, url: url));
  }

  Future<void> remove(String id) async {
    await _mutate((repository) => repository.remove(id));
  }

  Future<void> _mutate(
    Future<List<McpServer>> Function(McpRepository repository) operation,
  ) async {
    if (_mutationInFlight) {
      _log.warn(
        'Perubahan MCP ditolak karena mutasi lain sedang berjalan.',
        tag: 'McpStore',
      );
      throw StateError('Perubahan MCP sedang diproses.');
    }
    _mutationInFlight = true;
    _log.debug('Memulai perubahan server MCP.', tag: 'McpStore');
    try {
      final updated = await operation(ref.read(mcpRepositoryProvider));
      if (!ref.mounted) return;
      state = AsyncValue.data(updated);
      _log.info(
        'Perubahan server MCP selesai.',
        tag: 'McpStore',
        extras: {'serverCount': updated.length},
      );
    } catch (error, stackTrace) {
      _log.error(
        'Perubahan server MCP gagal.',
        tag: 'McpStore',
        error: error.runtimeType.toString(),
        stackTrace: stackTrace,
      );
      rethrow;
    } finally {
      if (ref.mounted) {
        _mutationInFlight = false;
      }
    }
  }
}
