import 'package:dompetqu/core/theme/widgets/round_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/cs_dialog.dart';
import '../../../core/theme/dompet_brand.dart';
import '../../../core/theme/widgets/dompet_button.dart';
import '../../../core/theme/widgets/dompet_text_field.dart';
import '../../../core/theme/widgets/scroll_refresh_wrapper.dart';
import '../../../core/utils/formatters.dart';
import '../models/product.dart';
import '../application/inventory_controller.dart';
import '../order/OrderFormWidgets.dart';
import '../widgets/bottom_bar.dart';
import '../widgets/data_states.dart';
import '../widgets/search_field.dart';
import 'ProductDetailView.dart';
import 'ProductItemView.dart';

/// Padanan `_inventory/InventoryPage.svelte`.
class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _openForm({Product? product}) {
    showDialog<void>(
      context: context,
      builder: (_) => _ProductFormDialog(product: product),
    );
  }

  void _openDetail(Product product) {
    showDialog<void>(
      context: context,
      builder: (_) => CsDialog(child: ProductDetailView(product: product)),
    );
  }

  void _confirmDelete(Product product) {
    showDialog<void>(
      context: context,
      builder: (dialogCtx) => CsDialog(
        title: 'Hapus Product?',
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: const Text('TIDAK'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              ref
                  .read(inventoryControllerProvider.notifier)
                  .remove(product.id!);
            },
            style: TextButton.styleFrom(foregroundColor: DompetBrand.pink),
            child: const Text('OK'),
          ),
        ],
        child: Text('Apakah Anda ingin menghapus product: ${product.name}?'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(inventoryControllerProvider);
    final controller = ref.read(inventoryControllerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,

      children: [
        // header section
        _InventoryHeader(),
        // summary section
        _SummaryBar(state: state),
        // body section
        Expanded(child: _buildBody(state)),
        // bottom bar section
        TabBottomBar(
          child: Row(
            mainAxisAlignment: .center,
            crossAxisAlignment: .center,
            children: [
              // search section
              Expanded(
                child: SearchField(
                  controller: _searchCtrl,
                  hint: 'Search products...',
                  onChanged: controller.setSearch,
                ),
              ),
              const SizedBox(width: 10),
              // add button section
              RoundActionButton(
                icon: Icons.add,
                label: 'Add Product',
                onTap: () => _openForm(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBody(InventoryState state) {
    // loading section
    if (state.loading) {
      return const SkeletonList(count: 5, padding: EdgeInsets.all(16));
    }
    // error section
    if (state.error != null) {
      return ErrorState(
        message: state.error!,
        onRetry: () => ref.read(inventoryControllerProvider.notifier).load(),
      );
    }
    final products = state.filtered;
    // empty section
    if (products.isEmpty) {
      return ScrollRefreshWrapper(
        onRefresh: () => ref.read(inventoryControllerProvider.notifier).load(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 120),
            EmptyState(label: 'Inventory Is Empty'),
          ],
        ),
      );
    }
    // product list section
    return ScrollRefreshWrapper(
      onRefresh: () => ref.read(inventoryControllerProvider.notifier).load(),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        itemCount: products.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (_, i) => ProductItemView(
          product: products[i],
          onTap: () => _openDetail(products[i]),
          onUpdate: () => _openForm(product: products[i]),
          onDelete: () => _confirmDelete(products[i]),
        ),
      ),
    );
  }
}

class _InventoryHeader extends StatelessWidget {
  const _InventoryHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Text(
        'Inventory',
        style: Theme.of(
          context,
        ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _SummaryBar extends StatelessWidget {
  const _SummaryBar({required this.state});

  final InventoryState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Wrap(
        spacing: 16,
        runSpacing: 4,
        children: [
          _Summary(label: 'Items', value: '${state.totalItems}'),
          _Summary(
            label: 'Est. Revenue',
            value: formatMoney(state.estimateRevenue, 'IDR'),
            color: const Color(0xFF34D399),
          ),
          _Summary(
            label: 'Value',
            value: formatMoney(state.totalValue, 'IDR'),
            color: const Color(0xFFFBBF24),
          ),
        ],
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.label, required this.value, this.color});

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.white38),
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: color ?? Colors.white,
          ),
        ),
      ],
    );
  }
}

class _ProductFormDialog extends ConsumerStatefulWidget {
  const _ProductFormDialog({this.product});

  final Product? product;

  @override
  ConsumerState<_ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends ConsumerState<_ProductFormDialog> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  late num _price = widget.product?.price ?? 0;
  late num _capital = widget.product?.capital ?? 0;
  late final TextEditingController _stockCtrl;
  bool _trackStock = true;
  bool _busy = false;

  bool get _isEdit => widget.product != null;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameCtrl = TextEditingController(text: p?.name ?? '');
    _descCtrl = TextEditingController(text: p?.description ?? '');
    _stockCtrl = TextEditingController(text: '${p?.stock ?? 0}');
    _trackStock = p?.trackStock ?? true;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _stockCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameCtrl.text.trim();
    final price = _price;
    if (name.isEmpty || price <= 0) return;

    setState(() => _busy = true);
    final ok = _isEdit
        ? await ref
              .read(inventoryControllerProvider.notifier)
              .update(
                widget.product!.id!,
                name: name,
                description: _descCtrl.text.trim().isEmpty
                    ? null
                    : _descCtrl.text.trim(),
                price: price,
                capital: _capital,
                stock: int.tryParse(_stockCtrl.text),
                trackStock: _trackStock,
              )
        : await ref
              .read(inventoryControllerProvider.notifier)
              .create(
                name: name,
                description: _descCtrl.text.trim().isEmpty
                    ? null
                    : _descCtrl.text.trim(),
                price: price,
                capital: _capital,
                stock: int.tryParse(_stockCtrl.text) ?? 0,
                trackStock: _trackStock,
              );
    if (!mounted) return;
    setState(() => _busy = false);
    if (ok) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return CsDialog(
      title: _isEdit ? 'Edit Product' : 'Add Product',
      actions: [
        DompetButton(
          label: _isEdit ? 'Update' : 'Add',
          onPressed: _busy ? null : _submit,
          loading: _busy,
          expand: false,
        ),
      ],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DompetTextField(
            controller: _nameCtrl,
            label: 'Name',
            leading: const Icon(Icons.sell_outlined, color: Colors.white54),
          ),
          const SizedBox(height: 12),
          DompetTextField(
            controller: _descCtrl,
            label: 'Description',
            leading: const Icon(Icons.notes_outlined, color: Colors.white54),
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DompetTextField.balance(
                name: 'product-price',
                label: 'Price',
                value: _price,
                initialCurrency: selectedCurrency(ref),
                onChanged: (v) => setState(() => _price = v ?? 0),
              ),
              const SizedBox(height: 12),
              DompetTextField.balance(
                name: 'product-capital',
                label: 'Capital',
                value: _capital,
                initialCurrency: selectedCurrency(ref),
                onChanged: (v) => setState(() => _capital = v ?? 0),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DompetTextField(
                  controller: _stockCtrl,
                  label: 'Stock',
                  keyboardType: TextInputType.number,
                  enabled: _trackStock,
                  leading: Padding(
                    padding: const .symmetric(horizontal: 8.0),
                    child: const Icon(
                      Icons.inventory_2_outlined,
                      color: Colors.white54,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SwitchListTile(
                  value: _trackStock,
                  onChanged: (v) => setState(() => _trackStock = v),
                  title: const Text(
                    'Track stock',
                    style: TextStyle(fontSize: 12),
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
