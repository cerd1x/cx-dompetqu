import 'package:flutter/material.dart';

import 'package:dompetqu/core/theme/dompet_brand.dart';
import 'package:dompetqu/core/theme/widgets/dompet_card.dart';
import 'package:dompetqu/features/gen_ai/domain/entities/ai_settings_profile.dart';
import 'package:dompetqu/features/gen_ai/domain/entities/ai_settings_profile_collection.dart';

class AiSettingsProfilesCard extends StatelessWidget {
  const AiSettingsProfilesCard({
    super.key,
    required this.collection,
    required this.onSelect,
    required this.onEdit,
    required this.onDelete,
    required this.onCreateSettings,
  });

  final AiSettingsProfileCollection collection;
  final ValueChanged<String> onSelect;
  final ValueChanged<AiSettingsProfile> onEdit;
  final ValueChanged<AiSettingsProfile> onDelete;
  final VoidCallback onCreateSettings;

  @override
  Widget build(BuildContext context) {
    return DompetCard(
      variant: DompetCardVariant.csGlassSurface,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Profil konfigurasi AI',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          if (collection.profiles.isEmpty)
            const Padding(
              padding: EdgeInsets.fromLTRB(4, 4, 4, 8),
              child: Text(
                'Belum ada profil tersimpan. Simpan pengaturan saat ini '
                'untuk menggunakannya kembali.',
                style: TextStyle(fontSize: 12, color: Colors.white54),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: collection.profiles.length,
              itemBuilder: (context, index) {
                final profile = collection.profiles[index];
                final selected = profile.id == collection.activeProfileId;
                return ListTile(
                  dense: true,
                  selected: selected,
                  selectedTileColor: Colors.white.withValues(alpha: 0.06),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  leading: Icon(
                    selected ? Icons.radio_button_checked : Icons.tune,
                    color: selected ? DompetBrand.gold : Colors.white54,
                    size: 20,
                  ),
                  title: Text(
                    profile.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    '${profile.provider.label} · ${profile.model}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: selected ? null : () => onSelect(profile.id),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: 'Edit profil ${profile.name}',
                        onPressed: () => onEdit(profile),
                        icon: const Icon(
                          Icons.edit_outlined,
                          color: Colors.white54,
                          size: 20,
                        ),
                      ),
                      IconButton(
                        tooltip: 'Hapus profil ${profile.name}',
                        onPressed: () => onDelete(profile),
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.white54,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          if (collection.profiles.isEmpty)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onCreateSettings,
                icon: const Icon(Icons.add),
                label: const Text('Atur AI'),
              ),
            ),
        ],
      ),
    );
  }
}

class AiSettingsProfileNameDialog extends StatefulWidget {
  const AiSettingsProfileNameDialog({super.key});

  @override
  State<AiSettingsProfileNameDialog> createState() =>
      _AiSettingsProfileNameDialogState();
}

class _AiSettingsProfileNameDialogState
    extends State<AiSettingsProfileNameDialog> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Simpan profil AI'),
      content: TextField(
        controller: _nameController,
        autofocus: true,
        maxLength: 48,
        decoration: const InputDecoration(
          labelText: 'Nama profil',
          hintText: 'Contoh: OpenRouter pribadi',
        ),
        onSubmitted: (value) => Navigator.of(context).pop(value.trim()),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: () =>
              Navigator.of(context).pop(_nameController.text.trim()),
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
