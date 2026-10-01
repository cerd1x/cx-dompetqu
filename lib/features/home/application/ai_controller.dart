import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../settings/application/settings_controller.dart';
import '../models/ai_message.dart';

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
class AiState {
  const AiState({this.messages = const [], this.sending = false});

  final List<AiMessage> messages;
  final bool sending;

  AiState copyWith({List<AiMessage>? messages, bool? sending}) => AiState(
    messages: messages ?? this.messages,
    sending: sending ?? this.sending,
  );
}

/// Controller percakapan AI. AutoDispose: riwayat bersih tiap sheet
/// ditutup (tidak ada listener) — hemat memori & mulai fresh.
///
/// Memakai package `google_generative_ai` (Gemini) langsung dengan API key
/// & model yang dikonfigurasi di halaman Settings.
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
      // Riwayat TANPA pesan terakhir — pesan itu dikirim via sendMessage.
      final reply = await _ask(text, history.sublist(0, history.length - 1));
      _append(reply);
    } catch (e) {
      _append('Maaf, asisten AI gagal menjawab.\n$e');
    }
  }

  Future<String> _ask(String message, List<AiMessage> history) async {
    final settings = await ref.read(settingsControllerProvider.future);
    final model = GenerativeModel(
      model: settings.aiModel.isEmpty ? kDefaultAiModel : settings.aiModel,
      apiKey: settings.aiApiKey,
      systemInstruction: Content.system(_kSystemInstruction),
    );
    if (settings.aiApiKey.isEmpty) {
      throw StateError('API key Gemini belum diatur di Settings.');
    }

    // Gemini mewajibkan history dimulai dari peran "user".
    final contents = <Content>[];
    for (final m in history) {
      if (m.text.trim().isEmpty) continue;
      contents.add(
        Content(
          m.role == AiRole.user ? 'user' : 'model',
          [TextPart(m.text)],
        ),
      );
    }
    while (contents.isNotEmpty && contents.first.role != 'user') {
      contents.removeAt(0);
    }

    try {
      final chat = model.startChat(history: contents);
      final response = await chat.sendMessage(Content.text(message));
      final reply = response.text;
      if (reply == null || reply.trim().isEmpty) {
        throw StateError('Gemini mengembalikan jawaban kosong.');
      }
      return reply.trim();
    } on GenerativeAIException catch (e) {
      throw StateError(_friendly(e.message, settings.aiModel));
    }
  }

  /// Terjemahkan error SDK ke pesan yang ramah user.
  String _friendly(String message, String model) {
    final lower = message.toLowerCase();
    if (lower.contains('api key') || lower.contains('permission')) {
      return 'API key Gemini tidak valid.';
    }
    if (lower.contains('quota') || lower.contains('resource_exhausted')) {
      return 'Kuota Gemini habis, coba lagi nanti.';
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
