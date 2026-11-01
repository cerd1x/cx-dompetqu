import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/mcp_server.freezed.dart';
part 'generated/mcp_server.g.dart';

/// Satu server MCP — endpoint HTTP yang didaftarkan user. Dipakai controller,
/// repository, dan datasource (persist JSON di SharedPreferences).
@freezed
abstract class McpServer with _$McpServer {
  const factory McpServer({
    required String id,
    required String name,
    required String url,
  }) = _McpServer;

  factory McpServer.fromJson(Map<String, dynamic> json) =>
      _$McpServerFromJson(json);
}
