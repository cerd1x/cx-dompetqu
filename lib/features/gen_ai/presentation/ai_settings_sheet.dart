import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mix/mix.dart';

import '../../../core/theme/dompet_brand.dart';
import '../../../core/theme/widgets/cs_select_picker.dart';
import '../../../core/theme/widgets/dompet_card.dart';
import '../application/ai_settings_controller.dart';
import '../domain/entities/ai_settings.dart';

const Map<AiModelProvider, List<CSSelectItem<String>>> _kProviderModels = {
  AiModelProvider.googleAi: [
    CSSelectItem(value: 'gemini-2.5-flash', label: 'Flash', symbol: '2.5'),
    CSSelectItem(value: 'gemini-2.5-pro', label: 'Pro', symbol: '2.5'),
    CSSelectItem(value: 'gemini-2.0-flash', label: 'Flash', symbol: '2.0'),
    CSSelectItem(value: 'gemini-1.5-flash', label: 'Flash', symbol: '1.5'),
  ],
  AiModelProvider.anthropic: [
    CSSelectItem(value: 'claude-sonnet-4-5', label: 'Sonnet', symbol: '4.5'),
    CSSelectItem(value: 'claude-haiku-4-5', label: 'Haiku', symbol: '4.5'),
    CSSelectItem(value: 'claude-opus-4-1', label: 'Opus', symbol: '4.1'),
  ],
  AiModelProvider.openAi: [
    CSSelectItem(value: 'gpt-5-mini', label: 'GPT', symbol: '5 mini'),
    CSSelectItem(value: 'gpt-5', label: 'GPT', symbol: '5'),
    CSSelectItem(value: 'gpt-4.1-mini', label: 'GPT', symbol: '4.1 mini'),
  ],
  AiModelProvider.ollama: [],
};

const Map<AiModelProvider, String> _kProviderSymbols = {
  AiModelProvider.googleAi: 'G',
  AiModelProvider.anthropic: 'A',
  AiModelProvider.openAi: 'O',
  AiModelProvider.ollama: 'L',
};

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
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                    child: AiSettingsSection(
                      key: ValueKey(value.provider),
                      settings: value,
                    ),
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
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
  late final TextEditingController _modelCtrl = TextEditingController(
    text: widget.settings.model,
  );
  late final TextEditingController _baseUrlCtrl = TextEditingController(
    text: widget.settings.baseUrl,
  );
  bool _apiKeyVisible = false;

  @override
  void dispose() {
    _apiKeyCtrl.dispose();
    _modelCtrl.dispose();
    _baseUrlCtrl.dispose();
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
            icon: Icons.hub_outlined,
            label: 'Provider model',
            trailing: CSSelectPicker<AiModelProvider>(
              items: [
                for (final provider in AiModelProvider.values)
                  CSSelectItem(
                    value: provider,
                    label: provider.label,
                    symbol: _kProviderSymbols[provider]!,
                  ),
              ],
              value: widget.settings.provider,
              onChanged: _saveProvider,
            ),
          ),
          Divider(height: 1, color: Colors.white.withValues(alpha: 0.08)),
          AiSettingRow(
            icon: Icons.smart_toy_outlined,
            label: 'Tampilkan AI Bubble di Home',
            trailing: Switch(
              value: widget.settings.showAiBubble,
              activeTrackColor: DompetBrand.gold,
              onChanged: _saveAiBubbleVisibility,
            ),
          ),
          Divider(height: 1, color: Colors.white.withValues(alpha: 0.08)),
          if (widget.settings.provider != AiModelProvider.ollama) ...[
            AiSettingRow(
              icon: Icons.key,
              label: '${widget.settings.provider.label} API key',
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
                        hintText:
                            'Masukkan API key ${widget.settings.provider.label}…',
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
          ],
          AiSettingRow(
            icon: Icons.auto_awesome,
            label: 'Model ${widget.settings.provider.label}',
            trailing: widget.settings.provider == AiModelProvider.ollama
                ? SizedBox(
                    width: 150,
                    child: TextField(
                      controller: _modelCtrl,
                      style: const TextStyle(fontSize: 13, color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Contoh: llama3.2',
                        isDense: true,
                      ),
                      onSubmitted: _saveModel,
                    ),
                  )
                : CSSelectPicker<String>(
                    items: _kProviderModels[widget.settings.provider]!,
                    value: widget.settings.model,
                    onChanged: _saveModel,
                  ),
          ),
          if (widget.settings.provider == AiModelProvider.ollama) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: TextField(
                controller: _baseUrlCtrl,
                style: const TextStyle(fontSize: 13, color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Ollama base URL',
                  hintText: 'http://localhost:11434/v1',
                  isDense: true,
                ),
                onSubmitted: _saveBaseUrl,
              ),
            ),
          ],
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

  Future<void> _saveProvider(AiModelProvider provider) async {
    try {
      await ref
          .read(aiSettingsControllerProvider.notifier)
          .setProvider(provider);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengganti provider AI: $error')),
      );
    }
  }

  Future<void> _saveBaseUrl(String baseUrl) async {
    try {
      await ref
          .read(aiSettingsControllerProvider.notifier)
          .setBaseUrl(baseUrl.trim());
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan URL Ollama: $error')),
      );
    }
  }

  Future<void> _saveAiBubbleVisibility(bool visible) async {
    try {
      await ref
          .read(aiSettingsControllerProvider.notifier)
          .setAiBubbleVisibility(visible);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan pengaturan AI Bubble: $error')),
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
