import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mix/mix.dart';

import '../../../core/theme/dompet_brand.dart';
import '../../home/widgets/bottom_bar.dart';
import '../application/ai_skills_controller.dart';
import '../application/mcp_controller.dart';
import 'ai_chat_sheet.dart';
import 'ai_settings_sheet.dart';
import 'ai_skills_sheet.dart';
import 'mcp_sheet.dart';

class GenAiScreen extends ConsumerWidget {
  const GenAiScreen({super.key});

  Future<void> _openSkills(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(aiSkillsControllerProvider.future);
    } catch (error) {
      if (!context.mounted) return;
      _showError(context, 'Gagal memuat skills', error);
      return;
    }
    if (!context.mounted) return;

    while (context.mounted) {
      final skills = ref.read(aiSkillsControllerProvider).value ?? const [];
      final action = await showModalBottomSheet<AiSkillAction>(
        context: context,
        routeSettings: const RouteSettings(name: 'ai-skills-sheet'),
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => AiSkillsSheet(skills: skills),
      );
      if (!context.mounted || action == null) return;

      try {
        switch (action) {
          case CreateAiSkill(:final name, :final instructions):
            await ref
                .read(aiSkillsControllerProvider.notifier)
                .create(name: name, instructions: instructions);
          case ImportAiSkill(:final name, :final url):
            await ref
                .read(aiSkillsControllerProvider.notifier)
                .importFromUrl(name: name, url: url);
          case DeleteAiSkill(:final id):
            await ref
                .read(aiSkillsControllerProvider.notifier)
                .remove(id);
        }
      } catch (error) {
        if (!context.mounted) return;
        _showError(context, 'Gagal memproses skill', error);
        return;
      }
      if (!context.mounted) return;
    }
  }

  Future<void> _openMcp(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(mcpControllerProvider.future);
    } catch (error) {
      if (!context.mounted) return;
      _showError(context, 'Gagal memuat konfigurasi MCP', error);
      return;
    }
    if (!context.mounted) return;

    while (context.mounted) {
      final servers = ref.read(mcpControllerProvider).value ?? const [];
      final action = await showModalBottomSheet<McpAction>(
        context: context,
        routeSettings: const RouteSettings(name: 'mcp-management-sheet'),
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => McpSheet(servers: servers),
      );
      if (!context.mounted || action == null) return;

      try {
        switch (action) {
          case AddMcpServer(:final name, :final url):
            await ref
                .read(mcpControllerProvider.notifier)
                .add(name: name, url: url);
          case RemoveMcpServer(:final id):
            await ref.read(mcpControllerProvider.notifier).remove(id);
        }
      } catch (error) {
        if (!context.mounted) return;
        _showError(context, 'Gagal memproses konfigurasi MCP', error);
        return;
      }
      if (!context.mounted) return;
    }
  }

  void _showError(BuildContext context, String message, Object error) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$message: $error')));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    onTap: () => AiSettingsSheet.show(context),
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
                    onTap: () => _openMcp(context, ref),
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
                    onTap: () => _openSkills(context, ref),
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
