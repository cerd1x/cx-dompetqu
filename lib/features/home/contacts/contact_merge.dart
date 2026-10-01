import 'package:dompetqu/features/home/application/contacts_controller.dart';
import 'package:dompetqu/features/home/models/contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/dompet_brand.dart';
import '../../../core/theme/widgets/dompet_avatar.dart';
import '../../../core/theme/widgets/dompet_button.dart';
import '../../../core/theme/widgets/round_action_button.dart';
import '../widgets/bottom_bar.dart';
import '../widgets/search_field.dart';

/// Screen merge contact — route `/contact-merge/:id`.
///
/// Pengganti dialog: dua fase dalam SATU halaman penuh (tanpa menumpuk
/// dialog, karena tiap CsDialog punya 2 BackdropFilter dan menumpuknya
/// bikin GPU jank).
///
/// Fase 1: pilih kontak lain yang akan digabung ke [ContactMergeScreen.contactId].
/// Fase 2: resolusi nilai field (name/phone/email) lalu konfirmasi.
class ContactMergeScreen extends ConsumerStatefulWidget {
  const ContactMergeScreen({super.key, required this.contactId});

  /// Id kontak sumber — dipertahankan sebagai kontak utama.
  final String contactId;

  @override
  ConsumerState<ContactMergeScreen> createState() => _ContactMergeScreenState();
}

class _ContactMergeScreenState extends ConsumerState<ContactMergeScreen> {
  Contact? _picked;
  late String _name;
  String? _email;
  String? _phone;
  bool _busy = false;
  String? _error;
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Kandidat duplikat harus mencakup seluruh kontak, bukan hanya halaman
    // list yang sedang tampil.
    Future.microtask(
      () => ref.read(contactsControllerProvider.notifier).ensureAllLoaded(),
    );
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  bool _matches(Contact c, String query) {
    if (query.isEmpty) return true;
    final q = query.toLowerCase();
    final parts = [
      c.name,
      c.email,
      c.phone,
      ...c.phones,
    ].whereType<String>().map((s) => s.toLowerCase());
    return parts.any((s) => s.contains(q));
  }

  void _select(Contact other) {
    final p = _primary;
    if (p == null) return;
    setState(() {
      _picked = other;
      _error = null;
      _name = p.name.isNotEmpty ? p.name : other.name;
      _email = p.email ?? other.email;
      _phone = p.phone ?? other.phone;
    });
  }

  Future<void> _submit() async {
    final primary = _primary;
    final duplicate = _picked;
    if (primary == null || duplicate == null) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final outcome = await ref
        .read(contactsControllerProvider.notifier)
        .merge(
          primaryId: primary.id,
          duplicateId: duplicate.id,
          name: _name,
          email: _email,
          phone: _phone,
        );
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    switch (outcome.status) {
      case MergeStatus.success:
        context.pop();
      case MergeStatus.duplicateLeft:
        // Data primary sudah tergabung di server — pop screen, cukup
        // beri tahu user bahwa duplikatnya tersisa (bisa dihapus manual).
        context.pop();
        messenger.showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(
              'Kontak digabung, namun "${duplicate.name}" gagal dihapus.',
            ),
          ),
        );
      case MergeStatus.failed:
        // Update gagal — tetap terbuka, tampilkan error inline agar bisa retry.
        setState(() {
          _busy = false;
          _error = outcome.error ?? 'Gagal menggabungkan kontak.';
        });
    }
  }

  Contact? get _primary {
    final state = ref.read(contactsControllerProvider);
    for (final c in state.items) {
      if (c.id == widget.contactId) return c;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(contactsControllerProvider);
    if (state.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final found = state.items.where((c) => c.id == widget.contactId).toList();
    if (found.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Gabungkan Kontak')),
        body: const Center(child: Text('Kontak tidak ditemukan')),
      );
    }
    final primary = found.first;
    final picked = _picked;
    final others = state.items
        .where((c) => c.id != primary.id)
        .where((c) => _matches(c, _searchCtrl.text))
        .toList();

    return Scaffold(
      backgroundColor: DompetBrand.background,
      appBar: AppBar(title: const Text('Merge Contact')),
      body: picked == null
          ? _buildPicker(primary, others)
          : _buildResolve(primary, picked),
      bottomNavigationBar: picked == null ? null : _buildActions(),
      // bottomNavigationBar: Box(
      //   style: BoxStyler.color(Colors.red),
      //   child: StyledText("test"),
      // ),
    );
  }

  Widget _buildActions() {
    return SafeArea(
      top: false,
      child: TabBottomBar(
        child: Row(
          spacing: 8,
          children: [
            Expanded(
              child: DompetButton(
                label: 'Gabungkan',
                leadingIcon: Icons.merge_type,
                onPressed: _busy ? null : _submit,
                loading: _busy,
                expand: true,
              ),
            ),
            RoundActionButton(
              icon: Icons.arrow_back,
              label: 'Back',
              onTap: () => context.pop(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPicker(Contact primary, List<Contact> others) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: SearchField(
            controller: _searchCtrl,
            hint: 'Cari kontak untuk digabung...',
            onChanged: (_) => setState(() {}),
          ),
        ),
        Expanded(
          child: others.isEmpty
              ? const Center(
                  child: Text(
                    'Tidak ada kontak lain untuk digabung.',
                    style: TextStyle(color: Colors.white38),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  itemCount: others.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (_, i) => _MergeCandidateTile(
                    contact: others[i],
                    onTap: () => _select(others[i]),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildResolve(Contact primary, Contact duplicate) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // summary header section
          _MergePairHeader(primary: primary, duplicate: duplicate),
          const SizedBox(height: 16),
          Text(
            '"${duplicate.name}" digabungkan ke "${primary.name}". Kontak duplikat akan dihapus.',
            style: const TextStyle(fontSize: 13, color: Colors.white54),
          ),
          // inline error section
          if (_error != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: DompetBrand.pink.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: DompetBrand.pink, width: 1),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 16,
                    color: DompetBrand.pink,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _error!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: DompetBrand.pink,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          MergeFieldChoice(
            label: 'Name',
            icon: Icons.person_outline,
            primaryValue: primary.name,
            duplicateValue: duplicate.name,
            selected: _name,
            onSelect: (v) => setState(() => _name = v ?? ''),
          ),
          const SizedBox(height: 12),
          MergeFieldChoice(
            label: 'Phone',
            icon: Icons.phone_outlined,
            primaryValue: primary.phone,
            duplicateValue: duplicate.phone,
            selected: _phone,
            onSelect: (v) => setState(() => _phone = v),
          ),
          const SizedBox(height: 12),
          MergeFieldChoice(
            label: 'Email',
            icon: Icons.email_outlined,
            primaryValue: primary.email,
            duplicateValue: duplicate.email,
            selected: _email,
            onSelect: (v) => setState(() => _email = v),
          ),
        ],
      ),
    );
  }
}

/// Ringkasan pasangan merge — kontak utama vs duplikat.
class _MergePairHeader extends StatelessWidget {
  const _MergePairHeader({required this.primary, required this.duplicate});

  final Contact primary;
  final Contact duplicate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _MiniContact(contact: primary, tag: 'Utama'),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Icon(Icons.merge_type, size: 20, color: DompetBrand.gold),
          ),
          _MiniContact(contact: duplicate, tag: 'Duplikat'),
        ],
      ),
    );
  }
}

class _MiniContact extends StatelessWidget {
  const _MiniContact({required this.contact, required this.tag});

  final Contact contact;
  final String tag;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          DompetAvatar(
            label: contact.name.isNotEmpty ? contact.name[0] : '?',
            size: 42,
          ),
          const SizedBox(height: 6),
          Text(
            contact.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            tag,
            style: const TextStyle(fontSize: 10, color: Colors.white38),
          ),
        ],
      ),
    );
  }
}

