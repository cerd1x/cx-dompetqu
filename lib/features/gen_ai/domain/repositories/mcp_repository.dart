import '../entities/mcp_server.dart';

abstract interface class McpRepository {
  Future<List<McpServer>> loadAll();
  Future<List<McpServer>> add({required String name, required String url});
  Future<List<McpServer>> remove(String id);
}
