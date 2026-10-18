import '../entities/ai_message.dart';
import '../entities/ai_settings.dart';
import '../entities/mcp_server.dart';

abstract interface class AiChatRepository {
  Future<String> generateReply({
    required AiSettings settings,
    required String modelName,
    required String systemPrompt,
    required String message,
    required List<AiMessage> history,
    required List<McpServer> mcpServers,
  });
}
