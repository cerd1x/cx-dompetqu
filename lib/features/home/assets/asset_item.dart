import 'package:dompetqu/features/home/models/asset.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/balance.dart';
import '../../../core/theme/widgets/dompet_avatar.dart';
import '../../../core/theme/widgets/dompet_card.dart';
import '../../../core/theme/widgets/item_menu.dart';

/// Single asset row used in assets list.
class AssetItem extends StatelessWidget {
  const AssetItem({
    super.key,
    required this.asset,
    required this.menuActions,
    this.onTap,
  });

  final Asset asset;
  final List<ItemMenuAction> menuActions;
  final VoidCallback? onTap;

  IconData _iconForType(String type) => switch (type) {
    'bank' => Icons.account_balance_outlined,
    'cash' => Icons.attach_money_rounded,
    'loan' => Icons.account_balance_wallet_outlined,
    'crypto' => Icons.currency_bitcoin,
    _ => Icons.wallet_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final balance = Balance.parse(asset.balance);
    return DompetCard(
      onTap: onTap,
      variant: DompetCardVariant.csGlassSurface,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          // icon section
          DompetAvatar(
            label: _iconForType(asset.type) == Icons.currency_bitcoin
                ? '₿'
                : 'W',
            size: 36,
          ),
          const SizedBox(width: 12),
          // info section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  asset.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  asset.type.toUpperCase(),
                  style: const TextStyle(fontSize: 11, color: Colors.white38),
                ),
              ],
            ),
          ),
          // balance section
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                balance.code,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                balance.toLocalStr(),
                style: const TextStyle(fontSize: 12, color: Colors.white54),
              ),
            ],
          ),
          // menu button section
          ItemMenu(actions: menuActions),
        ],
      ),
    );
  }
}
