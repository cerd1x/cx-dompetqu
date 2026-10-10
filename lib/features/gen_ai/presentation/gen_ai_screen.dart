import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mix/mix.dart';

import '../../../core/theme/dompet_brand.dart';
import 'package:dompetqu/features/gen_ai/presentation/ai_chat_sheet.dart';

class GenAiScreen extends StatelessWidget {
  const GenAiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DompetQu AI'),
        leading: IconButton(
          tooltip: 'Kembali',
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Box(
        style: BoxStyler().decoration(
          DecorationMix.value(
            const BoxDecoration(color: DompetBrand.background),
          ),
        ),
        child: const AiChatConversation(),
      ),
    );
  }
}
