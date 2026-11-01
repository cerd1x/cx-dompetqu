import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/mcp_server.freezed.dart';

/// Satu server MCP yang terdaftar untuk agen AI.
@freezed
abstract class McpServer with _$McpServer {
  const factory McpServer({
    required String id,
    required String name,
    required String url,
  }) = _McpServer;

  const McpServer._();
}
