import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cx_dompetqiu/core/theme/widgets/cx_dialog.dart';
import 'package:cx_dompetqiu/core/theme/widgets/cx_button.dart';
import 'package:cx_dompetqiu/core/theme/widgets/cx_text_field.dart';
import 'package:cx_dompetqiu/core/utils/balance.dart';
import 'package:cx_dompetqiu/features/assets/view/stores/assets_store.dart';
import 'package:cx_dompetqiu/features/assets/domain/models/asset.dart';
import 'package:cx_dompetqiu/core/theme/widgets/cx_icons.dart';

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
        .read(assetsStoreProvider.notifier)
        .addBalance(widget.asset.id, '${balance.code} $amount');
    if (!mounted) return;
    setState(() => _busy = false);
    if (ok) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return CxDialog(
      title: 'Add Balance — ${widget.asset.name}',
      actions: [
        CxButton(
          label: 'Tambah',
          onPressed: _busy ? null : _submit,
          loading: _busy,
          expand: false,
        ),
      ],
      child: CxTextField(
        controller: _amountCtrl,
        label: 'Amount (${Balance.parse(widget.asset.balance).code})',
        keyboardType: TextInputType.number,
        leading: const Icon(CxIcons.addChart, color: Colors.white54),
      ),
    );
  }
}
