import 'package:cx_dompetqiu/core/theme/widgets/cx_dialog.dart';
import 'package:cx_dompetqiu/core/theme/dompet_brand.dart';
import 'package:cx_dompetqiu/core/theme/widgets/cx_avatar.dart';
import 'package:cx_dompetqiu/core/theme/widgets/cx_badge.dart';
import 'package:cx_dompetqiu/core/theme/widgets/cx_button_act_round.dart';
import 'package:cx_dompetqiu/features/contacts/view/widgets/contact_form.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mix/mix.dart';

import 'package:cx_dompetqiu/features/contacts/view/stores/contacts_store.dart';
import 'package:cx_dompetqiu/features/contacts/domain/models/contact.dart';
import 'package:cx_dompetqiu/core/theme/widgets/cx_tab_bottom_bar.dart';
import 'package:cx_dompetqiu/core/theme/widgets/cx_icons.dart';

/// Full screen detail kontak — route `/contact-detail/:id`.
///
/// Menampilkan seluruh isi kontak (nama, group, email, SEMUA nomor telepon
/// — mobile/rumah/kantor, dan tanggal dibuat/diubah) lengkap dengan aksi
/// edit (update), merge, dan delete.
///
/// [initialContact] diisi dari `extra` route saat kontak dibuka dari list yang
/// hanya memuat satu halaman — item yang sudah ada di state tetap dipakai
/// lebih dulu agar perubahan hasil edit langsung tercermin.
class ContactDetailScreen extends ConsumerWidget {
  const ContactDetailScreen({
    super.key,
    required this.contactId,
    this.initialContact,
  });

  final String contactId;
  final Contact? initialContact;

  /// Gabungkan `phones` (list) dengan `phone` (kompatibilitas lama),
  /// hapus duplikat & kosong, pertahankan urutan.
  static List<String> phonesOf(Contact c) {
    final result = <String>[];
    if (c.phone != null && c.phone!.trim().isNotEmpty) {
      result.add(c.phone!.trim());
    }
    for (final p in c.phones) {
      final t = p.trim();
      if (t.isNotEmpty && !result.any((e) => e == t)) {
        result.add(t);
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(contactsStoreProvider);
    final controller = ref.read(contactsStoreProvider.notifier);

    if (state.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final found = state.items.where((c) => c.id == contactId).toList();
    final contact = found.isNotEmpty ? found.first : initialContact;
    if (contact == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Contact Details')),
        body: const Center(child: Text('Contact not found')),
      );
    }

    void openEdit() {
      showDialog<void>(
        context: context,
        builder: (_) => ContactFormDialog(contact: contact),
      );
    }

    void openMerge() {
      context.push('/contact-merge/${contact.id}');
    }

    void confirmDelete() {
      showDialog<void>(
        context: context,
        builder: (dialogCtx) => CxDialog(
          title: 'Hapus ${contact.name}?',
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogCtx).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogCtx).pop();
                await controller.remove(contact.id);
                if (context.mounted) context.pop();
              },
              style: TextButton.styleFrom(foregroundColor: DompetBrand.pink),
              child: const Text('Hapus'),
            ),
          ],
          child: const Text('Tindakan ini tidak dapat dibatalkan.'),
        ),
      );
    }

    final phones = phonesOf(contact);

    return Scaffold(
      backgroundColor: DompetBrand.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // header section
              Column(
                children: [
                  CxAvatar(
                    label: contact.name.isNotEmpty ? contact.name[0] : '?',
                    size: 72,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    contact.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  if (contact.group != null) ...[
                    const SizedBox(height: 6),
                    CxBadge(
                      label: contact.group!,
                      tone: CxBadgeTone.accent,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 24),
              // phone numbers section
              if (phones.isNotEmpty) ...[
                _SectionTitle(
                  icon: CxIcons.phoneOutlined,
                  label: 'Phone Numbers',
                ),
                const SizedBox(height: 8),
                for (final p in phones)
                  _InfoRow(icon: CxIcons.phoneIphone, text: p),
              ],
              if (contact.email != null) ...[
                const SizedBox(height: 12),
                _SectionTitle(icon: CxIcons.emailOutlined, label: 'Email'),
                const SizedBox(height: 8),
                _InfoRow(icon: CxIcons.emailOutlined, text: contact.email!),
              ],
              if (contact.group != null) ...[
                const SizedBox(height: 12),
                _SectionTitle(icon: CxIcons.groupOutlined, label: 'Group'),
                const SizedBox(height: 8),
                _InfoRow(icon: CxIcons.groupOutlined, text: contact.group!),
              ],
              const SizedBox(height: 12),
              _SectionTitle(icon: CxIcons.infoOutline, label: 'Info'),
              const SizedBox(height: 8),
              if (contact.createdAt != null)
                _InfoRow(
                  icon: CxIcons.calendarTodayOutlined,
                  text:
                      'Dibuat ${DateFormat('d MMMM yyyy').format(contact.createdAt!)}',
                ),
              if (contact.updatedAt != null)
                _InfoRow(
                  icon: CxIcons.updateOutlined,
                  text:
                      'Diubah ${DateFormat('d MMMM yyyy').format(contact.updatedAt!)}',
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: CxTabBottomBar(
          child: Row(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CxButtonActRound(
                icon: CxIcons.editOutlined,
                label: 'Edit',
                onTap: openEdit,
              ),
              CxButtonActRound(
                icon: CxIcons.mergeType,
                label: 'Merge',
                onTap: openMerge,
              ),
              CxButtonActRound(
                icon: CxIcons.deleteOutline,
                label: 'Delete',
                onTap: confirmDelete,
              ),
              CxButtonActRound(
                icon: CxIcons.arrowBack,
                label: 'Back',
                onTap: () => context.pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.white38),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            color: Colors.white38,
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Box(
      style: BoxStyler()
          .padding(
            EdgeInsetsGeometryMix.value(
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          )
          .margin(EdgeInsetsGeometryMix.value(const EdgeInsets.only(bottom: 8)))
          .constraints(
            BoxConstraintsMix.value(
              (const BoxConstraints()).tighten(
                width: double.infinity,
                height: null,
              ),
            ),
          )
          .decoration(
            DecorationMix.value(
              BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.white38),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
