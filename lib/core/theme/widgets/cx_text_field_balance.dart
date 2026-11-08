import 'package:flutter/material.dart';

import 'balance_input_field.dart';

/// Input nominal + picker mata uang — port Flutter `InputBalance.svelte`.
///
/// Memformat nominal realtime sesuai locale (separator ribuan & desimal)
/// sambil menjaga posisi kursor, dengan dropdown mata uang bergaya
/// `csglass` dan container input `csglass-input` (sama persis dengan web).
class CxTextFieldBalance extends StatelessWidget {
  const CxTextFieldBalance({
    super.key,
    this.name,
    this.value = 0,
    this.label,
    this.width,
    this.countPosition = BalanceCountPosition.above,
    this.labelPosition = BalanceLabelPosition.above,
    this.showCurrency = true,
    this.currencies = kBalanceCurrencies,
    this.initialCurrency = 'IDR',
    this.onChanged,
    this.onCurrencyChanged,
  });

  final String? name;
  final num value;
  final String? label;
  final double? width;
  final BalanceCountPosition countPosition;
  final BalanceLabelPosition labelPosition;
  final bool showCurrency;
  final List<BalanceCurrency> currencies;
  final String initialCurrency;
  final ValueChanged<num?>? onChanged;
  final ValueChanged<String>? onCurrencyChanged;

  @override
  Widget build(BuildContext context) {
    return BalanceInputField(
      name: name,
      value: value,
      label: label,
      width: width,
      countPosition: countPosition,
      labelPosition: labelPosition,
      showCurrency: showCurrency,
      currencies: currencies,
      initialCurrency: initialCurrency,
      onChanged: onChanged,
      onCurrencyChanged: onCurrencyChanged,
    );
  }
}
