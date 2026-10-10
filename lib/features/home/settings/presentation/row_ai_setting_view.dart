import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/dompet_brand.dart';
import '../../../../core/theme/widgets/cs_select_picker.dart';
import '../../../../core/theme/widgets/dompet_card.dart';
import '../application/settings_controller.dart';

/// Daftar model Gemini (hardcode sementara sebagai contoh).
const List<CSSelectItem<String>> _kGeminiModels = [
  CSSelectItem(value: 'gemini-2.5-flash', label: 'Flash', symbol: '2.5'),
  CSSelectItem(value: 'gemini-2.5-pro', label: 'Pro', symbol: '2.5'),
  CSSelectItem(value: 'gemini-2.0-flash', label: 'Flash', symbol: '2.0'),
  CSSelectItem(value: 'gemini-1.5-flash', label: 'Flash', symbol: '1.5'),
];

/// Grup pengaturan AI — membuka sheet chat AI, konfigurasi API key, dan
/// pemilihan model Gemini. Ditampilkan sebagai satu kartu dengan tiga baris.
class AiSettingsSection extends ConsumerStatefulWidget {
  const AiSettingsSection({super.key});

  @override
  ConsumerState<AiSettingsSection> createState() => _AiSettingsSectionState();
}

class _AiSettingsSectionState extends ConsumerState<AiSettingsSection> {
  final _apiKeyCtrl = TextEditingController();
  bool _apiKeyVisible = false;

  @override
  void dispose() {
    _apiKeyCtrl.dispose();
    super.dispose();
  }

  void _selectModel(String value) {
    ref.read(settingsControllerProvider.notifier).setAiModel(value);
  }

  void _saveApiKey(String value) {
    ref.read(settingsControllerProvider.notifier).setAiApiKey(value);
  }

  @override
  Widget build(BuildContext context) {
    final settings =
        ref.watch(settingsControllerProvider).value ?? const AppSettings();
    // Sinkronkan nilai api key dari settings ke field bila beda.
    if (_apiKeyCtrl.text != settings.aiApiKey) {
      final pos = _apiKeyCtrl.selection;
      _apiKeyCtrl.text = settings.aiApiKey;
      _apiKeyCtrl.selection = TextSelection.collapsed(
        offset: pos.baseOffset.clamp(0, _apiKeyCtrl.text.length),
      );
    }
    final model = settings.aiModel;

    return DompetCard(
      variant: DompetCardVariant.csGlassSurface,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          // AI assistant section — membuka route chat AI.
          _buildRow(
            icon: Icons.auto_awesome,
            label: 'AI Assistant',
            onTap: () => context.push('/gen-ai'),
            trailing: const Icon(
              Icons.chevron_right,
              size: 20,
              color: Colors.white54,
            ),
          ),
          _buildDivider(),
          // API key section — klik untuk perluas/tutup key.
          _buildRow(
            icon: Icons.key,
            label: 'API Key',
            trailing: GestureDetector(
              onTap: () => setState(() => _apiKeyVisible = !_apiKeyVisible),
              child: Icon(
                _apiKeyVisible
                    ? Icons.keyboard_arrow_down
                    : Icons.chevron_right,
                size: 20,
                color: Colors.white54,
              ),
            ),
          ),
          // expanded API key input — tampil saat _apiKeyVisible true.
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            alignment: Alignment.topCenter,
            child: _apiKeyVisible
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                    child: TextField(
                      controller: _apiKeyCtrl,
                      obscureText: true,
                      style: const TextStyle(fontSize: 13, color: Colors.white),
                      onChanged: _saveApiKey,
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
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          _buildDivider(),
          // model section — tampil/pilih model Gemini via dropdown.
          _buildRow(
            icon: Icons.auto_awesome,
            label: 'Model',
            trailing2: CSSelectPicker<String>(
              items: _kGeminiModels,
              value: model.isNotEmpty ? model : kDefaultAiModel,
              onChanged: _selectModel,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow({
    required IconData icon,
    required String label,
    Widget? trailing,
    Widget? trailing2,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Icon(icon, size: 20, color: DompetBrand.purple),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
            if (trailing2 != null) ...[trailing2, const SizedBox(width: 8)],
            trailing ?? const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() =>
      Divider(height: 1, color: Colors.white.withValues(alpha: 0.08));
}
