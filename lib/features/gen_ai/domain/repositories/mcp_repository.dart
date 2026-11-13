import 'package:cx_dompetqiu/features/gen_ai/domain/models/mcp_server.dart';

abstract interface class McpRepository {
  Future<List<McpServer>> loadAll();
  Future<List<McpServer>> add({required String name, required String url});
  Future<List<McpServer>> remove(String id);
}
