import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mix/mix.dart';

import '../../../core/theme/dompet_brand.dart';
import '../../../core/theme/widgets/cs_select_picker.dart';
import '../../../core/theme/widgets/dompet_card.dart';
import '../application/ai_settings_controller.dart';
import '../application/ai_settings_profiles_controller.dart';
import '../application/ai_settings_repository_provider.dart';
import '../domain/config/openrouter_config.dart';
import '../domain/entities/ai_settings.dart';
import '../domain/entities/ai_settings_profile.dart';
import '../domain/entities/openrouter_model.dart';
import 'ai_settings_profiles_card.dart';

// Model yang ditawarkan untuk tiap provider; Ollama memakai nama model lokal.
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
  AiModelProvider.ollama: [
    CSSelectItem(value: 'llama3.2', label: 'Llama', symbol: '3.2'),
    CSSelectItem(value: 'qwen2.5', label: 'Qwen', symbol: '2.5'),
    CSSelectItem(value: 'mistral', label: 'Mistral', symbol: ''),
  ],
  // OpenRouter memakai katalog model; daftar ini hanya cadangan bila picker
  // preset terakses (ID model OpenRouter memakai prefix vendor).
  AiModelProvider.openRouter: [
    CSSelectItem(
      value: OpenRouterConfig.defaultModel,
      label: 'Gemini',
      symbol: '2.5',
    ),
    CSSelectItem(value: 'google/gemini-2.5-pro', label: 'Pro', symbol: '2.5'),
  ],
};

// Singkatan visual provider yang ditampilkan pada picker.
const Map<AiModelProvider, String> _kProviderSymbols = {
  AiModelProvider.googleAi: 'G',
  AiModelProvider.anthropic: 'A',
  AiModelProvider.openAi: 'O',
  AiModelProvider.ollama: 'L',
  AiModelProvider.openRouter: 'R',
};

/// Menampilkan lembar pengaturan AI beserta profil konfigurasi yang tersimpan.
class AiSettingsSheet extends ConsumerStatefulWidget {
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
  ConsumerState<AiSettingsSheet> createState() => _AiSettingsSheetState();
}

class _AiSettingsSheetState extends ConsumerState<AiSettingsSheet> {
  String? _editingProfileId;
  bool _creatingProfile = false;

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(aiSettingsControllerProvider);
    final profiles = ref.watch(aiSettingsProfilesControllerProvider);
    final activeProfileId = profiles.when(
      data: (collection) => collection.activeProfileId,
      loading: () => null,
      error: (_, _) => null,
    );
    final maxHeight = MediaQuery.sizeOf(context).height * 0.7;

