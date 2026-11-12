import 'package:dompetqu/features/assets/domain/models/asset.dart';
import 'package:dompetqu/features/assets/domain/models/asset_type.dart';
import 'package:material_ui/material_ui.dart';

import 'package:dompetqu/core/utils/balance.dart';
import 'package:dompetqu/core/theme/widgets/cx_avatar.dart';
import 'package:dompetqu/core/theme/widgets/cx_card.dart';
import 'package:dompetqu/core/theme/widgets/cx_item_menu.dart';

/// Single asset row used in assets list.
class AssetItem extends StatelessWidget {
  const AssetItem({
    super.key,
    required this.asset,
    required this.menuActions,
    this.onTap,
  });

  final Asset asset;
  final List<CxItemMenuAction> menuActions;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final balance = Balance.parse(asset.balance);
    return CxCard(
      onTap: onTap,
      variant: CxCardVariant.csGlassSurface,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          // icon section
          CxAvatar(
            label: AssetType.fromRaw(asset.type) == AssetType.crypto
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
          CxItemMenu(actions: menuActions),
        ],
      ),
    );
  }
}
