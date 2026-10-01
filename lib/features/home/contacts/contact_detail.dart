import 'package:dompetqu/features/home/models/contact.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/widgets/dompet_avatar.dart';
import '../../../core/theme/widgets/dompet_badge.dart';
import '../../../core/theme/widgets/dompet_button.dart';

/// Detail dialog for a contact.
class ContactDetail extends StatelessWidget {
  const ContactDetail({super.key, required this.contact});

  final Contact contact;

  /// Gabungkan `phones` (list) dengan `phone` (kompatibilitas lama),
  /// hapus duplikat & kosong, pertahankan urutan.
  List<String> get _phones {
    final result = <String>[];
    if (contact.phone != null && contact.phone!.trim().isNotEmpty) {
      result.add(contact.phone!.trim());
    }
    for (final p in contact.phones) {
      final t = p.trim();
      if (t.isNotEmpty && !result.any((e) => e == t)) {
        result.add(t);
      }
    }
    return result;
  }

  List<Widget> _phoneInfoRows() {
    return [for (final p in _phones) InfoRow(icon: Icons.phone_outlined, text: p)];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // avatar section
          DompetAvatar(
            label: contact.name.isNotEmpty ? contact.name[0] : '?',
            size: 72,
          ),
          const SizedBox(height: 12),
          // name section
          Text(
            contact.name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          if (contact.group != null) ...[
            const SizedBox(height: 6),
            DompetBadge(label: contact.group!, tone: DompetBadgeTone.accent),
          ],
          const SizedBox(height: 16),
          // info rows section
          ..._phoneInfoRows(),
          if (contact.email != null)
            InfoRow(icon: Icons.email_outlined, text: contact.email!),
          if (contact.createdAt != null)
            InfoRow(
              icon: Icons.calendar_today_outlined,
              text: DateFormat('d MMMM yyyy').format(contact.createdAt!),
            ),
          const SizedBox(height: 16),
          // close button section
          DompetButton(
            label: 'Tutup',
            variant: DompetButtonVariant.outline,
            expand: true,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  const InfoRow({super.key, required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
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
