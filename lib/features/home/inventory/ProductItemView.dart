// ignore_for_file: file_names
import 'package:flutter/material.dart';

import '../../../core/theme/dompet_brand.dart';
import '../../../core/theme/widgets/dompet_avatar.dart';
import '../../../core/theme/widgets/dompet_card.dart';
import '../../../core/theme/widgets/item_menu.dart';
import '../../../core/utils/formatters.dart';
import '../models/product.dart';

/// Baris item product di daftar inventory — padanan `_inventory/InventoryPage.svelte`.
class ProductItemView extends StatelessWidget {
  const ProductItemView({
    super.key,
    required this.product,
    required this.onTap,
    required this.onUpdate,
    required this.onDelete,
  });

  final Product product;
  final VoidCallback onTap;
  final VoidCallback onUpdate;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return DompetCard(
      variant: DompetCardVariant.csGlassSurface,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      onTap: onTap,
      child: Row(
        children: [
          // avatar section
          const DompetAvatar(label: 'P', size: 36),
          const SizedBox(width: 12),
          // info section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (product.description != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    product.description!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: Colors.white38),
                  ),
                ],
                const SizedBox(height: 2),
                Text(
                  'Stock: ${product.stockLabel}',
                  style: TextStyle(
                    fontSize: 12,
                    color: product.isLowStock
                        ? DompetBrand.pink
                        : Colors.white38,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // price section
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatMoney(product.price, product.currency),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (product.margin != null) ...[
                const SizedBox(height: 2),
                Text(
                  'Margin: ${formatMoney(product.margin!, product.currency)}',
                  style: TextStyle(
                    fontSize: 11,
                    color: product.margin! >= 0
                        ? const Color(0xFF34D399)
                        : DompetBrand.pink,
                  ),
                ),
              ],
            ],
          ),
          // menu button section
          ItemMenu(
            actions: [
              ItemMenuAction(
                icon: Icons.edit_outlined,
                label: 'Edit',
                onTap: onUpdate,
              ),
              ItemMenuAction(
                icon: Icons.delete_outline,
                label: 'Hapus',
                onTap: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
