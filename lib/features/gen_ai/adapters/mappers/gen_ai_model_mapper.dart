import 'package:dompetqu/features/gen_ai/domain/entities/ai_skill.dart' as domain;
import 'package:dompetqu/features/gen_ai/domain/entities/mcp_server.dart' as domain;
import 'package:dompetqu/features/gen_ai/models/ai_skill.dart' as data;
import 'package:dompetqu/features/gen_ai/models/mcp_server.dart' as data;

extension AiSkillModelMapper on data.AiSkill {
  domain.AiSkill toEntity() =>
      domain.AiSkill(id: id, name: name, instructions: instructions);
}

extension McpServerModelMapper on data.McpServer {
  domain.McpServer toEntity() => domain.McpServer(id: id, name: name, url: url);
}
