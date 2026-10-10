import 'package:dompetqu/core/theme/widgets/round_action_button.dart';
import 'package:dompetqu/core/theme/widgets/item_menu.dart';
import 'package:dompetqu/features/home/widgets/search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/cs_dialog.dart';
import '../../../core/theme/dompet_brand.dart';
import '../models/contact.dart';
import '../application/contacts_controller.dart';
import '../widgets/bottom_bar.dart';
import '../widgets/data_states.dart';
import 'contacts_header.dart';
import 'contact_item.dart';
import 'contact_form.dart';
import 'duplicate_contacts_investigation_dialog.dart';

/// Padanan `_contacts/ContactPage.svelte`.
class ContactsScreen extends ConsumerStatefulWidget {
  const ContactsScreen({super.key});

  @override
  ConsumerState<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends ConsumerState<ContactsScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Daftar kontak dimuat per halaman (`contactsPage`) alih-alih seluruhnya,
    // lalu dilanjutkan lewat tombol "Muat lebih banyak" di bawah list.
    Future.microtask(
      () => ref.read(contactsControllerProvider.notifier).loadPage(),
    );
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _openForm({Contact? contact}) async {
    // Deteksi duplikat butuh daftar lengkap, sedangkan list dimuat per halaman.
    await ref.read(contactsControllerProvider.notifier).ensureAllLoaded();
    if (!mounted) return;
    final groups = ref
        .read(contactsControllerProvider.notifier)
        .findDuplicates();
    if (groups.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => DuplicateContactsInvestigationDialog(
            groups: groups,
            onMergeGroup: _handleMergeGroup,
          ),
        ),
      );
      return;
    }
    showDialog<void>(
      context: context,
      builder: (_) => ContactFormDialog(contact: contact),
    );
  }

  /// Gabungkan satu grup duplikat: semua [duplicates] digabung ke [primary]
  /// (nama yang dipilih user) — dipanggil dari tombol per grup di dialog
  /// investigasi duplikat.
  Future<void> _handleMergeGroup(
    Contact primary,
    List<Contact> duplicates,
  ) async {
    for (final duplicate in duplicates) {
      final outcome = await ref
          .read(contactsControllerProvider.notifier)
          .merge(
            primaryId: primary.id,
            duplicateId: duplicate.id,
            name: primary.name,
            email: primary.email,
            phone: primary.phone,
          );
      if (!mounted) return;
      if (outcome.status == MergeStatus.failed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gagal menggabungkan ${duplicate.name}: ${outcome.error ?? 'error'}',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _openDetail(Contact contact) {
    // Kontak dikirim lewat `extra` karena daftar hanya berisi halaman yang
    // sudah dimuat — `contact_detail_screen` memprioritaskan item di state
    // (supaya hasil edit tercermin) dan jatuh ke `extra` bila belum termuat.
    context.push('/contact-detail/${contact.id}', extra: contact);
  }

  List<ItemMenuAction> _menuActions(Contact contact) => [
    ItemMenuAction(
      icon: Icons.edit_outlined,
      label: 'Edit',
      onTap: () {
        showDialog<void>(
          context: context,
          builder: (_) => ContactFormDialog(contact: contact),
        );
      },
    ),
    ItemMenuAction(
      icon: Icons.merge_type,
      label: 'Merge',
      onTap: () => context.push('/contact-merge/${contact.id}'),
    ),
    ItemMenuAction(
      icon: Icons.delete_outline,
      label: 'Delete',
      onTap: () {
        showDialog<void>(
          context: context,
          builder: (_) => _deleteConfirm(contact),
        );
      },
    ),
  ];

  Widget _deleteConfirm(Contact contact) {
    return CsDialog(
      title: 'Hapus ${contact.name}?',
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            ref.read(contactsControllerProvider.notifier).remove(contact.id);
          },
          style: TextButton.styleFrom(foregroundColor: DompetBrand.pink),
          child: const Text('Hapus'),
        ),
      ],
      child: const Text('Tindakan ini tidak dapat dibatalkan.'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(contactsControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // header section
        const ContactsHeader(),
        // body section
        Expanded(child: _buildBody(state)),
        // bottom bar section
        IntrinsicHeight(
          child: TabBottomBar(
            child: Row(
              spacing: 8,
              mainAxisAlignment: .end,
              children: [
                // search section
                Expanded(
                  child: SearchField(
                    controller: _searchCtrl,
                    hint: 'Search contacts...',
                    onChanged: (v) => ref
                        .read(contactsControllerProvider.notifier)
                        .setSearch(v),
                  ),
                ),
                // add button section
                RoundActionButton(
                  icon: Icons.person_add_alt_1,
                  label: 'Add Contact',
                  onTap: () => _openForm(),
                ),
                RoundActionButton(
                  icon: Icons.merge,
                  label: 'Merge Contact',
                  onTap: () => _openForm(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(ContactsState state) {
    // loading section
    if (state.loading) {
      return const SkeletonList(count: 5, padding: EdgeInsets.all(16));
    }
    // error section
    if (state.error != null) {
      return ErrorState(
        message: state.error!,
        onRetry: () => ref.read(contactsControllerProvider.notifier).load(),
      );
    }
    final contacts = state.filtered;
    // empty section
    if (contacts.isEmpty) {
      return const EmptyState(label: 'Contact Is Empty');
    }
    // contact list section
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: contacts.length + (state.hasMore ? 1 : 0),
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (_, i) {
        if (i >= contacts.length) return _loadMoreButton(state);
        return ContactItem(
          contact: contacts[i],
          onTap: () => _openDetail(contacts[i]),
          menuActions: _menuActions(contacts[i]),
        );
      },
    );
  }

  /// Footer "muat lebih banyak" — hanya muncul saat mode pagination aktif
  /// (`ContactsController.loadPage`) dan masih ada halaman berikutnya.
  Widget _loadMoreButton(ContactsState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: OutlinedButton.icon(
        onPressed: state.loadingMore
            ? null
            : () => ref.read(contactsControllerProvider.notifier).loadMore(),
        icon: state.loadingMore
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.expand_more, size: 18),
        label: Text(state.loadingMore ? 'Memuat...' : 'Muat lebih banyak'),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: Colors.white24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
