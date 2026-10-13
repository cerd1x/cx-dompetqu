import '../../domain/entities/ai_skill.dart' as domain;
import '../../domain/entities/mcp_server.dart' as domain;
import '../../models/ai_skill.dart' as data;
import '../../models/mcp_server.dart' as data;

extension AiSkillModelMapper on data.AiSkill {
  domain.AiSkill toEntity() =>
      domain.AiSkill(id: id, name: name, instructions: instructions);
}

extension McpServerModelMapper on data.McpServer {
  domain.McpServer toEntity() => domain.McpServer(id: id, name: name, url: url);
}
