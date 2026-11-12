import 'package:dompetqu/features/contacts/domain/models/contact.dart';
import 'package:flutter/material.dart';
import 'package:dompetqu/core/theme/widgets/cx_avatar.dart';
import 'package:dompetqu/core/theme/widgets/cx_badge.dart';
import 'package:dompetqu/core/theme/widgets/cx_card.dart';
import 'package:dompetqu/core/theme/widgets/cx_item_menu.dart';

/// Single contact row used in contacts list.
class ContactItem extends StatelessWidget {
  const ContactItem({
    super.key,
    required this.contact,
    required this.onTap,
    required this.menuActions,
  });

  final Contact contact;
  final VoidCallback onTap;
  final List<CxItemMenuAction> menuActions;

  @override
  Widget build(BuildContext context) {
    return CxCard(
      variant: CxCardVariant.csGlassSurface,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      onTap: onTap,
      child: Row(
        children: [
          // avatar section
          CxAvatar(
            label: contact.name.isNotEmpty ? contact.name[0] : '?',
            size: 36,
          ),
          const SizedBox(width: 12),
          // info section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  [
                    contact.phone,
                    contact.email,
                  ].whereType<String>().join(' · '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: Colors.white38),
                ),
              ],
            ),
          ),
          // group badge section
          if (contact.group != null)
            CxBadge(label: contact.group!, tone: CxBadgeTone.accent),
          // menu button section
          CxItemMenu(actions: menuActions),
        ],
      ),
    );
  }
}