    // Menjaga lembar tetap terlihat saat keyboard membuka area bawah layar.
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      // Membatasi tinggi modal agar kontennya tetap dapat digulir.
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
          // Menjaga header dan konten tetap tersusun dalam satu lembar modal.
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Menyediakan judul dan aksi untuk menutup pengaturan.
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
              // Menampilkan konten sesuai status pemuatan pengaturan.
              Flexible(
                child: settings.when(
                  data: (value) => SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Memungkinkan profil tersimpan dipilih atau dihapus.
                        profiles.when(
                          data: (collection) => AiSettingsProfilesCard(
                            collection: collection,
                            onSelect: (profileId) =>
                                _activateProfile(context, ref, profileId),
                            onEdit: (profile) =>
                                _editProfile(context, ref, profile),
                            onDelete: (profile) =>
                                _deleteProfile(context, ref, profile),
                            onCreateSettings: () => setState(() {
                              _creatingProfile = true;
                              _editingProfileId = null;
                            }),
                          ),
                          loading: () => const Padding(
                            padding: EdgeInsets.all(12),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                          error: (error, _) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              'Gagal memuat profil AI: $error',
                              style: const TextStyle(color: Colors.redAccent),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (_editingProfileId != null || _creatingProfile)
                          AiSettingsSection(
                            key: ValueKey((
                              value.provider,
                              activeProfileId,
                              _editingProfileId,
                              _creatingProfile,
                            )),
                            settings: value,
                            saveButtonLabel: _editingProfileId == null
                                ? 'Simpan konfigurasi sebagai profil'
                                : 'Simpan perubahan profil',
                            onSaveProfile: (snapshot) {
                              final profileId = _editingProfileId;
                              if (profileId == null) {
                                _createProfile(context, ref, snapshot);
                              } else {
                                _updateProfile(
                                  context,
                                  ref,
                                  profileId,
                                  snapshot,
                                );
                              }
                            },
                          ),
                      ],
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

  Future<void> _createProfile(
    BuildContext context,
    WidgetRef ref,
    AiSettings settings,
  ) async {
    final name = await showDialog<String>(
      context: context,
      builder: (_) => const AiSettingsProfileNameDialog(),
    );
    if (!context.mounted || name == null) return;
    if (name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Masukkan nama profil AI.')));
      return;
    }
    try {
      await ref
          .read(aiSettingsProfilesControllerProvider.notifier)
          .createProfile(name, settings);
      if (!context.mounted) return;
      setState(() => _creatingProfile = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profil "$name" disimpan dan diaktifkan.')),
      );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan profil AI: $error')),
      );
    }
  }

  Future<void> _activateProfile(
    BuildContext context,
    WidgetRef ref,
    String profileId,
  ) async {
    try {
      await ref
          .read(aiSettingsProfilesControllerProvider.notifier)
          .activateProfile(profileId);
      if (!context.mounted) return;
      setState(() {
        _editingProfileId = null;
        _creatingProfile = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Profil AI diaktifkan.')));
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengaktifkan profil AI: $error')),
      );
    }
  }

  Future<void> _editProfile(
    BuildContext context,
    WidgetRef ref,
    AiSettingsProfile profile,
  ) async {
    try {
      await ref
          .read(aiSettingsProfilesControllerProvider.notifier)
          .activateProfile(profile.id);
      if (!context.mounted) return;
      setState(() {
        _editingProfileId = profile.id;
        _creatingProfile = false;
      });
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal membuka profil AI: $error')),
      );
    }
  }

  Future<void> _updateProfile(
    BuildContext context,
    WidgetRef ref,
    String profileId,
    AiSettings settings,
  ) async {
    try {
      await ref
          .read(aiSettingsProfilesControllerProvider.notifier)
          .updateProfile(profileId, settings);
      if (!context.mounted) return;
      setState(() => _editingProfileId = null);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Profil AI diperbarui.')));
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui profil AI: $error')),
      );
    }
  }

  Future<void> _deleteProfile(
    BuildContext context,
    WidgetRef ref,
    AiSettingsProfile profile,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus profil AI?'),
        content: Text('Profil "${profile.name}" akan dihapus dari perangkat.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (!context.mounted || confirmed != true) return;
    try {
      await ref
          .read(aiSettingsProfilesControllerProvider.notifier)
          .deleteProfile(profile.id);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profil "${profile.name}" dihapus.')),
      );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus profil AI: $error')),
      );
    }
  }
}

/// Mengelola pilihan provider dan input konfigurasi AI yang dapat diedit.
class AiSettingsSection extends ConsumerStatefulWidget {
  const AiSettingsSection({
    super.key,
    required this.settings,
    required this.onSaveProfile,
    this.saveButtonLabel = 'Simpan konfigurasi sebagai profil',
  });

  final AiSettings settings;
  final ValueChanged<AiSettings> onSaveProfile;
  final String saveButtonLabel;

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
  bool _loadingOpenRouterModels = false;
  // Membuat input header berdasarkan konfigurasi provider yang tersimpan.
  late final List<_AiHeaderField> _headerFields = [
    for (final entry in widget.settings.customHeaders.entries)
      _AiHeaderField(name: entry.key, value: entry.value),
  ];

  // Provider eksplisit menang; deteksi URL tetap dipertahankan untuk profil
  // lama yang memakai provider lain dengan base URL OpenRouter.
  bool get _isOpenRouter =>
      widget.settings.provider == AiModelProvider.openRouter ||
      OpenRouterConfig.isBaseUrl(widget.settings.baseUrl);

