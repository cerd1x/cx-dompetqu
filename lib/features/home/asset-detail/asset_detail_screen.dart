import 'package:dompetqu/core/theme/cs_dialog.dart';
import 'package:dompetqu/core/theme/dompet_brand.dart';
import 'package:dompetqu/core/theme/widgets/round_action_button.dart';
import 'asset_transaction_list.dart';
import 'swap_balance_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:dompetqu/features/home/application/assets_controller.dart';
import 'package:dompetqu/features/home/assets/asset_detail.dart';
import 'package:dompetqu/features/home/assets/asset_form_dialog.dart';
import 'package:dompetqu/features/home/assets/add_balance_dialog.dart';
import 'package:remix/remix.dart';

/// Full screen details for an asset. Route: /details-assets/:id
class AssetDetailScreen extends ConsumerWidget {
  const AssetDetailScreen({super.key, required this.assetId});

  final String assetId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(assetsControllerProvider);
    final controller = ref.read(assetsControllerProvider.notifier);

    if (state.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final found = state.items.where((a) => a.id == assetId).toList();
    if (found.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Asset Details')),
        body: const Center(child: Text('Asset not found')),
      );
    }
    final asset = found.first;

    void openEdit() {
      showDialog<void>(
        context: context,
        builder: (_) => AssetFormDialog(asset: asset),
      );
    }

    void openAddBalance() {
      showDialog<void>(
        context: context,
        builder: (_) => AddBalanceDialog(asset: asset),
      );
    }

    void confirmDelete() {
      showDialog<void>(
        context: context,
        builder: (dialogCtx) => CsDialog(
          title: 'Confirm Delete',
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogCtx).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogCtx).pop();
                final ok = await controller.remove(asset.name);
                if (ok) {
                  if (context.mounted) context.go('/');
                }
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Hapus'),
            ),
          ],
          child: Text('Apakah Anda ingin menghapus asset: ${asset.name}?'),
        ),
      );
    }

    void openSwap(
      BuildContext context,
      AssetsController controller,
      List items,
    ) {
      showDialog<void>(
        context: context,
        builder: (_) => SwapBalanceDialog(controller: controller, items: items),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(asset.name),
        actions: [
          IconButton(
            onPressed: confirmDelete,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // reuse dialog's detail layout
              AssetDetail(asset: asset),
              Expanded(
                child: Box(
                  style: BoxStyler()
                      .gradient(DompetBrand.gradientWithAlpha(.2))
                      .borderRounded(28)
                      .paddingX(8)
                      .paddingY(4)
                      .marginTop(8),
                  child: AssetTransactionList(assetId: asset.id),
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: .center,
                child: Box(
                  style: BoxStyler().paddingAll(2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RoundActionButton(
                        label: 'Add',
                        onTap: openAddBalance,
                        icon: Icons.add,
                      ),
                      const SizedBox(width: 12),
                      RoundActionButton(
                        onTap: () => openSwap(context, controller, state.items),
                        icon: Icons.swap_horiz,
                        label: 'Swap Balance',
                      ),
                      const SizedBox(width: 12),
                      RoundActionButton(
                        onTap: openEdit,
                        icon: Icons.edit,
                        label: 'Edit Asset',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
