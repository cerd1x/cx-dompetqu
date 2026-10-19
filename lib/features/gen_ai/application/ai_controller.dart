import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dompetqu/features/gen_ai/domain/entities/ai_message.dart';
import '../../../core/logger/app_logger.dart';
import 'ai_chat_repository_provider.dart';
import 'ai_settings_controller.dart';
import 'ai_skills_controller.dart';
import 'mcp_controller.dart';
import '../domain/entities/ai_skill.dart';
import '../domain/entities/ai_settings.dart';

part 'generated/ai_controller.freezed.dart';
part 'generated/ai_controller.g.dart';

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
  final AppLogger _log = AppLogger.instance;

  @override
  AiState build() => const AiState();

  /// Kirim pertanyaan user → tampilkan balasan (atau error sebagai
  /// pesan assistant agar feedback tetap terlihat di dalam chat).
  Future<void> send(String raw) async {
    final text = raw.trim();
    if (text.isEmpty || state.sending) {
      _log.debug(
        'Pesan AI dilewati karena kosong atau permintaan sedang berjalan.',
        tag: 'AiController',
      );
      return;
    }
    final history = [
      ...state.messages,
      AiMessage(role: AiRole.user, text: text, at: DateTime.now()),
    ];
    state = AiState(messages: history, sending: true);
    _log.info(
      'Memulai permintaan chat AI.',
      tag: 'AiController',
      extras: {'historyCount': history.length - 1},
    );
    try {
      // Riwayat TANPA pesan terakhir; pesan terbaru dikirim terpisah ke Genkit.
      final reply = await _ask(text, history.sublist(0, history.length - 1));
      _append(reply);
      _log.info(
        'Permintaan chat AI selesai.',
        tag: 'AiController',
        extras: {'responseLength': reply.length},
      );
    } catch (e, stackTrace) {
      _log.error(
        'Permintaan chat AI gagal.',
        tag: 'AiController',
        error: e.runtimeType.toString(),
        stackTrace: stackTrace,
      );
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
    _log.debug(
      'Menyiapkan Genkit.',
      tag: 'AiController',
      extras: {
        'provider': settings.provider.name,
        'model': modelName,
        'historyCount': history.length,
        'skillCount': skills.length,
        'mcpServerCount': mcpServers.length,
      },
    );
    return ref
        .read(aiChatRepositoryProvider)
        .generateReply(
          settings: settings,
          modelName: modelName,
          systemPrompt: _systemPrompt(skills),
          message: message,
          history: history,
          mcpServers: mcpServers,
        );
  }

  String _systemPrompt(List<AiSkill> skills) {
    if (skills.isEmpty) return _kSystemInstruction;
    return [
      _kSystemInstruction,
      'Instruksi skill yang ditambahkan pengguna:',
      for (final skill in skills) '## ${skill.name}\n${skill.instructions}',
    ].join('\n\n');
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
