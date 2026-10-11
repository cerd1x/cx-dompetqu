import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/mcp_server.dart';

part 'mcp_local_datasource.g.dart';

abstract interface class McpLocalDatasource {
  Future<List<McpServer>> loadAll();
  Future<void> saveAll(List<McpServer> servers);
}

@Riverpod(keepAlive: true)
McpLocalDatasource mcpLocalDatasource(Ref ref) {
  return SharedPreferencesMcpLocalDatasource();
}

class SharedPreferencesMcpLocalDatasource implements McpLocalDatasource {
  static const _storageKey = 'mcp_servers';

  @override
  Future<List<McpServer>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_storageKey);
    if (stored == null) return const [];
    final decoded = jsonDecode(stored);
    if (decoded is! List) {
      throw const FormatException('Data MCP tersimpan tidak valid.');
    }
    return decoded
        .map(
          (entry) => McpServer.fromJson(
            Map<String, dynamic>.from(entry as Map),
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<void> saveAll(List<McpServer> servers) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = await prefs.setString(
      _storageKey,
      jsonEncode(servers.map((server) => server.toJson()).toList()),
    );
    if (!saved) {
      throw StateError('Konfigurasi MCP tidak berhasil disimpan.');
    }
  }
}
