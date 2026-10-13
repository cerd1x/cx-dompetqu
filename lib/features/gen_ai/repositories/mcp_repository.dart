import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/datasources/mcp_local_datasource.dart';
import '../data/repositories/mcp_repository_impl.dart';
import '../domain/repositories/mcp_repository.dart';

part 'mcp_repository.g.dart';

@Riverpod(keepAlive: true)
McpRepository mcpRepository(Ref ref) {
  return LocalMcpRepository(ref.read(mcpLocalDatasourceProvider));
}
