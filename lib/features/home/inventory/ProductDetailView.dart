// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mix/mix.dart';

import '../../../core/theme/dompet_brand.dart';
import '../../../core/theme/widgets/dompet_avatar.dart';
import '../../../core/theme/widgets/dompet_button.dart';
import '../../../core/utils/formatters.dart';
import '../models/product.dart';
import '../order/order_tab.dart';

/// Dialog detail product — padanan popup detail di web.
class ProductDetailView extends StatelessWidget {
  const ProductDetailView({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // avatar section
          const DompetAvatar(label: 'P', size: 56),
          const SizedBox(height: 12),
          // name section
          Text(
            product.name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          // detail rows section
          if (product.description != null)
            _DetailRow(label: 'Deskripsi', value: product.description!),
          _DetailRow(
            label: 'Stock',
            value: product.stockLabel,
            color: product.isLowStock ? DompetBrand.pink : null,
          ),
          _DetailRow(
            label: 'Price',
            value: formatMoney(product.price, product.currency),
          ),
          if (product.capital != null)
            _DetailRow(
              label: 'Capital',
              value: formatMoney(product.capital!, product.currency),
            ),
          if (product.margin != null)
            _DetailRow(
              label: 'Margin',
              value: formatMoney(product.margin!, product.currency),
              color: product.margin! >= 0
                  ? const Color(0xFF34D399)
                  : DompetBrand.pink,
            ),
          if (product.createdAt != null)
            _DetailRow(
              label: 'Dibuat',
              value: DateFormat('d MMMM yyyy').format(product.createdAt!),
            ),
          const SizedBox(height: 16),
          // action buttons section — Buy (kanan) & Tutup (kiri)
          Row(
            children: [
              Expanded(
                child: DompetButton(
                  label: 'Tutup',
                  variant: DompetButtonVariant.outline,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DompetButton(
                  label: 'Buy',
                  leadingIcon: Icons.shopping_bag_outlined,
                  onPressed: () {
                    final router = GoRouter.of(context);
                    Navigator.of(context).pop();
                    router.push(
                      '/order',
                      extra: OrderRouteArgs.sale(product: product),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Baris detail label: nilai di dalam popup.
class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value, this.color});

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Box(
      style: BoxStyler()
          .padding(
            EdgeInsetsGeometryMix.value(
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          )
          .margin(EdgeInsetsGeometryMix.value(const EdgeInsets.only(bottom: 6)))
          .decoration(
            DecorationMix.value(
              BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.white38),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(fontSize: 12, color: color ?? Colors.white),
          ),
        ],
      ),
    );
  }
}
