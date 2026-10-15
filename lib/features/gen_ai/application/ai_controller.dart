import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:genkit/genkit.dart';
import 'package:genkit_anthropic/genkit_anthropic.dart';
import 'package:genkit_google_genai/genkit_google_genai.dart';
import 'package:genkit_mcp/genkit_mcp.dart';
import 'package:genkit_openai/genkit_openai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dompetqu/features/gen_ai/domain/entities/ai_message.dart';
import 'ai_settings_controller.dart';
import 'ai_skills_controller.dart';
import 'mcp_controller.dart';
import '../domain/entities/ai_skill.dart';
import '../domain/entities/ai_settings.dart';

part 'ai_controller.freezed.dart';
part 'ai_controller.g.dart';

/// Persona & batasan asisten AI.
const String _kSystemInstruction = '''
Kamu adalah "DompetQu AI", asisten keuangan pribadi di aplikasi DompetQu.
Bantu pengguna untuk: memahami pengeluaran & pemasukan, budgeting, ide
hemat, dan pertanyaan umum seputar finansial pribadi.
Aturan:
- Jawab ringkas, ramah, dan praktis.
- Gunakan Bahasa Indonesia kecuali pengguna menulis dalam bahasa lain.
- Jangan mengarang data transaksi yang tidak diberikan pengguna.
- Untuk pertanyaan di luar topik finansial, jawab singkat lalu arahkan
  kembali ke topik keuangan.''';

/// State percakapan AI — daftar pesan + flag menunggu balasan.
@freezed
abstract class AiState with _$AiState {
  const factory AiState({
    @Default([]) List<AiMessage> messages,
    @Default(false) bool sending,
  }) = _AiState;
}

/// Controller percakapan AI. Riwayat bersih ketika sheet ditutup.
@Riverpod()
class AiController extends _$AiController {
  @override
  AiState build() => const AiState();

  /// Kirim pertanyaan user → tampilkan balasan (atau error sebagai
  /// pesan assistant agar feedback tetap terlihat di dalam chat).
  Future<void> send(String raw) async {
    final text = raw.trim();
    if (text.isEmpty || state.sending) return;
    final history = [
      ...state.messages,
      AiMessage(role: AiRole.user, text: text, at: DateTime.now()),
    ];
    state = AiState(messages: history, sending: true);
    try {
      // Riwayat TANPA pesan terakhir; pesan terbaru dikirim terpisah ke Genkit.
      final reply = await _ask(text, history.sublist(0, history.length - 1));
      _append(reply);
    } catch (e) {
      _append('Maaf, asisten AI gagal menjawab.\n$e');
    }
  }

  Future<String> _ask(String message, List<AiMessage> history) async {
    final settings = await ref.read(aiSettingsControllerProvider.future);
    final skills = await ref.read(aiSkillsControllerProvider.future);
    final mcpServers = await ref.read(mcpControllerProvider.future);
    if (!ref.mounted) return '';
    if (settings.provider != AiModelProvider.ollama &&
        settings.apiKey.isEmpty) {
      throw StateError(
        'API key ${settings.provider.label} belum diatur di Pengaturan AI.',
      );
    }

    final modelName = settings.model.isEmpty
        ? settings.provider.defaultModel
        : settings.model;
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
      final system = _systemPrompt(skills);
      final response = switch (settings.provider) {
        AiModelProvider.googleAi => await ai.generate(
          model: googleAI.gemini(modelName),
          system: system,
          messages: messages,
          tools: tools,
          use: [retry()],
        ),
        AiModelProvider.anthropic => await ai.generate(
          model: anthropic.model(modelName),
          system: system,
          messages: messages,
          tools: tools,
          use: [retry()],
        ),
        AiModelProvider.openAi || AiModelProvider.ollama => await ai.generate(
          model: openAI.model(modelName),
          system: system,
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
      return reply.trim();
    } finally {
      for (final client in clients) {
        await client.close();
      }
    }
  }

  String _systemPrompt(List<AiSkill> skills) {
    if (skills.isEmpty) return _kSystemInstruction;
    return [
      _kSystemInstruction,
      'Instruksi skill yang ditambahkan pengguna:',
      for (final skill in skills) '## ${skill.name}\n${skill.instructions}',
    ].join('\n\n');
  }

  /// Terjemahkan error SDK ke pesan yang ramah user.
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

  void _append(String text) {
    if (!ref.mounted) return;
    state = state.copyWith(
      messages: [
        ...state.messages,
        AiMessage(role: AiRole.assistant, text: text, at: DateTime.now()),
      ],
      sending: false,
    );
  }
}
