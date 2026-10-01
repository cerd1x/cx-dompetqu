import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/cs_dialog.dart';
import '../../../core/theme/widgets/balance_input_field.dart';
import '../../../core/theme/widgets/dompet_button.dart';
import '../../../core/theme/widgets/dompet_text_field.dart';
import '../../../core/utils/balance.dart';
import '../application/assets_controller.dart';
import '../models/asset.dart';

const _assetTypes = ['bank', 'ewallet', 'cash', 'crypto', 'loan'];
const _currencies = ['IDR', 'USD', 'EUR', 'JPY', 'GBP', 'SGD'];

/// Dialog tambah/ubah asset — padanan `_assets/FormAsset.svelte`.
class AssetFormDialog extends ConsumerStatefulWidget {
  const AssetFormDialog({super.key, this.asset});

  final Asset? asset;

  @override
  ConsumerState<AssetFormDialog> createState() => _AssetFormDialogState();
}

class _AssetFormDialogState extends ConsumerState<AssetFormDialog> {
  late final TextEditingController _nameCtrl;
  num? _balanceValue;
  String _type = 'cash';
  String _currency = 'IDR';
  bool _busy = false;

  bool get _isEdit => widget.asset != null;

  @override
  void initState() {
    super.initState();
    final a = widget.asset;
    _nameCtrl = TextEditingController(text: a?.name ?? '');
    if (a != null) {
      _type = a.type;
      final balance = Balance.parse(a.balance);
      _currency = balance.code;
      _balanceValue = balance.value;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;

    setState(() => _busy = true);
    final ok = _isEdit
        ? await ref
              .read(assetsControllerProvider.notifier)
              .update(
                widget.asset!.id,
                name: name,
                type: _type,
              )
        : await ref
              .read(assetsControllerProvider.notifier)
              .create(
                name: name,
                type: _type,
                balance: '$_currency ${_balanceValue ?? 0}',
              );
    if (!mounted) return;
    setState(() => _busy = false);
    if (ok) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return CsDialog(
      title: _isEdit ? 'Update Asset' : 'Add Asset',
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
            leading: const Icon(
              Icons.account_balance_wallet_outlined,
              color: Colors.white54,
            ),
          ),
          const SizedBox(height: 12),
          _DropdownField<String>(
            label: 'Type',
            value: _type,
            options: _assetTypes,
            onChanged: (v) => setState(() => _type = v!),
          ),
          const SizedBox(height: 12),
          if (!_isEdit)
            Row(
              children: [
                Expanded(
                  child: _DropdownField<String>(
                    label: 'Currency',
                    value: _currency,
                    options: _currencies,
                    onChanged: (v) => setState(() => _currency = v!),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DompetTextField.balance(
                    name: 'asset-balance',
                    label: 'Balance',
                    value: _balanceValue ?? 0,
                    countPosition: BalanceCountPosition.below,
                    showCurrency: false,
                    onChanged: (v) => setState(() => _balanceValue = v),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _DropdownField<T> extends StatelessWidget {
  const _DropdownField({
    required this.label,
    required this.value,
    required this.options,
    this.onChanged,
  });

  final String label;
  final T value;
  final List<T> options;
  final ValueChanged<T?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      dropdownColor: const Color(0xFF2A2A2A),
      style: const TextStyle(color: Colors.white, fontSize: 13),
      iconEnabledColor: Colors.white54,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white54, fontSize: 12),
        isDense: true,
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white10),
        ),
      ),
      items: [
        for (final option in options)
          DropdownMenuItem(value: option, child: Text('$option')),
      ],
      onChanged: onChanged,
    );
  }
}
