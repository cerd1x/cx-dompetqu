// ignore_for_file: file_names
import 'package:dompetqu/features/home/assets/asset_picker_field.dart';
import 'package:dompetqu/features/home/contacts/customer_picker_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/dompet_brand.dart';
import '../../../core/theme/widgets/dompet_button.dart';
import '../../../core/theme/widgets/dompet_text_field.dart';
import '../application/inventory_controller.dart';
import '../application/transactions_controller.dart';
import '../data/order_remote_source.dart';
import '../models/product.dart';
import 'OrderFormWidgets.dart';

/// Form Sale — padanan `FormSale.svelte`.
class SaleForm extends ConsumerStatefulWidget {
  const SaleForm({super.key, this.product});

  final Product? product;

  @override
  ConsumerState<SaleForm> createState() => _SaleFormState();
}

class _SaleFormState extends ConsumerState<SaleForm> {
  late num _amount = widget.product?.price ?? 0;
  late num _capital = widget.product?.capital ?? 0;
  late final TextEditingController _notesCtrl = TextEditingController(
    text: widget.product?.name ?? '',
  );
  String _status = 'belum';
  DateTime _date = DateTime.now();
  String? _payToAssetId;
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
    if (_customerId == null) {
      setState(() => _error = 'Pilih customer terlebih dahulu');
      return;
    }
    if (_payToAssetId == null) {
      setState(() => _error = 'Pilih Pay From Aset terlebih dahulu');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final ok = await ref
          .read(orderRemoteSourceProvider)
          .createProductSale(
            productId: widget.product?.id ?? '',
            itemCount: 1,
            totalAmount: _amount,
            currency: selectedCurrency(ref),
            customerId: _customerId,
            description: _notesCtrl.text.trim().isEmpty
                ? null
                : _notesCtrl.text.trim(),
            payToAssetId: _payToAssetId,
          );
      if (!mounted) return;
      if (ok) {
        ref.invalidate(transactionsControllerProvider);
        ref.invalidate(inventoryControllerProvider);
        context.pop();
      } else {
        setState(() => _error = 'Gagal membuat transaksi');
      }
    } catch (e) {
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
              child: DompetTextField.balance(
                name: 'sale-amount',
                label: 'Amount',
                value: _amount,
                initialCurrency: selectedCurrency(ref),
                onChanged: (v) => setState(() => _amount = v ?? 0),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DompetTextField.balance(
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
          selectedId: _payToAssetId,
          onChanged: (v) => setState(() => _payToAssetId = v),
          minBalance: _amount,
        ),
        const SizedBox(height: 12),
        CustomerPickerField(
          selectedId: _customerId,
          onChanged: (v) => setState(() => _customerId = v),
        ),
        const SizedBox(height: 12),
        DompetTextField(
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
        DompetButton(
          label: _busy ? 'Processing...' : 'Save Transaction',
          onPressed: _busy ? null : _submit,
          loading: _busy,
          expand: true,
        ),
      ],
    );
  }
}
