import 'package:genkit/genkit.dart';
import 'package:genkit_anthropic/genkit_anthropic.dart';
import 'package:genkit_google_genai/genkit_google_genai.dart';
import 'package:genkit_mcp/genkit_mcp.dart';
import 'package:genkit_openai/genkit_openai.dart';

import 'package:dompetqu/core/logger/app_logger.dart';
import 'package:dompetqu/features/gen_ai/domain/entities/ai_message.dart';
import 'package:dompetqu/features/gen_ai/domain/entities/ai_settings.dart';
import 'package:dompetqu/features/gen_ai/domain/entities/mcp_server.dart';
import 'package:dompetqu/features/gen_ai/domain/repositories/ai_chat_repository.dart';

class GenkitAiChatRepository implements AiChatRepository {
  GenkitAiChatRepository() : _log = AppLogger.instance;

  final AppLogger _log;

  @override
  Future<String> generateReply({
    required AiSettings settings,
    required String modelName,
    required String systemPrompt,
    required String message,
    required List<AiMessage> history,
    required List<McpServer> mcpServers,
  }) async {
    final ai = switch (settings.provider) {
      AiModelProvider.googleAi => Genkit(
        plugins: [googleAI(apiKey: settings.apiKey)],
      ),
      AiModelProvider.anthropic => Genkit(
        plugins: [anthropic(apiKey: settings.apiKey)],
      ),
      AiModelProvider.openAi => Genkit(
        plugins: [
          openAI(
            apiKey: settings.apiKey,
            baseUrl: settings.baseUrl,
            headers: settings.includeCustomHeaders
                ? settings.customHeaders
                : null,
          ),
        ],
      ),
      AiModelProvider.ollama => Genkit(
        plugins: [
          openAI(
            apiKey: 'ollama',
            baseUrl: settings.baseUrl,
            headers: settings.includeCustomHeaders
                ? settings.customHeaders
                : null,
          ),
        ],
      ),
      // OpenRouter kompatibel OpenAI; base URL default dari OpenRouterConfig.
      AiModelProvider.openRouter => Genkit(
        plugins: [
          openAI(
            apiKey: settings.apiKey,
            baseUrl: settings.baseUrl,
            headers: settings.includeCustomHeaders
                ? settings.customHeaders
                : null,
          ),
        ],
      ),
    };
    final clients = <GenkitMcpClient>[];
    try {
      final tools = <Tool<Map<String, dynamic>, dynamic>>[];
      for (var index = 0; index < mcpServers.length; index++) {
        final server = mcpServers[index];
        final client = createMcpClient(
          McpClientOptions(
            name: 'DompetQu',
            serverName: 'server_$index',
            mcpServer: McpServerConfig(url: Uri.parse(server.url)),
          ),
        );
        clients.add(client);
        await client.ready();
        tools.addAll(await client.getActiveTools(ai));
      }

      final messages = [
        for (final item in history)
          if (item.text.trim().isNotEmpty)
            Message(
              role: item.role == AiRole.user ? Role.user : Role.model,
              content: [TextPart(text: item.text)],
            ),
        Message(
          role: Role.user,
          content: [TextPart(text: message)],
        ),
      ];
      final response = switch (settings.provider) {
        AiModelProvider.googleAi => await ai.generate(
          model: googleAI.gemini(modelName),
          system: systemPrompt,
          messages: messages,
          tools: tools,
          use: [retry()],
        ),
        AiModelProvider.anthropic => await ai.generate(
          model: anthropic.model(modelName),
          system: systemPrompt,
          messages: messages,
          tools: tools,
          use: [retry()],
        ),
        AiModelProvider.openAi ||
        AiModelProvider.ollama ||
        AiModelProvider.openRouter => await ai.generate(
          model: openAI.model(modelName),
          system: systemPrompt,
          messages: messages,
          tools: tools,
          use: [retry()],
        ),
      };

      if (response.finishReason == FinishReason.failed) {
        throw StateError(
          _friendly(
            response.error?.message ?? 'Genkit gagal menghasilkan jawaban.',
            modelName,
          ),
        );
      }
      if (response.finishReason == FinishReason.blocked) {
        throw StateError('Pesan diblokir filter keamanan.');
      }
      if (response.finishReason == FinishReason.aborted) {
        throw StateError('Permintaan AI dihentikan sebelum selesai.');
      }

      final reply = response.text;
      if (reply.trim().isEmpty) {
        throw StateError(
          '${settings.provider.label} mengembalikan jawaban kosong.',
        );
      }
      _log.debug(
        'Genkit menghasilkan jawaban.',
        tag: 'AiChatRepository',
        extras: {'finishReason': response.finishReason.toString()},
      );
      return reply.trim();
    } finally {
      for (final client in clients) {
        await client.close();
      }
    }
  }

  String _friendly(String message, String model) {
    final lower = message.toLowerCase();
    if (lower.contains('api key') || lower.contains('permission')) {
      return 'API key provider AI tidak valid.';
    }
    if (lower.contains('quota') || lower.contains('resource_exhausted')) {
      return 'Kuota provider AI habis, coba lagi nanti.';
    }
    if (lower.contains('not found') || lower.contains('404')) {
      return 'Model "$model" tidak tersedia. Ganti model di Settings.';
    }
    if (lower.contains('safety') || lower.contains('blocked')) {
      return 'Pesan diblokir filter keamanan.';
    }
    return message;
  }
}
