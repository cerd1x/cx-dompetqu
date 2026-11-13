import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:cx_dompetqiu/features/gen_ai/adapters/datasources/mcp_local_datasource.dart';
import 'package:cx_dompetqiu/features/gen_ai/adapters/repositories/mcp_repository_impl.dart';
import 'package:cx_dompetqiu/features/gen_ai/domain/repositories/mcp_repository.dart';

part 'generated/mcp_repository.g.dart';

@Riverpod(keepAlive: true)
McpRepository mcpRepository(Ref ref) {
  return LocalMcpRepository(ref.read(mcpLocalDatasourceProvider));
}
