import 'package:dompetqu/features/home/assets/asset_picker_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/widgets/cs_modal_top_sheet.dart';
import '../application/contacts_controller.dart';
import '../models/contact.dart';

/// Picker customer dari [contactsControllerProvider].
class CustomerPickerField extends ConsumerWidget {
  const CustomerPickerField({
    super.key,
    required this.selectedId,
    required this.onChanged,
  });

  final String? selectedId;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contacts = ref.watch(contactsControllerProvider).items;
    Contact? selected;
    for (final c in contacts) {
      if (c.id == selectedId) {
        selected = c;
        break;
      }
    }

    return FieldTile(
      label: 'Customer',
      value: selected?.name ?? 'Pilih customer...',
      leading: Icons.person_outline,
      onTap: () async {
        // Picker harus memuat seluruh kontak, bukan hanya halaman list yang
        // sudah tampil.
        await ref.read(contactsControllerProvider.notifier).ensureAllLoaded();
        if (!context.mounted) return;
        final all = ref.read(contactsControllerProvider).items;
        final picked = await showCsModalTopBar<String>(
          context: context,
          builder: (sheetCtx) =>
              _CustomerPickerSheet(contacts: all, selectedId: selectedId),
        );
        if (picked != null) onChanged(picked);
      },
    );
  }
}

class _CustomerPickerSheet extends StatefulWidget {
  const _CustomerPickerSheet({required this.contacts, this.selectedId});

  final List<Contact> contacts;
  final String? selectedId;

  @override
  State<_CustomerPickerSheet> createState() => _CustomerPickerSheetState();
}

class _CustomerPickerSheetState extends State<_CustomerPickerSheet> {
  final _ctrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _query.isEmpty
        ? widget.contacts
        : widget.contacts
              .where((c) => c.name.toLowerCase().contains(_query.toLowerCase()))
              .toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: filtered.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'Kontak kosong',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white38),
                  ),
                )
              : ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: Text(
                        'Customer',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    for (final contact in filtered)
                      ListTile(
                        leading: const Icon(
                          Icons.person_outline,
                          color: Colors.white70,
                        ),
                        title: Text(
                          contact.name,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          contact.phone ?? contact.email ?? '',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.white38,
                          ),
                        ),
                        trailing: contact.id == widget.selectedId
                            ? const Icon(Icons.check, color: Color(0xFF34D399))
                            : null,
                        onTap: () => Navigator.of(context).pop(contact.id),
                      ),
                    const SizedBox(height: 8),
                  ],
                ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: TextField(
            controller: _ctrl,
            onChanged: (v) => setState(() => _query = v),
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Cari customer...',
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
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
              prefixIcon: const Icon(
                Icons.search,
                size: 18,
                color: Colors.white38,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
