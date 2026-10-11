import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mix/mix.dart';

import '../../../core/theme/dompet_brand.dart';
import '../../../core/theme/widgets/cs_select_picker.dart';
import '../../../core/theme/widgets/dompet_card.dart';
import '../application/ai_settings_controller.dart';
import '../models/ai_settings.dart';

const List<CSSelectItem<String>> _kGeminiModels = [
  CSSelectItem(value: 'gemini-2.5-flash', label: 'Flash', symbol: '2.5'),
  CSSelectItem(value: 'gemini-2.5-pro', label: 'Pro', symbol: '2.5'),
  CSSelectItem(value: 'gemini-2.0-flash', label: 'Flash', symbol: '2.0'),
  CSSelectItem(value: 'gemini-1.5-flash', label: 'Flash', symbol: '1.5'),
];

class AiSettingsSheet extends ConsumerWidget {
  const AiSettingsSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      routeSettings: const RouteSettings(name: 'ai-settings-sheet'),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AiSettingsSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(aiSettingsControllerProvider);
    final maxHeight = MediaQuery.sizeOf(context).height * 0.7;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Box(
        style: BoxStyler()
            .constraints(
              BoxConstraintsMix.value(BoxConstraints(maxHeight: maxHeight)),
            )
            .decoration(
              DecorationMix.value(
                const BoxDecoration(
                  color: Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  border: Border(top: BorderSide(color: DompetBrand.csBorder)),
                ),
              ),
            ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 12, 12),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Pengaturan AI',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Tutup',
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Colors.white10),
              Flexible(
                child: settings.when(
                  data: (value) => SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: AiSettingsSection(settings: value),
                  ),
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, _) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'Gagal memuat pengaturan AI: $error',
                        textAlign: TextAlign.center,
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

class AiSettingsSection extends ConsumerStatefulWidget {
  const AiSettingsSection({super.key, required this.settings});

  final AiSettings settings;

  @override
  ConsumerState<AiSettingsSection> createState() => _AiSettingsSectionState();
}

class _AiSettingsSectionState extends ConsumerState<AiSettingsSection> {
  late final TextEditingController _apiKeyCtrl = TextEditingController(
    text: widget.settings.apiKey,
  );
  bool _apiKeyVisible = false;

  @override
  void dispose() {
    _apiKeyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DompetCard(
      variant: DompetCardVariant.csGlassSurface,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          AiSettingRow(
            icon: Icons.key,
            label: 'API Key',
            trailing: IconButton(
              tooltip: _apiKeyVisible
                  ? 'Sembunyikan API key'
                  : 'Tampilkan API key',
              onPressed: () =>
                  setState(() => _apiKeyVisible = !_apiKeyVisible),
              icon: Icon(
                _apiKeyVisible
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 20,
                color: Colors.white54,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _apiKeyCtrl,
                    obscureText: !_apiKeyVisible,
                    style: const TextStyle(fontSize: 13, color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Masukkan API key Gemini…',
                      hintStyle: TextStyle(
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.06),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => _saveApiKey(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  tooltip: 'Simpan API key',
                  onPressed: _saveApiKey,
                  icon: const Icon(Icons.save_outlined),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.white.withValues(alpha: 0.08)),
          AiSettingRow(
            icon: Icons.auto_awesome,
            label: 'Model',
            trailing: CSSelectPicker<String>(
              items: _kGeminiModels,
              value: widget.settings.model.isNotEmpty
                  ? widget.settings.model
                  : kDefaultAiModel,
              onChanged: _saveModel,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveApiKey() async {
    try {
      await ref
          .read(aiSettingsControllerProvider.notifier)
          .setApiKey(_apiKeyCtrl.text);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('API key AI disimpan.')));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan API key: $error')),
      );
    }
  }

  Future<void> _saveModel(String model) async {
    try {
      await ref.read(aiSettingsControllerProvider.notifier).setModel(model);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan model AI: $error')),
      );
    }
  }

}

class AiSettingRow extends StatelessWidget {
  const AiSettingRow({
    super.key,
    required this.icon,
    required this.label,
    required this.trailing,
  });

  final IconData icon;
  final String label;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 20, color: DompetBrand.purple),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
          trailing,
        ],
      ),
    );
  }
}
