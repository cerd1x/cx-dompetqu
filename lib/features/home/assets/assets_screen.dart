import 'package:dompetqu/core/theme/widgets/round_action_button.dart';
import 'package:dompetqu/core/theme/widgets/item_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/cs_dialog.dart';
import '../../../core/theme/dompet_brand.dart';
import '../../../core/theme/widgets/scroll_refresh_wrapper.dart';
import '../models/asset.dart';
import '../application/assets_controller.dart';
import '../widgets/bottom_bar.dart';
import '../widgets/data_states.dart';
import '../widgets/search_field.dart';
import 'add_balance_dialog.dart';
import 'asset_form.dart';
import 'assets_header.dart';
import 'asset_item.dart';
import 'package:go_router/go_router.dart';

/// Padanan `_assets/AssetsPage.svelte`.
class AssetsScreen extends ConsumerStatefulWidget {
  const AssetsScreen({super.key, this.embedded = false});

  /// Saat `true`, layar ini dipasang sebagai tab di dalam `PortfolioScreen`
  /// sehingga judul halaman ditangani header Portfolio (header Assets disembunyikan).
  final bool embedded;

  @override
  ConsumerState<AssetsScreen> createState() => _AssetsScreenState();
}

class _AssetsScreenState extends ConsumerState<AssetsScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _openForm({Asset? asset}) {
    showDialog<void>(
      context: context,
      builder: (_) => AssetFormDialog(asset: asset),
    );
  }

  void _openAddBalance(Asset asset) {
    showDialog<void>(
      context: context,
      builder: (_) => AddBalanceDialog(asset: asset),
    );
  }

  void _confirmDelete(Asset asset) {
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
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              ref.read(assetsControllerProvider.notifier).remove(asset.name);
            },
            style: TextButton.styleFrom(foregroundColor: DompetBrand.pink),
            child: const Text('Hapus'),
          ),
        ],
        child: Text('Apakah Anda ingin menghapus asset: ${asset.name}?'),
      ),
    );
  }

  List<ItemMenuAction> _menuActions(Asset asset) => [
    ItemMenuAction(
      icon: Icons.edit_outlined,
      label: 'Update',
      onTap: () => _openForm(asset: asset),
    ),
    ItemMenuAction(
      icon: Icons.add_chart,
      label: 'Add Balance',
      onTap: () => _openAddBalance(asset),
    ),
    ItemMenuAction(
      icon: Icons.delete_outline,
      label: 'Delete',
      onTap: () => _confirmDelete(asset),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(assetsControllerProvider);
    final controller = ref.read(assetsControllerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // header section — disembunyikan saat jadi tab Portfolio
        if (!widget.embedded) const AssetsHeader(),
        // body section
        Expanded(child: _buildBody(state)),
        // bottom bar section
        TabBottomBar(
          child: Row(
            children: [
              // search section
              Expanded(
                child: SearchField(
                  controller: _searchCtrl,
                  hint: 'Search assets...',
                  onChanged: controller.setSearch,
                ),
              ),
              const SizedBox(width: 10),
              // add button section
              RoundActionButton(
                icon: Icons.add,
                label: 'Add Asset',
                onTap: () => _openForm(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBody(AssetsState state) {
    // loading section
    if (state.loading) {
      return const SkeletonList(count: 5, padding: EdgeInsets.all(16));
    }
    // error section
    if (state.error != null) {
      return ErrorState(
        message: state.error!,
        onRetry: () => ref.read(assetsControllerProvider.notifier).load(),
      );
    }
    final assets = state.filtered.reversed.toList();
    // empty section
    if (assets.isEmpty) {
      return ScrollRefreshWrapper(
        onRefresh: () => ref.read(assetsControllerProvider.notifier).load(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 120),
            EmptyState(label: 'Assets Is Empty'),
          ],
        ),
      );
    }
    // asset list section
    return ScrollRefreshWrapper(
      onRefresh: () => ref.read(assetsControllerProvider.notifier).load(),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        itemCount: assets.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (_, i) => AssetItem(
          asset: assets[i],
          menuActions: _menuActions(assets[i]),
          onTap: () => context.push(
            '/asset-detail/${assets[i].id}',
            extra: assets[i].id,
          ),
        ),
      ),
    );
  }
}
