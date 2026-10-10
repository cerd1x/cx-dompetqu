import 'package:dompetqu/core/theme/dompet_brand.dart';
import 'package:dompetqu/features/home/models/asset.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:remix/remix.dart';

import '../../../core/utils/balance.dart';
import '../../../core/theme/widgets/dompet_avatar.dart';

/// Detail dialog for an asset.
class AssetDetail extends StatelessWidget {
  const AssetDetail({super.key, required this.asset});

  final Asset asset;

  @override
  Widget build(BuildContext context) {
    final balance = Balance.parse(asset.balance);
    return Box(
      style: BoxStyler()
          .gradient(DompetBrand.gradientWithAlpha(.2))
          .padding(EdgeInsetsMix.fromLTRB(24, 28, 24, 20))
          .borderRounded(28)
          .border(
            .all(BorderSideMix(color: DompetBrand.csBorderDark, width: 1.2)),
          ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // avatar section
          DompetAvatar(
            label: asset.name.isNotEmpty ? asset.name[0] : '?',
            size: 72,
          ),
          const SizedBox(height: 12),
          // name section
          Text(
            asset.name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            asset.type.toUpperCase(),
            style: const TextStyle(color: Colors.white54, fontSize: 13),
          ),
          const SizedBox(height: 12),
          // balance section
          InfoRow(
            icon: Icons.payments_outlined,
            text: '${balance.code} ${balance.toLocalStr()}',
          ),
          const SizedBox(height: 16),
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
