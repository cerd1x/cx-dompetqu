import 'package:dompetqu/features/gen_ai/adapters/datasources/mcp_local_datasource.dart';
import 'package:dompetqu/features/gen_ai/domain/entities/mcp_server.dart';
import 'package:dompetqu/features/gen_ai/domain/repositories/mcp_repository.dart';
import 'package:dompetqu/features/gen_ai/adapters/mappers/gen_ai_model_mapper.dart';
import 'package:dompetqu/features/gen_ai/models/mcp_server.dart' as data;

class LocalMcpRepository implements McpRepository {
  const LocalMcpRepository(this._local);

  final McpLocalDatasource _local;

  @override
  Future<List<McpServer>> loadAll() async =>
      (await _local.loadAll()).map((model) => model.toEntity()).toList();

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
    await _local.saveAll([
      ...current,
      data.McpServer(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        name: normalizedName,
        url: normalizedUrl,
      ),
    ]);
    return loadAll();
  }

  @override
  Future<List<McpServer>> remove(String id) async {
    final current = await _local.loadAll();
    await _local.saveAll(current.where((server) => server.id != id).toList());
    return loadAll();
  }
}
