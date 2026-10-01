// ignore_for_file: file_names
import 'package:dompetqu/features/home/assets/asset_picker_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/dompet_brand.dart';
import '../../../core/theme/widgets/dompet_button.dart';
import '../../../core/theme/widgets/dompet_text_field.dart';
import '../application/assets_controller.dart';
import '../application/transactions_controller.dart';
import '../data/order_remote_source.dart';
import 'OrderFormWidgets.dart';

/// Form Expense — padanan `FormExpense.svelte`.
class ExpenseForm extends ConsumerStatefulWidget {
  const ExpenseForm({super.key});

  @override
  ConsumerState<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends ConsumerState<ExpenseForm> {
  num _amount = 0;
  DateTime _date = DateTime.now();
  String? _payWithAssetId;
  late final TextEditingController _notesCtrl = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_amount <= 0) {
      setState(() => _error = 'Amount harus lebih dari 0');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final ok = await ref
          .read(orderRemoteSourceProvider)
          .createExpense(
            totalAmount: _amount,
            currency: selectedCurrency(ref),
            itemCount: 1,
            description: _notesCtrl.text.trim().isEmpty
                ? null
                : _notesCtrl.text.trim(),
            paymentMethod: 'cash',
            payWithAssetId: _payWithAssetId,
          );
      if (!mounted) return;
      if (ok) {
        ref.invalidate(transactionsControllerProvider);
        ref.invalidate(assetsControllerProvider);
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DompetTextField.balance(
          name: 'exp-amount',
          label: 'Amount',
          value: _amount,
          initialCurrency: selectedCurrency(ref),
          onChanged: (v) => setState(() => _amount = v ?? 0),
        ),
        const SizedBox(height: 12),
        DateField(
          label: 'Date',
          value: _date,
          onChanged: (v) => setState(() => _date = v),
        ),
        const SizedBox(height: 12),
        AssetPickerField(
          title: 'Pay With Aset',
          selectedId: _payWithAssetId,
          onChanged: (v) => setState(() => _payWithAssetId = v),
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
