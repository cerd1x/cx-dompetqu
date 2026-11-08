import 'package:get_it/get_it.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:dompetqu/core/database/entities/mcp_server_entity.dart';
import 'package:dompetqu/core/database/objectbox_database.dart';
import 'package:dompetqu/features/gen_ai/adapters/models/mcp_server.dart';

part 'generated/mcp_local_datasource.g.dart';

abstract interface class McpLocalDatasource {
  Future<List<McpServer>> loadAll();
  Future<void> saveAll(List<McpServer> servers);
}

@Riverpod(keepAlive: true)
McpLocalDatasource mcpLocalDatasource(Ref ref) {
  return ObjectBoxMcpLocalDatasource();
}

class ObjectBoxMcpLocalDatasource implements McpLocalDatasource {
  ObjectBoxDatabase get _db => GetIt.instance.get<ObjectBoxDatabase>();

  @override
  Future<List<McpServer>> loadAll() async {
    final entities = _db.mcpServerBox.getAll();
    return entities
        .map((e) => McpServer(id: e.serverId, name: e.name, url: e.url))
        .toList(growable: false);
  }

  @override
  Future<void> saveAll(List<McpServer> servers) async {
    _db.mcpServerBox.removeAll();
    final entities = servers
        .map((s) => McpServerEntity(serverId: s.id, name: s.name, url: s.url))
        .toList();
    _db.mcpServerBox.putMany(entities);
  }
}
