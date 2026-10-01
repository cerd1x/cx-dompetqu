import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/dompet_brand.dart';
import '../../../../core/theme/widgets/balance_input_field.dart';
import '../../../../core/theme/widgets/dompet_card.dart';
import '../application/settings_controller.dart';

/// Seksi mata uang dengan dropdown expandable — padanan web.
class CurrencyPickerSection extends ConsumerStatefulWidget {
  const CurrencyPickerSection({super.key, required this.currency});

  final String currency;

  @override
  ConsumerState<CurrencyPickerSection> createState() =>
      _CurrencyPickerSectionState();
}

class _CurrencyPickerSectionState extends ConsumerState<CurrencyPickerSection> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final selected = kBalanceCurrencies.firstWhere(
      (c) => c.code == widget.currency,
      orElse: () => kBalanceCurrencies.first,
    );

    return DompetCard(
      variant: DompetCardVariant.csGlassSurface,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          // currency selector header section
          InkWell(
            onTap: () => setState(() => _open = !_open),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  const Icon(
                    Icons.attach_money,
                    size: 20,
                    color: DompetBrand.purple,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text('Currency', style: TextStyle(fontSize: 14)),
                  ),
                  Text(
                    widget.currency,
                    style: TextStyle(fontSize: 12, color: Colors.white54),
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: _open ? 0.25 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.chevron_right,
                      size: 18,
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // expanded currency list section
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            alignment: Alignment.topCenter,
            child: _open
                ? Column(
                    children: [
                      Divider(
                        height: 1,
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                      for (final c in kBalanceCurrencies)
                        InkWell(
                          onTap: () => ref
                              .read(settingsControllerProvider.notifier)
                              .setCurrency(c.code),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 24,
                                  child: Text(
                                    c.symbol,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white54,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    c.label,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                                if (c.code == selected.code)
                                  const Icon(
                                    Icons.check,
                                    size: 16,
                                    color: DompetBrand.purple,
                                  ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
