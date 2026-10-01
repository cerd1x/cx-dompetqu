// ignore_for_file: file_names
import 'package:dompetqu/features/home/assets/asset_picker_field.dart';
import 'package:dompetqu/features/home/contacts/customer_picker_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/dompet_brand.dart';
import '../../../core/theme/widgets/dompet_button.dart';
import '../../../core/theme/widgets/dompet_text_field.dart';
import '../application/contacts_controller.dart';
import '../application/transactions_controller.dart';
import '../data/order_remote_source.dart';
import 'OrderFormWidgets.dart';

/// Form Loan — padanan `FormLoan.svelte`.
class LoanForm extends ConsumerStatefulWidget {
  const LoanForm({super.key});

  @override
  ConsumerState<LoanForm> createState() => _LoanFormState();
}

class _LoanFormState extends ConsumerState<LoanForm> {
  num _amount = 0;
  num _capital = 0;
  String _status = 'belum';
  String _paymentMethod = 'cash';
  DateTime _date = DateTime.now();
  String? _payWithAssetId;
  String? _customerId;
  late final TextEditingController _notesCtrl = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  String get _paymentMethodMapped =>
      _paymentMethod == 'loan' ? 'credit' : _paymentMethod;

  Future<void> _submit() async {
    if (_amount <= 0 || _capital <= 0) {
      setState(() => _error = 'Amount dan Capital harus lebih dari 0');
      return;
    }
    if (_customerId == null) {
      setState(() => _error = 'Pilih customer terlebih dahulu');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final ok = await ref
          .read(orderRemoteSourceProvider)
          .createLoan(
            totalAmount: _amount,
            currency: selectedCurrency(ref),
            itemCount: 1,
            paymentMethod: _paymentMethodMapped,
            customerId: _customerId,
            description: _notesCtrl.text.trim().isEmpty
                ? null
                : _notesCtrl.text.trim(),
            payWithAssetId: _payWithAssetId,
          );
      if (!mounted) return;
      if (ok) {
        ref.invalidate(transactionsControllerProvider);
        ref.invalidate(contactsControllerProvider);
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
                name: 'loan-amount',
                label: 'Amount',
                value: _amount,
                initialCurrency: selectedCurrency(ref),
                onChanged: (v) => setState(() => _amount = v ?? 0),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DompetTextField.balance(
                name: 'loan-capital',
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
        Segmented(
          label: 'Payment Method',
          options: const ['cash', 'transfer', 'loan'],
          labels: const ['Cash', 'Transfer', 'Loan'],
          selected: _paymentMethod,
          onChanged: (v) => setState(() => _paymentMethod = v),
        ),
        const SizedBox(height: 12),
        AssetPickerField(
          title: 'Pay With / To Aset',
          selectedId: _payWithAssetId,
          onChanged: (v) => setState(() => _payWithAssetId = v),
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
