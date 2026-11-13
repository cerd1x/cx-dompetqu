import 'package:cx_dompetqiu/features/gen_ai/domain/models/ai_skill.dart' as domain;
import 'package:cx_dompetqiu/features/gen_ai/domain/models/mcp_server.dart' as domain;
import 'package:cx_dompetqiu/features/gen_ai/adapters/models/ai_skill.dart' as data;
import 'package:cx_dompetqiu/features/gen_ai/adapters/models/mcp_server.dart' as data;

extension AiSkillModelMapper on data.AiSkill {
  domain.AiSkill toEntity() =>
      domain.AiSkill(id: id, name: name, instructions: instructions);
}

extension McpServerModelMapper on data.McpServer {
  domain.McpServer toEntity() => domain.McpServer(id: id, name: name, url: url);
}
