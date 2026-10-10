import 'package:dompetqu/core/theme/cs_dialog.dart';
import 'package:dompetqu/core/theme/dompet_brand.dart';
import 'package:dompetqu/core/theme/widgets/dompet_avatar.dart';
import 'package:dompetqu/core/theme/widgets/dompet_badge.dart';
import 'package:dompetqu/core/theme/widgets/round_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mix/mix.dart';

import '../application/contacts_controller.dart';
import '../models/contact.dart';
import '../widgets/bottom_bar.dart';
import 'contact_form.dart';

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
    final state = ref.watch(contactsControllerProvider);
    final controller = ref.read(contactsControllerProvider.notifier);

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
        builder: (dialogCtx) => CsDialog(
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
                  DompetAvatar(
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
                    DompetBadge(
                      label: contact.group!,
                      tone: DompetBadgeTone.accent,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 24),
              // phone numbers section
              if (phones.isNotEmpty) ...[
                _SectionTitle(
                  icon: Icons.phone_outlined,
                  label: 'Phone Numbers',
                ),
                const SizedBox(height: 8),
                for (final p in phones)
                  _InfoRow(icon: Icons.phone_iphone, text: p),
              ],
              if (contact.email != null) ...[
                const SizedBox(height: 12),
                _SectionTitle(icon: Icons.email_outlined, label: 'Email'),
                const SizedBox(height: 8),
                _InfoRow(icon: Icons.email_outlined, text: contact.email!),
              ],
              if (contact.group != null) ...[
                const SizedBox(height: 12),
                _SectionTitle(icon: Icons.group_outlined, label: 'Group'),
                const SizedBox(height: 8),
                _InfoRow(icon: Icons.group_outlined, text: contact.group!),
              ],
              const SizedBox(height: 12),
              _SectionTitle(icon: Icons.info_outline, label: 'Info'),
              const SizedBox(height: 8),
              if (contact.createdAt != null)
                _InfoRow(
                  icon: Icons.calendar_today_outlined,
                  text:
                      'Dibuat ${DateFormat('d MMMM yyyy').format(contact.createdAt!)}',
                ),
              if (contact.updatedAt != null)
                _InfoRow(
                  icon: Icons.update_outlined,
                  text:
                      'Diubah ${DateFormat('d MMMM yyyy').format(contact.updatedAt!)}',
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: TabBottomBar(
          child: Row(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              RoundActionButton(
                icon: Icons.edit_outlined,
                label: 'Edit',
                onTap: openEdit,
              ),
              RoundActionButton(
                icon: Icons.merge_type,
                label: 'Merge',
                onTap: openMerge,
              ),
              RoundActionButton(
                icon: Icons.delete_outline,
                label: 'Delete',
                onTap: confirmDelete,
              ),
              RoundActionButton(
                icon: Icons.arrow_back,
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