class _MergeCandidateTile extends StatelessWidget {
  const _MergeCandidateTile({required this.contact, required this.onTap});

  final Contact contact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: DompetBrand.csBorder, width: 1),
      ),
      tileColor: Colors.white.withValues(alpha: 0.05),
      leading: DompetAvatar(
        label: contact.name.isNotEmpty ? contact.name[0] : '?',
        size: 36,
      ),
      title: Text(
        contact.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        [contact.phone, contact.email].whereType<String>().join(' · '),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 12, color: Colors.white38),
      ),
      trailing: const Icon(Icons.merge_type, color: DompetBrand.gold, size: 20),
      onTap: onTap,
    );
  }
}

/// Pilihan nilai per field antara kontak utama dan duplikat.
///
/// Jika nilai identik atau salah satu kosong, hanya satu baris statis
/// yang tampil; jika berbeda, kedua nilai bisa dipilih via radio.
class MergeFieldChoice<T> extends StatelessWidget {
  const MergeFieldChoice({
    super.key,
    required this.label,
    required this.icon,
    required this.primaryValue,
    required this.duplicateValue,
    required this.selected,
    required this.onSelect,
  });

  final String label;
  final IconData icon;
  final T? primaryValue;
  final T? duplicateValue;
  final T? selected;
  final ValueChanged<T?> onSelect;

  bool get _same => primaryValue == duplicateValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // label section
          Row(
            children: [
              Icon(icon, size: 14, color: Colors.white38),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  color: Colors.white38,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // value options section
          if (_same || duplicateValue == null)
            _valueRow(value: primaryValue)
          else ...[
            _optionRow(value: primaryValue, fromPrimary: true),
            _optionRow(value: duplicateValue, fromPrimary: false),
          ],
        ],
      ),
    );
  }

  Widget _optionRow({required T? value, required bool fromPrimary}) {
    final isSelected = value == selected;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => onSelect(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              size: 16,
              color: isSelected ? DompetBrand.gold : Colors.white24,
            ),
            const SizedBox(width: 8),
            Expanded(child: _valueText(value)),
            Text(
              fromPrimary ? 'Utama' : 'Duplikat',
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? DompetBrand.gold : Colors.white24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _valueRow({required T? value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Row(
        children: [
          const Icon(Icons.check, size: 14, color: Colors.white24),
          const SizedBox(width: 10),
          Expanded(child: _valueText(value)),
        ],
      ),
    );
  }

  Widget _valueText(T? value) => Text(
    value == null || '$value'.isEmpty ? '-' : '$value',
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontSize: 13,
      color: value == null || '$value'.isEmpty
          ? Colors.white24
          : Colors.white70,
    ),
  );
}
