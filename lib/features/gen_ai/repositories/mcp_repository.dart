import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/datasources/mcp_local_datasource.dart';
import '../models/mcp_server.dart';

part 'mcp_repository.g.dart';

abstract interface class McpRepository {
  Future<List<McpServer>> loadAll();
  Future<List<McpServer>> add({
    required String name,
    required String url,
  });
  Future<List<McpServer>> remove(String id);
}

@Riverpod(keepAlive: true)
McpRepository mcpRepository(Ref ref) {
  return LocalMcpRepository(ref.read(mcpLocalDatasourceProvider));
}

class LocalMcpRepository implements McpRepository {
  const LocalMcpRepository(this._local);

  final McpLocalDatasource _local;

  @override
  Future<List<McpServer>> loadAll() => _local.loadAll();

  @override
  Future<List<McpServer>> add({
    required String name,
    required String url,
  }) async {
    final normalizedName = name.trim();
    final normalizedUrl = url.trim();
    final uri = Uri.tryParse(normalizedUrl);
    if (normalizedName.isEmpty) {
      throw const FormatException('Nama server MCP wajib diisi.');
    }
    if (uri == null ||
        (uri.scheme != 'http' && uri.scheme != 'https') ||
        uri.host.isEmpty) {
      throw const FormatException('URL MCP tidak valid. Gunakan http/https.');
    }
    final current = await _local.loadAll();
    if (current.any((server) => server.url == normalizedUrl)) {
      throw const FormatException('URL MCP ini sudah terdaftar.');
    }
    final updated = [
      ...current,
      McpServer(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        name: normalizedName,
        url: normalizedUrl,
      ),
    ];
    await _local.saveAll(updated);
    return _local.loadAll();
  }

  @override
  Future<List<McpServer>> remove(String id) async {
    final current = await _local.loadAll();
    final updated = current.where((server) => server.id != id).toList();
    await _local.saveAll(updated);
    return _local.loadAll();
  }
}
