import 'package:flutter/material.dart';

import '../../../core/theme/cs_dialog.dart';
import '../../../core/theme/dompet_brand.dart';
import '../../../core/theme/widgets/dompet_button.dart';
import '../application/contacts_controller.dart';
import '../models/contact.dart';

/// Dialog investigasi kontak duplikat — menampilkan grup kontak yang
/// kemungkinan duplikat (nomor sama beda nama, atau nama sama beda nomor).
///
/// Dipakai oleh `contacts_screen.dart` saat user membuka form
/// (add/edit) dan ditemukan duplikat di state.
class DuplicateContactsInvestigationDialog extends StatefulWidget {
  const DuplicateContactsInvestigationDialog({
    super.key,
    required this.groups,
    this.onMergeGroup,
  });

  final List<ContactDuplicateGroup> groups;

  /// Gabungkan satu grup: semua [ContactDuplicateGroup.contacts] (kecuali
  /// [primary] yang dipilih user) digabung ke [Contact] primary tersebut.
  final Future<void> Function(Contact primary, List<Contact> duplicates)?
      onMergeGroup;

  @override
  State<DuplicateContactsInvestigationDialog> createState() =>
      _DuplicateContactsInvestigationDialogState();
}

class _DuplicateContactsInvestigationDialogState
    extends State<DuplicateContactsInvestigationDialog> {
  /// Id kontak yang dipilih sebagai primary per grup (keyed by group key).
  final Map<String, String> _selectedIds = {};

  /// Group key yang sedang digabung (menampilkan spinner).
  final Set<String> _mergingGroups = {};

  /// Group key yang sudah selesai digabung (disembunyikan).
  final Set<String> _doneGroups = {};

  List<ContactDuplicateGroup> get _visible =>
      widget.groups.where((g) => !_doneGroups.contains(g.key)).toList();

  Contact _selectedFor(ContactDuplicateGroup group) {
    final id = _selectedIds[group.key];
    if (id == null) return group.contacts.first;
    return group.contacts.firstWhere(
      (c) => c.id == id,
      orElse: () => group.contacts.first,
    );
  }

  Future<void> _mergeGroup(ContactDuplicateGroup group) async {
    final cb = widget.onMergeGroup;
    if (cb == null || _mergingGroups.contains(group.key)) return;
    final primary = _selectedFor(group);
    final duplicates = group.contacts
        .where((c) => c.id != primary.id)
        .toList();
    setState(() => _mergingGroups.add(group.key));
    try {
      await cb(primary, duplicates);
      if (!mounted) return;
      setState(() {
        _mergingGroups.remove(group.key);
        _doneGroups.add(group.key);
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _mergingGroups.remove(group.key));
    }
  }

  Future<void> _mergeAll() async {
    for (final group in _visible.toList()) {
      if (!mounted) return;
      await _mergeGroup(group);
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Kontak duplikat telah digabungkan'),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visible;
    final hasDuplicates = visible.isNotEmpty;
    final allMerging = _mergingGroups.length == widget.groups.length;
    return CsDialog(
      title: 'Investigasi Duplikat (${widget.groups.length} grup)',
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Tutup'),
        ),
        if (hasDuplicates)
          DompetButton(
            label: _mergingGroups.isNotEmpty ? 'Gabungkan Semua…' : 'Gabungkan Semua',
            leadingIcon: Icons.merge_type,
            loading: allMerging,
            onPressed: widget.onMergeGroup == null || allMerging
                ? null
                : _mergeAll,
            expand: false,
          ),
      ],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pilih nama yang dipertahankan, lalu gabungkan per grup:',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 12),
          if (!hasDuplicates)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Grup duplikat sudah selesai digabung.',
                style: TextStyle(color: Colors.white54),
              ),
            )
          else
            ...visible.map(
              (group) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _DuplicateGroupTile(
                  group: group,
                  selectedId: _selectedFor(group).id,
                  busy: _mergingGroups.contains(group.key),
                  onSelect: (c) {
                    setState(() => _selectedIds[group.key] = c.id);
                  },
                  onMerge: widget.onMergeGroup == null
                      ? null
                      : () => _mergeGroup(group),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DuplicateGroupTile extends StatelessWidget {
  const _DuplicateGroupTile({
    required this.group,
    required this.selectedId,
    required this.onSelect,
    this.onMerge,
    this.busy = false,
  });

  final ContactDuplicateGroup group;

  /// Id kontak yang dipilih sebagai primary (kontak yang dipertahankan).
  final String selectedId;
  final ValueChanged<Contact> onSelect;
  final VoidCallback? onMerge;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final header = switch (group.type) {
      DuplicateGroupType.phone => group.key,
      DuplicateGroupType.name => '"${group.key}"',
    };
    final icon = switch (group.type) {
      DuplicateGroupType.phone => Icons.phone_outlined,
      DuplicateGroupType.name => Icons.person_outline,
    };
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: DompetBrand.pink),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  header,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: DompetBrand.pink,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            group.reason,
            style: const TextStyle(fontSize: 11, color: Colors.white38),
          ),
          const SizedBox(height: 6),
          ...group.contacts.map(
            (c) {
              final selected = c.id == selectedId;
              return InkWell(
                onTap: () => onSelect(c),
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        selected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        size: 16,
                        color: selected ? DompetBrand.gold : Colors.white24,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              c.name,
                              style: TextStyle(
                                color: selected
                                    ? Colors.white
                                    : Colors.white70,
                                fontWeight: selected
                                    ? FontWeight.w600
                                    : null,
                              ),
                            ),
                            if (group.type == DuplicateGroupType.name &&
                                (c.phone?.isNotEmpty ?? false))
                              Text(
                                c.phone!,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.white38,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: DompetButton(
              label: 'Gabungkan',
              leadingIcon: Icons.merge_type,
              height: 36,
              onPressed: busy ? null : onMerge,
              loading: busy,
              expand: false,
            ),
          ),
        ],
      ),
    );
  }
}