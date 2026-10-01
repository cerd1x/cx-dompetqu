import 'package:dompetqu/core/theme/widgets/dompet_card.dart';
import 'package:dompetqu/features/home/data/assets_remote_source.dart';
import 'package:dompetqu/features/home/models/asset_mutation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AssetTransactionList extends ConsumerWidget {
  const AssetTransactionList({super.key, required this.assetId});

  final String assetId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<AssetMutation>>(
      future: ref.read(assetsRemoteSourceProvider).assetMutations(assetId),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        final txs = snap.data ?? <AssetMutation>[];
        if (txs.isEmpty) return const Center(child: Text('No transactions'));
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
              child: const Text(
                'Transactions',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 8),
            // Expanded ListView so the list itself scrolls within the available area
            Expanded(
              child: ListView.separated(
                itemCount: txs.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                padding: const EdgeInsets.only(bottom: 12),
                itemBuilder: (_, i) {
                  final t = txs[i];
                  return DompetCard(
                    variant: DompetCardVariant.csGlassSurface,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(radius: 28, child: Text(t.currency)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t.type,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (t.createdAt != null)
                                Text(
                                  '${t.createdAt!.day}/${t.createdAt!.month}/${t.createdAt!.year} ${t.createdAt!.hour.toString().padLeft(2, '0')}:${t.createdAt!.minute.toString().padLeft(2, '0')}:${t.createdAt!.second.toString().padLeft(2, '0')}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white54,
                                  ),
                                ),
                              if (t.description != null)
                                Text(
                                  t.description!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white54,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${t.amount} ${t.currency}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            // balance before / after
                            if (t.balanceBefore.isNotEmpty ||
                                t.balanceAfter.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    if (t.balanceBefore.isNotEmpty)
                                      Text(
                                        'Before: ${t.balanceBefore}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white38,
                                        ),
                                      ),
                                    if (t.balanceAfter.isNotEmpty)
                                      Text(
                                        'After: ${t.balanceAfter}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white38,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
