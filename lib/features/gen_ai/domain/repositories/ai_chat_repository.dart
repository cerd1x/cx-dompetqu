import 'package:dompetqu/features/gen_ai/domain/entities/ai_message.dart';
import 'package:dompetqu/features/gen_ai/domain/entities/ai_settings.dart';
import 'package:dompetqu/features/gen_ai/domain/entities/mcp_server.dart';

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