  String get _providerSettingsLabel =>
      _isOpenRouter ? OpenRouterConfig.label : widget.settings.provider.label;

  bool get _supportsCustomHeaders =>
      widget.settings.provider == AiModelProvider.openAi ||
      widget.settings.provider == AiModelProvider.ollama ||
      widget.settings.provider == AiModelProvider.openRouter;

  List<CSSelectItem<String>> get _modelOptions {
    final options = _kProviderModels[widget.settings.provider]!;
    if (options.any((option) => option.value == widget.settings.model)) {
      return options;
    }
    return [
      CSSelectItem(
        value: widget.settings.model,
        label: widget.settings.model,
        symbol: 'Custom',
      ),
      ...options,
    ];
  }

  @override
  void dispose() {
    _apiKeyCtrl.dispose();
    _modelCtrl.dispose();
    _baseUrlCtrl.dispose();
    for (final field in _headerFields) {
      field.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DompetCard(
      variant: DompetCardVariant.csGlassSurface,
      padding: EdgeInsets.zero,
      child: Column(
        // Daftar pengaturan provider, bubble, kredensial, model, dan request.
        children: [
          // Memilih layanan AI yang digunakan untuk percakapan.
          AiSettingRow(
            icon: Icons.hub_outlined,
            label: 'Provider model',
            trailing: CSSelectPicker<AiModelProvider>(
              items: [
                // Ubah enum provider menjadi opsi picker berlabel.
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
          // Mengatur apakah tombol AI melayang tampil di Home.
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
          // API key hanya diperlukan untuk provider cloud.
          if (widget.settings.provider != AiModelProvider.ollama) ...[
            // Mengontrol visibilitas API key tanpa mengekspos nilainya.
            AiSettingRow(
              icon: Icons.key,
              label: '$_providerSettingsLabel API key',
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
                // Input API key dan aksi menyimpannya.
                children: [
                  Expanded(
                    child: TextField(
                      controller: _apiKeyCtrl,
                      obscureText: !_apiKeyVisible,
                      style: const TextStyle(fontSize: 13, color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Masukkan API key $_providerSettingsLabel…',
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
          // Mengaktifkan input teks untuk model yang tidak ada di daftar.
          AiSettingRow(
            icon: Icons.edit_outlined,
            label: 'Model kustom (input teks)',
            trailing: Switch(
              value: widget.settings.useCustomModel,
              activeTrackColor: DompetBrand.gold,
              onChanged: _saveUseCustomModel,
            ),
          ),
          Divider(height: 1, color: Colors.white.withValues(alpha: 0.08)),
          // Memasukkan ID model bebas atau memilih model yang tersedia.
          AiSettingRow(
            icon: Icons.auto_awesome,
            label: 'Model $_providerSettingsLabel',
            trailing: Row(
              // Mode teks mendukung ID custom; mode pilihan memakai preset.
              children: [
                widget.settings.useCustomModel
                    ? SizedBox(
                        width: 150,
                        child: TextField(
                          controller: _modelCtrl,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Contoh: llama3.2',
                            isDense: true,
                          ),
                          onSubmitted: _saveModel,
                        ),
                      )
                    : _isOpenRouter
                    ? TextButton.icon(
                        onPressed: _loadingOpenRouterModels
                            ? null
                            : _chooseOpenRouterModel,
                        icon: _loadingOpenRouterModels
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.search, size: 16),
                        label: Text(
                          _loadingOpenRouterModels ? 'Memuat' : 'Pilih model',
                        ),
                      )
                    : CSSelectPicker<String>(
                        items: _modelOptions,
                        value: widget.settings.model,
                        onChanged: _saveModel,
                      ),
              ],
            ),
          ),
          if (_isOpenRouter && !widget.settings.useCustomModel)
            Padding(
              padding: const EdgeInsets.fromLTRB(44, 0, 12, 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Model terpilih: ${widget.settings.model}',
                  style: const TextStyle(fontSize: 11, color: Colors.white54),
                ),
              ),
            ),
          // Endpoint dapat dikustomisasi untuk API OpenAI-compatible.
          if (widget.settings.provider == AiModelProvider.openAi ||
              widget.settings.provider == AiModelProvider.ollama ||
              widget.settings.provider == AiModelProvider.openRouter) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _baseUrlCtrl,
                      style: const TextStyle(fontSize: 13, color: Colors.white),
                      decoration: InputDecoration(
                        labelText: '$_providerSettingsLabel base URL',
                        hintText: widget.settings.provider.defaultBaseUrl,
                        isDense: true,
                      ),
                      onSubmitted: _saveBaseUrl,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    tooltip: 'Simpan base URL',
                    onPressed: () => _saveBaseUrl(_baseUrlCtrl.text),
                    icon: const Icon(Icons.save_outlined),
                  ),
                ],
              ),
            ),
          ],
          // Headers opsional untuk endpoint OpenAI-compatible.
          if (_supportsCustomHeaders) ...[
            AiSettingRow(
              icon: Icons.http_outlined,
              label: 'Sertakan custom headers',
              trailing: Switch(
                value: widget.settings.includeCustomHeaders,
                activeTrackColor: DompetBrand.gold,
                onChanged: _saveIncludeCustomHeaders,
              ),
            ),
            if (widget.settings.includeCustomHeaders) ...[
              // Setiap baris mewakili satu pasangan nama dan nilai header.
              for (var index = 0; index < _headerFields.length; index++)
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 8, 8),
                  child: Row(
                    // Mengedit header atau menghapus baris ini.
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _headerFields[index].name,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Header',
                            hintText: 'X-Title',
                            isDense: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _headerFields[index].value,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Value',
                            hintText: 'DompetQu',
                            isDense: true,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Hapus header',
                        onPressed: () => _removeHeader(index),
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: Row(
                  // Menambah baris header dan menyimpan seluruh pasangan.
                  children: [
                    TextButton.icon(
                      onPressed: _addHeader,
                      icon: const Icon(Icons.add),
                      label: const Text('Tambah header'),
                    ),
                    const Spacer(),
                    IconButton.filled(
                      tooltip: 'Simpan custom headers',
                      onPressed: _saveCustomHeaders,
                      icon: const Icon(Icons.save_outlined),
                    ),
                  ],
                ),
              ),
            ],
          ],
          const Divider(height: 1, color: Colors.white10),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: _saveProfileSnapshot,
                icon: const Icon(Icons.bookmark_add_outlined),
                label: Text(widget.saveButtonLabel),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveProfileSnapshot() {
    final customHeaders = <String, String>{};
    final headerNames = <String>{};
    for (final field in _headerFields) {
      final name = field.name.text.trim();
      if (name.isEmpty) continue;
      if (!headerNames.add(name.toLowerCase())) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nama header tidak boleh duplikat.')),
        );
        return;
      }
      customHeaders[name] = field.value.text.trim();
    }

    final model = widget.settings.useCustomModel
        ? _modelCtrl.text.trim()
        : widget.settings.model;
    if (model.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID model tidak boleh kosong.')),
      );
      return;
    }

    widget.onSaveProfile(
      widget.settings.copyWith(
        apiKey: _apiKeyCtrl.text,
        model: model,
        baseUrl: _supportsCustomHeaders
            ? _baseUrlCtrl.text.trim()
            : widget.settings.baseUrl,
        customHeaders: customHeaders,
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

  Future<void> _chooseOpenRouterModel() async {
    setState(() => _loadingOpenRouterModels = true);
    late final List<OpenRouterModel> models;
    try {
      models = await ref
          .read(openRouterModelRepositoryProvider)
          .loadModels(
            baseUrl: widget.settings.baseUrl,
            apiKey: widget.settings.apiKey,
            headers: widget.settings.includeCustomHeaders
                ? widget.settings.customHeaders
                : const {},
          );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat model OpenRouter: $error')),
      );
      return;
    } finally {
      if (mounted) setState(() => _loadingOpenRouterModels = false);
    }

    if (!mounted) return;
    if (models.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Katalog model OpenRouter kosong.')),
      );
      return;
    }

    final selectedModel = await showDialog<String>(
      context: context,
      builder: (_) => _OpenRouterModelPickerDialog(
        models: models,
        selectedModel: widget.settings.model,
      ),
    );
    if (selectedModel != null) await _saveModel(selectedModel);
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
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Base URL disimpan.')));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan base URL: $error')),
      );
    }
  }

  void _addHeader() {
    setState(() => _headerFields.add(_AiHeaderField()));
  }

  void _removeHeader(int index) {
    final field = _headerFields.removeAt(index);
    field.dispose();
    setState(() {});
  }

  Future<void> _saveIncludeCustomHeaders(bool include) async {
    try {
      await ref
          .read(aiSettingsControllerProvider.notifier)
          .setIncludeCustomHeaders(include);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan pengaturan headers: $error')),
      );
    }
  }

  Future<void> _saveUseCustomModel(bool useCustom) async {
    try {
      await ref
          .read(aiSettingsControllerProvider.notifier)
          .setUseCustomModel(useCustom);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengubah mode input model: $error')),
      );
    }
  }

  Future<void> _saveCustomHeaders() async {
    final headers = <String, String>{};
    final names = <String>{};
    for (final field in _headerFields) {
      final name = field.name.text.trim();
      if (name.isEmpty) continue;
      if (!names.add(name.toLowerCase())) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nama header tidak boleh duplikat.')),
        );
        return;
      }
      headers[name] = field.value.text.trim();
    }
    try {
      await ref
          .read(aiSettingsControllerProvider.notifier)
          .setCustomHeaders(headers);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Custom headers disimpan.')));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan custom headers: $error')),
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

