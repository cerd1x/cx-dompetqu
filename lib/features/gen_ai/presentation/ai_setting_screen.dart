import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/widgets/dompet_gradient_background.dart';
import '../application/ai_settings_controller.dart';
import '../application/ai_settings_profiles_controller.dart';
import '../domain/entities/ai_settings.dart';
import '../domain/entities/ai_settings_profile.dart';
import 'ai_settings_profiles_card.dart';
import 'ai_settings_sheet.dart';

/// Layar penuh untuk mengelola profil dan konfigurasi AI.
/// Padanan halaman dari [AiSettingsSheet] yang dipakai sebagai modal —
/// logika pemilihan/edit/hapus profil sama, hanya wadahnya yang berbeda.
class AiSettingScreen extends ConsumerStatefulWidget {
  const AiSettingScreen({super.key});

  @override
  ConsumerState<AiSettingScreen> createState() => _AiSettingScreenState();
}

class _AiSettingScreenState extends ConsumerState<AiSettingScreen> {
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

    return Scaffold(
      body: DompetGradientBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // header section
              _AiSettingHeader(
                title: 'Pengaturan AI',
                onBack: () => context.pop(),
              ),
              const Divider(height: 1, color: Colors.white10),
              // konten section
              Expanded(
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
                          // form konfigurasi section
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
                          )
                        else
                          // Aksi section: membuka form untuk profil baru.
                          Align(
                            alignment: Alignment.centerRight,
                            child: FilledButton.icon(
                              onPressed: () => setState(() {
                                _creatingProfile = true;
                                _editingProfileId = null;
                              }),
                              icon: const Icon(Icons.add),
                              label: const Text('Tambah profil AI'),
                            ),
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

/// Header layar dengan tombol kembali dan judul.
class _AiSettingHeader extends StatelessWidget {
  const _AiSettingHeader({required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_outlined),
            color: Colors.white,
            tooltip: 'Kembali',
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
