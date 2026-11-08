import 'package:objectbox/objectbox.dart';

/// MCP server — {id, name, url}.
@Entity()
class McpServerEntity {
  McpServerEntity({
    this.id = 0,
    this.serverId = '',
    this.name = '',
    this.url = '',
  });

  int id = 0;

  @Index()
  @Unique()
  String serverId = '';
  String name = '';
  String url = '';
}