/// Menyediakan pencarian dan pemilihan model dari katalog OpenRouter.
class _OpenRouterModelPickerDialog extends StatefulWidget {
  const _OpenRouterModelPickerDialog({
    required this.models,
    required this.selectedModel,
  });

  final List<OpenRouterModel> models;
  final String selectedModel;

  @override
  State<_OpenRouterModelPickerDialog> createState() =>
      _OpenRouterModelPickerDialogState();
}

class _OpenRouterModelPickerDialogState
    extends State<_OpenRouterModelPickerDialog> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  List<OpenRouterModel> get _filteredModels {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return widget.models;
    return widget.models
        .where(
          (model) =>
              model.id.toLowerCase().contains(query) ||
              model.name.toLowerCase().contains(query),
        )
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final models = _filteredModels;
    return AlertDialog(
      title: const Text('Pilih model OpenRouter'),
      content: SizedBox(
        width: 460,
        height: 480,
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              autofocus: true,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Cari nama atau ID model',
              ),
              onChanged: (value) => setState(() => _query = value),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: models.isEmpty
                  ? const Center(child: Text('Model tidak ditemukan.'))
                  : ListView.builder(
                      itemCount: models.length,
                      itemBuilder: (context, index) {
                        final model = models[index];
                        final selected = model.id == widget.selectedModel;
                        return ListTile(
                          dense: true,
                          title: Text(
                            model.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            model.contextLength == null
                                ? model.id
                                : '${model.id} · ${model.contextLength} token konteks',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: selected
                              ? const Icon(Icons.check, color: DompetBrand.gold)
                              : null,
                          onTap: () => Navigator.of(context).pop(model.id),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Tutup'),
        ),
      ],
    );
  }
}

class _AiHeaderField {
  _AiHeaderField({String name = '', String value = ''})
    : name = TextEditingController(text: name),
      value = TextEditingController(text: value);

  final TextEditingController name;
  final TextEditingController value;

  void dispose() {
    name.dispose();
    value.dispose();
  }
}

/// Menyusun satu baris pengaturan dengan ikon, label, dan kontrol aksi.
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
