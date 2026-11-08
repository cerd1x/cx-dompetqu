import 'package:dompetqu/features/assets/view/widgets/asset_picker_field.dart';
import 'package:dompetqu/features/contacts/view/widgets/customer_picker_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:dompetqu/core/logger/app_logger.dart';
import 'package:dompetqu/core/theme/dompet_brand.dart';
import 'package:dompetqu/core/theme/widgets/cx_button.dart';
import 'package:dompetqu/core/theme/widgets/cx_text_field.dart';
import 'package:dompetqu/features/inventory/view/stores/inventory_store.dart';
import 'package:dompetqu/features/transactions/view/stores/transactions_store.dart';
import 'package:dompetqu/features/order/view/stores/order_repository_provider.dart';
import 'package:dompetqu/features/inventory/domain/models/product.dart';
import 'package:dompetqu/features/order/view/widgets/order_form_widgets.dart';

/// Tab Sale — padanan `FormSale.svelte`.
class SaleTab extends ConsumerStatefulWidget {
  const SaleTab({super.key, this.product});

  final Product? product;

  @override
  ConsumerState<SaleTab> createState() => _SaleTabState();
}

class _SaleTabState extends ConsumerState<SaleTab> {
  late num _amount = widget.product?.price ?? 0;
  late num _capital = widget.product?.capital ?? 0;
  late final TextEditingController _notesCtrl = TextEditingController(
    text: widget.product?.name ?? '',
  );
  String _status = 'belum';
  DateTime _date = DateTime.now();
  String? _payWithAssetId;
  String? _customerId;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_amount <= 0 || _capital <= 0) {
      setState(() => _error = 'Amount dan Capital harus lebih dari 0');
      return;
    }
    if (_customerId == null || _customerId!.trim().isEmpty) {
      setState(() => _error = 'Pilih customer terlebih dahulu');
      return;
    }
    if (_payWithAssetId == null || _payWithAssetId!.trim().isEmpty) {
      setState(() => _error = 'Pilih Pay From Aset terlebih dahulu');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final ok = await ref
          .read(orderRepositoryProvider)
          .createProductSale(
            productId: widget.product?.id ?? '',
            itemCount: 1,
            totalAmount: _amount,
            currency: selectedCurrency(ref),
            customerId: _customerId,
            description: _notesCtrl.text.trim().isEmpty
                ? null
                : _notesCtrl.text.trim(),
            payWithAssetId: _payWithAssetId,
            // Nilai segmented ('belum'/'lunas') dipetakan ke enum backend
            // `TransactionPaymentStatus` (`unpaid`/`paid`).
            paymentStatus: _status == 'lunas' ? 'paid' : 'unpaid',
          );
      if (!mounted) return;
      if (ok) {
        ref.invalidate(transactionsStoreProvider);
        ref.invalidate(inventoryStoreProvider);
        context.pop();
      } else {
        setState(() => _error = 'Gagal membuat transaksi');
      }
    } catch (e, stackTrace) {
      AppLogger.instance.debug(
        'Gagal submit product sale: $e',
        tag: 'SaleTab',
        extras: {'stackTrace': '$stackTrace'},
      );
      if (mounted) setState(() => _error = e is Exception ? '$e' : '$e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profit = _amount - _capital;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // amount & capital section
        Row(
          children: [
            Expanded(
              child: CxTextField.balance(
                name: 'sale-amount',
                label: 'Amount',
                value: _amount,
                initialCurrency: selectedCurrency(ref),
                onChanged: (v) => setState(() => _amount = v ?? 0),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: CxTextField.balance(
                name: 'sale-capital',
                label: 'Capital',
                value: _capital,
                initialCurrency: selectedCurrency(ref),
                onChanged: (v) => setState(() => _capital = v ?? 0),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ProfitCard(profit: profit),
        const SizedBox(height: 12),
        // status & date section
        Row(
          children: [
            Expanded(
              child: Segmented(
                label: 'Status',
                options: const ['belum', 'lunas'],
                labels: const ['Unpaid', 'Paid'],
                selected: _status,
                onChanged: (v) => setState(() => _status = v),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DateField(
                label: 'Date',
                value: _date,
                onChanged: (v) => setState(() => _date = v),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        AssetPickerField(
          title: 'Pay From Aset',
          selectedId: _payWithAssetId,
          onChanged: (v) => setState(() => _payWithAssetId = v),
          minBalance: _amount,
        ),
        const SizedBox(height: 12),
        CustomerPickerField(
          selectedId: _customerId,
          onChanged: (v) => setState(() => _customerId = v),
        ),
        const SizedBox(height: 12),
        CxTextField(
          controller: _notesCtrl,
          label: 'Notes',
          hintText: 'Add notes...',
        ),
        if (_error != null) ...[
          const SizedBox(height: 10),
          Text(
            _error!,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: DompetBrand.pink),
          ),
        ],
        const SizedBox(height: 18),
        CxButton(
          label: _busy ? 'Processing...' : 'Save Transaction',
          onPressed: _busy ? null : _submit,
          loading: _busy,
          expand: true,
        ),
      ],
    );
  }
}
