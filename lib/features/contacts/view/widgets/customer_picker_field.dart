import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dompetqu/core/cx_icons.dart';
import 'package:dompetqu/core/theme/widgets/cx_picker_field_with_modal_topbar.dart';
import 'package:dompetqu/features/contacts/domain/models/contact.dart';
import 'package:dompetqu/features/contacts/view/stores/contacts_store.dart';

/// Picker customer dari [contactsStoreProvider].
///
/// Komposisi tipis di atas [CxPickerFieldWithModalTopbar]: logika sheet, list,
/// dan pencarian tinggal di core. Di sini hanya sumber data, pemetaan id, dan
/// aturan "muat semua kontak dulu" yang spesifik fitur contacts.
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
    final contacts = ref.watch(contactsStoreProvider).items;
    Contact? selected;
    for (final c in contacts) {
      if (c.id == selectedId) {
        selected = c;
        break;
      }
    }

    return CxPickerFieldWithModalTopbar<Contact>(
      label: 'Customer',
      items: contacts,
      labelOf: (c) => c.name,
      selectedItem: selected,
      isSelectedOf: (c) => c.id == selectedId,
      icon: CxIcons.personOutline,
      placeholder: 'Pilih customer...',
      emptyText: 'Kontak kosong',
      subtitleOf: (c) => c.phone ?? c.email ?? '',
      // Form memakai id (bukan objek Contact), jadi nilai dari sheet dipetakan
      // ke id di boundary ini.
      onChanged: (contact) => onChanged(contact.id),
      // Picker harus memuat seluruh kontak, bukan hanya halaman list yang
      // sudah tampil — perilaku ini dipertahankan dari versi sebelumnya.
      loadItems: () async {
        await ref.read(contactsStoreProvider.notifier).ensureAllLoaded();
        return ref.read(contactsStoreProvider).items;
      },
    );
  }
}
