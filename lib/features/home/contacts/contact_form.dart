import 'package:dompetqu/features/home/application/contacts_controller.dart';
import 'package:dompetqu/features/home/models/contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/cs_dialog.dart';
import '../../../core/theme/dompet_brand.dart';
import '../../../core/theme/widgets/dompet_text_field.dart';
import '../../../core/theme/widgets/dompet_button.dart';

/// Dialog for creating/updating a contact.
class ContactFormDialog extends ConsumerStatefulWidget {
  const ContactFormDialog({super.key, this.contact});

  final Contact? contact;

  @override
  ConsumerState<ContactFormDialog> createState() => ContactFormDialogState();
}

class ContactFormDialogState extends ConsumerState<ContactFormDialog> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final List<TextEditingController> _phoneCtrls;
  late final TextEditingController _groupCtrl;
  bool _busy = false;

  bool get _isEdit => widget.contact != null;

  @override
  void initState() {
    super.initState();
    final c = widget.contact;
    _nameCtrl = TextEditingController(text: c?.name ?? '');
    _emailCtrl = TextEditingController(text: c?.email ?? '');
    _phoneCtrls = _initialPhones(c)
        .map((p) => TextEditingController(text: p))
        .toList();
    if (_phoneCtrls.isEmpty) _phoneCtrls.add(TextEditingController());
    _groupCtrl = TextEditingController(text: c?.group ?? '');
  }

  List<String> _initialPhones(Contact? c) {
    final phones = (c?.phones ?? const <String>[]).toList();
    if (c?.phone != null && c!.phone!.isNotEmpty) {
      phones.insert(0, c.phone!);
    }
    return phones.where((p) => p.trim().isNotEmpty).toList();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    for (final ctrl in _phoneCtrls) {
      ctrl.dispose();
    }
    _groupCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameCtrl.text.trim();
    var phones = _phoneCtrls
        .map((c) => c.text.trim())
        .where((p) => p.isNotEmpty)
        .toList();
    if (name.isEmpty || phones.isEmpty) return;

    setState(() => _busy = true);
    final ok = _isEdit
        ? await ref
              .read(contactsControllerProvider.notifier)
              .update(
                widget.contact!.id,
                name: name,
                email: _emailCtrl.text.trim().isEmpty
                    ? null
                    : _emailCtrl.text.trim(),
                phones: phones,
              )
        : await ref
              .read(contactsControllerProvider.notifier)
              .create(
                name: name,
                email: _emailCtrl.text.trim().isEmpty
                    ? null
                    : _emailCtrl.text.trim(),
                phones: phones,
                group: _groupCtrl.text.trim().isEmpty
                    ? null
                    : _groupCtrl.text.trim(),
              );
    if (!mounted) return;
    setState(() => _busy = false);
    if (ok) Navigator.of(context).pop();
  }

  void _addPhone() => setState(() => _phoneCtrls.add(TextEditingController()));

  void _removePhone(int index) {
    if (_phoneCtrls.length <= 1) return;
    setState(() {
      final ctrl = _phoneCtrls.removeAt(index);
      ctrl.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CsDialog(
      title: _isEdit ? 'Update Contact' : 'Add Contact',
      actions: [
        DompetButton(
          label: _isEdit ? 'Update' : 'Save',
          onPressed: _busy ? null : _submit,
          loading: _busy,
          expand: false,
        ),
      ],
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // name field section
            DompetTextField(
              controller: _nameCtrl,
              label: 'Name',
              leading: const Icon(
                Icons.person_outline,
                color: Colors.white54,
              ),
            ),
            const SizedBox(height: 12),
            // email field section
            DompetTextField(
              controller: _emailCtrl,
              label: 'Email',
              keyboardType: TextInputType.emailAddress,
              leading: const Icon(
                Icons.email_outlined,
                color: Colors.white54,
              ),
            ),
            const SizedBox(height: 12),
            // phone fields section — mendukung multiple nomor
            Text(
              'Phone Numbers',
              style: TextStyle(fontSize: 13, color: Colors.white70),
            ),
            const SizedBox(height: 8),
            for (var i = 0; i < _phoneCtrls.length; i++) ...[
              Row(
                children: [
                  Expanded(
                    child: DompetTextField(
                      controller: _phoneCtrls[i],
                      label: i == 0 ? 'Phone (Mobile)' : 'Phone ${i + 1}',
                      keyboardType: TextInputType.phone,
                      leading: const Icon(
                        Icons.phone_outlined,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                  if (_phoneCtrls.length > 1)
                    IconButton(
                      onPressed: () => _removePhone(i),
                      icon: const Icon(Icons.remove_circle_outline),
                      color: DompetBrand.pink,
                    ),
                ],
              ),
              if (i < _phoneCtrls.length - 1) const SizedBox(height: 8),
            ],
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: _addPhone,
                icon: const Icon(Icons.add_circle_outline, size: 18),
                label: const Text('Add phone number'),
              ),
            ),
            const SizedBox(height: 8),
            // group field section
            DompetTextField(
              controller: _groupCtrl,
              label: 'Group',
              leading: const Icon(
                Icons.group_outlined,
                color: Colors.white54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
