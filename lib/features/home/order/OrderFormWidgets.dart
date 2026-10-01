// ignore_for_file: file_names
import 'package:dompetqu/features/home/assets/asset_picker_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/dompet_brand.dart';
import '../../../core/utils/formatters.dart';
import '../settings/application/settings_controller.dart';

/// Mata uang dari preferensi lokal — padanan `settingStore.selectedCurrency`.
String selectedCurrency(WidgetRef ref) =>
    ref.watch(settingsControllerProvider).value?.currency ?? 'IDR';

/// Kartu profit — padanan baris "Profit" di web.
class ProfitCard extends StatelessWidget {
  const ProfitCard({super.key, required this.profit});

  final num profit;

  @override
  Widget build(BuildContext context) {
    final color = profit >= 0 ? const Color(0xFF34D399) : DompetBrand.pink;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Profit',
            style: TextStyle(fontSize: 12, color: Colors.white38),
          ),
          Text(
            formatMoney(profit, 'IDR'),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Segmented control bertanda — padanan pill status/payment method di web.
class Segmented extends StatelessWidget {
  const Segmented({
    super.key,
    required this.label,
    required this.options,
    required this.labels,
    required this.selected,
    required this.onChanged,
  });

  final String label;
  final List<String> options;
  final List<String> labels;
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 4),
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.white70),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
          ),
          child: Row(
            children: [
              for (var i = 0; i < options.length; i++)
                Expanded(
                  child: GestureDetector(
                    onTap: () => onChanged(options[i]),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: selected == options[i]
                            ? const Color(0x4D34D399)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        labels[i],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: selected == options[i]
                              ? const Color(0xFF6EE7B7)
                              : Colors.white38,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Field tanggal — tap untuk memilih via date picker.
class DateField extends StatelessWidget {
  const DateField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final DateTime value;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    return FieldTile(
      label: label,
      value: DateFormat('d MMM yyyy').format(value),
      leading: Icons.calendar_month_outlined,
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: value,
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
        );
        if (picked != null) onChanged(picked);
      },
    );
  }
}
