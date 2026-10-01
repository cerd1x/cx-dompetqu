import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/cs_dialog.dart';
import '../../../core/theme/widgets/dompet_button.dart';
import '../../../core/theme/widgets/dompet_text_field.dart';
import '../../../core/utils/balance.dart';
import '../application/assets_controller.dart';
import '../models/asset.dart';

/// Dialog tambah saldo asset — padanan `_assets/FormAddBalance.svelte`.
class AddBalanceDialog extends ConsumerStatefulWidget {
  const AddBalanceDialog({super.key, required this.asset});

  final Asset asset;

  @override
  ConsumerState<AddBalanceDialog> createState() => _AddBalanceDialogState();
}

class _AddBalanceDialogState extends ConsumerState<AddBalanceDialog> {
  final _amountCtrl = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final amount = num.tryParse(
      _amountCtrl.text.replaceAll(',', '').replaceAll('.', ''),
    );
    if (amount == null || amount <= 0) return;
    final balance = Balance.parse(widget.asset.balance);

    setState(() => _busy = true);
    final ok = await ref
        .read(assetsControllerProvider.notifier)
        .addBalance(widget.asset.id, '${balance.code} $amount');
    if (!mounted) return;
    setState(() => _busy = false);
    if (ok) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return CsDialog(
      title: 'Add Balance — ${widget.asset.name}',
      actions: [
        DompetButton(
          label: 'Tambah',
          onPressed: _busy ? null : _submit,
          loading: _busy,
          expand: false,
        ),
      ],
      child: DompetTextField(
        controller: _amountCtrl,
        label: 'Amount (${Balance.parse(widget.asset.balance).code})',
        keyboardType: TextInputType.number,
        leading: const Icon(Icons.add_chart, color: Colors.white54),
      ),
    );
  }
}
