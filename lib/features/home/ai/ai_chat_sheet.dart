import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/dompet_brand.dart';
import '../application/ai_controller.dart';
import '../models/ai_message.dart';

/// Bottom sheet percakapan dengan asisten AI — dipanggil dari [AiBubble].
class AiChatSheet extends ConsumerStatefulWidget {
  const AiChatSheet({super.key});

  /// Buka sheet chat di atas route saat ini.
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AiChatSheet(),
    );
  }

  @override
  ConsumerState<AiChatSheet> createState() => _AiChatSheetState();
}

class _AiChatSheetState extends ConsumerState<AiChatSheet> {
  final _inputCtrl = TextEditingController();

  @override
  void dispose() {
    _inputCtrl.dispose();
    super.dispose();
  }

  void _send() {
    final text = _inputCtrl.text.trim();
    if (text.isEmpty) return;
    _inputCtrl.clear();
    ref.read(aiControllerProvider.notifier).send(text);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(aiControllerProvider);
    final mq = MediaQuery.sizeOf(context);

    return Padding(
      // Naik mengikuti keyboard saat mengetik.
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        constraints: BoxConstraints(maxHeight: mq.height * 0.75),
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          border: Border(top: BorderSide(color: DompetBrand.csBorder)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // header section
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 8, 10),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome, color: DompetBrand.primary),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'DompetQu AI',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white38),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Colors.white10),
            // messages section
            Flexible(child: _buildMessages(state)),
            // input section
            SafeArea(top: false, child: _buildInput(state)),
          ],
        ),
      ),
    );
  }

  Widget _buildMessages(AiState state) {
    if (state.messages.isEmpty && !state.sending) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_awesome_outlined,
                size: 36, color: Colors.white.withValues(alpha: 0.15)),
            const SizedBox(height: 10),
            Text(
              'Tanya apa saja tentang dompetmu…',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
            ),
            const SizedBox(height: 24),
          ],
        ),
      );
    }
    // reverse: index 0 = pesan paling baru (auto ikut ke bawah).
    final itemCount = state.messages.length + (state.sending ? 1 : 0);
    return ListView.builder(
      reverse: true,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: itemCount,
      itemBuilder: (_, i) {
        if (state.sending && i == 0) return const _TypingBubble();
        final offset = state.sending ? 1 : 0;
        final message = state.messages[state.messages.length - 1 - (i - offset)];
        return _MessageBubble(message: message);
      },
    );
  }

  Widget _buildInput(AiState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _inputCtrl,
              enabled: !state.sending,
              minLines: 1,
              maxLines: 4,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _send(),
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Tulis pertanyaan…',
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.3),
                ),
                isDense: true,
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.06),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // send button section
          GestureDetector(
            onTap: state.sending ? null : _send,
            child: Opacity(
              opacity: state.sending ? 0.5 : 1,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: DompetBrand.goldBevel,
                ),
                alignment: Alignment.center,
                child: state.sending
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: DompetBrand.blackBg,
                        ),
                      )
                    : const Icon(Icons.send_rounded, color: DompetBrand.onPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final AiMessage message;

  bool get _isUser => message.role == AiRole.user;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: _isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.72,
        ),
        decoration: BoxDecoration(
          color: _isUser
              ? DompetBrand.primary.withValues(alpha: 0.22)
              : Colors.white.withValues(alpha: 0.06),
          border: Border.all(
            color: _isUser ? DompetBrand.csBorder : Colors.white10,
          ),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(14),
            topRight: const Radius.circular(14),
            bottomLeft: Radius.circular(_isUser ? 14 : 4),
            bottomRight: Radius.circular(_isUser ? 4 : 14),
          ),
        ),
        child: Text(
          message.text,
          style: TextStyle(fontSize: 13.5, color: _isUser ? Colors.white : Colors.white.withValues(alpha: 0.85), height: 1.35),
        ),
      ),
    );
  }
}

class _TypingBubble extends StatefulWidget {
  const _TypingBubble();

  @override
  State<_TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<_TypingBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          border: Border.all(color: Colors.white10),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(14),
            bottomRight: Radius.circular(14),
          ),
        ),
        child: FadeTransition(
          opacity: Tween(begin: 0.25, end: 1.0).animate(
            CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.auto_awesome, size: 14, color: DompetBrand.primary),
              SizedBox(width: 8),
              Text('mengetik…', style: TextStyle(fontSize: 12, color: Colors.white54)),
            ],
          ),
        ),
      ),
    );
  }
}
