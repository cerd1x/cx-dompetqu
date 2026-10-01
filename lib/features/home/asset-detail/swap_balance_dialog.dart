import 'package:dompetqu/core/theme/widgets/round_action_button.dart';
import 'package:dompetqu/features/home/application/assets_controller.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/cs_dialog.dart';
import '../../../../core/theme/dompet_brand.dart';
import '../../../../core/theme/widgets/balance_input_field.dart';
import '../../../../core/theme/widgets/dompet_text_field.dart';
import '../../../../core/utils/formatters.dart';

class SwapBalanceDialog extends StatefulWidget {
  const SwapBalanceDialog({
    super.key,
    required this.controller,
    required this.items,
  });

  final AssetsController controller;
  final List items;

  @override
  State<SwapBalanceDialog> createState() => _SwapBalanceDialogState();
}

class _SwapBalanceDialogState extends State<SwapBalanceDialog> {
  String? _fromId;
  String? _toId;
  num _swapAmount = 0;
  double _sliderValue = 50;

  @override
  void initState() {
    super.initState();
    if (widget.items.isNotEmpty) {
      _fromId = widget.items.first.id;
      _toId = widget.items.length > 1
          ? widget.items[1].id
          : widget.items.first.id;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  double _getFromBalance() {
    if (_fromId == null) return 0;
    final item = widget.items
        .where((e) => e.id.toString() == _fromId)
        .firstOrNull;
    if (item == null) return 0;

    // Parse balance string "IDR 20000" → 20000.0
    final parts = item.balance.split(' ');
    if (parts.length < 2) return 0;
    return double.tryParse(parts.last) ?? 0;
  }

  String _getBalanceForId(String? id) {
    if (id == null) return formatMoney(0, 'IDR');
    final item = widget.items.where((e) => e.id.toString() == id).firstOrNull;
    if (item == null) return formatMoney(0, 'IDR');
    final parts = item.balance.split(' ');
    final code = parts.first;
    final value = double.tryParse(parts.last) ?? 0;
    return formatMoney(value, code);
  }

  String _getCurrencyCode(String? id) {
    if (id == null) return 'IDR';
    final item = widget.items.where((e) => e.id.toString() == id).firstOrNull;
    if (item == null) return 'IDR';
    return item.balance.split(' ').first;
  }

  void _onAmountChanged(num? value) {
    final input = value ?? 0;
    final balance = _getFromBalance();
    if (balance > 0) {
      final percentage = (input / balance * 100).clamp(0, 100);
      if ((percentage - _sliderValue).abs() > 0.5) {
        setState(() => _sliderValue = percentage.toDouble());
      }
    }
  }

  void _onSliderChanged(double value) {
    setState(() {
      _sliderValue = value;
      final balance = _getFromBalance();
      _swapAmount = balance * value / 100;
    });
  }

  void _reverseAssets() {
    setState(() {
      final temp = _fromId;
      _fromId = _toId;
      _toId = temp;
      _swapAmount = 0;
      _sliderValue = 50;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuItem<String>> options = widget.items
        .map(
          (e) => DropdownMenuItem<String>(
            value: e.id.toString(),
            child: Text(e.name),
          ),
        )
        .toList();

    final balance = _getFromBalance();
    final hasBalance = balance > 0;
    final currencyCode = _getCurrencyCode(_fromId);

    return CsDialog(
      title: 'Swap Balance',
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: hasBalance && _swapAmount > 0
              ? () async {
                  final amount =
                      '$currencyCode ${_swapAmount.toStringAsFixed(0)}';
                  final ok = await widget.controller.swapBalance(
                    _fromId!,
                    _toId!,
                    amount,
                  );
                  if (!context.mounted) return;
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        ok
                            ? 'Berhasil swap ${formatMoney(_swapAmount, currencyCode)}'
                            : 'Gagal swap saldo',
                      ),
                    ),
                  );
                }
              : null,
          style: TextButton.styleFrom(
            backgroundColor: DompetBrand.goldLight.withValues(alpha: 0.2),
            foregroundColor: DompetBrand.goldLight,
          ),
          child: const Text('Swap'),
        ),
      ],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            initialValue: _fromId,
            items: options,
            decoration: const InputDecoration(labelText: 'From'),
            onChanged: (v) {
              setState(() {
                _fromId = v;
                _swapAmount = 0;
                _sliderValue = 50;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 12),
            child: Row(
              children: [
                Text(
                  'Saldo: ${_getBalanceForId(_fromId)}',
                  style: const TextStyle(fontSize: 12, color: Colors.white54),
                ),
                if (!hasBalance) ...[
                  const SizedBox(width: 8),
                  const Text(
                    'Saldo tidak mencukupi',
                    style: TextStyle(fontSize: 12, color: Colors.redAccent),
                  ),
                ],
              ],
            ),
          ),
          Padding(
            padding: const .symmetric(vertical: 12),
            child: Align(
              alignment: .center,
              child: RoundActionButton(
                onTap: _reverseAssets,
                icon: Icons.swap_horiz,
                label: 'Reverse',
                alpha: .6,
              ),
            ),
          ),
          DropdownButtonFormField<String>(
            initialValue: _toId,
            items: options,
            decoration: const InputDecoration(labelText: 'To'),
            onChanged: (v) => setState(() => _toId = v),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'Saldo: ${_getBalanceForId(_toId)}',
              style: const TextStyle(fontSize: 12, color: Colors.white54),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Amount: ${formatMoney(_swapAmount, currencyCode)} / ${formatMoney(balance, currencyCode)} (${_sliderValue.toStringAsFixed(1)}%)',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 12),
          Slider(
            value: _sliderValue,
            min: 0,
            max: 100,
            divisions: 100,
            label: '${_sliderValue.toStringAsFixed(0)}%',
            onChanged: hasBalance ? _onSliderChanged : null,
            activeColor: DompetBrand.goldLight,
            inactiveColor: DompetBrand.csBorderDark,
          ),
          const SizedBox(height: 16),
          DompetTextField.balance(
            name: 'swap-amount',
            value: _swapAmount,
            label: 'Amount to swap',
            countPosition: BalanceCountPosition.label,
            showCurrency: false,
            onChanged: _onAmountChanged,
          ),
        ],
      ),
    );
  }
}
