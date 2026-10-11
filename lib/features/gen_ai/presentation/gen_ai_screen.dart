import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mix/mix.dart';

import '../../../core/theme/dompet_brand.dart';
import '../../home/widgets/bottom_bar.dart';
import 'package:dompetqu/features/gen_ai/presentation/ai_chat_sheet.dart';

class GenAiScreen extends StatelessWidget {
  const GenAiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Box(
        style: BoxStyler().decoration(
          DecorationMix.value(
            const BoxDecoration(color: DompetBrand.background),
          ),
        ),
        child: const AiChatConversation(),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: TabBottomBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Semantics(
                  button: true,
                  label: 'Kembali',
                  child: InkWell(
                    onTap: () {
                      if (context.canPop()) {
                        context.pop();
                        return;
                      }
                      context.go('/');
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.arrow_back, color: DompetBrand.goldLight),
                          SizedBox(height: 4),
                          Text('Kembali', style: TextStyle(fontSize: 11)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Semantics(
                  button: true,
                  label: 'Pengaturan',
                  child: InkWell(
                    onTap: () => context.push('/settings'),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.settings, color: DompetBrand.goldLight),
                          SizedBox(height: 4),
                          Text('Pengaturan', style: TextStyle(fontSize: 11)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Semantics(
                  button: true,
                  label: 'Tambah MCP',
                  child: InkWell(
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Integrasi MCP belum tersedia.'),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add_link, color: DompetBrand.goldLight),
                          SizedBox(height: 4),
                          Text('Tambah MCP', style: TextStyle(fontSize: 11)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Semantics(
                  button: true,
                  label: 'Skills',
                  child: InkWell(
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Skills belum tersedia.'),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.auto_awesome, color: DompetBrand.goldLight),
                          SizedBox(height: 4),
                          Text('Skills', style: TextStyle(fontSize: 11)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
