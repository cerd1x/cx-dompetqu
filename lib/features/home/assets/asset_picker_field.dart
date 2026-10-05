import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/dompet_brand.dart';
import '../../../core/theme/widgets/cs_modal_top_sheet.dart';
import '../../../core/utils/balance.dart';
import '../application/assets_controller.dart';
import '../models/asset.dart';

/// Picker aset dari [assetsControllerProvider] — padanan `AssetPicker.svelte`.
class AssetPickerField extends ConsumerWidget {
  const AssetPickerField({
    super.key,
    this.title = 'Pilih Aset',
    required this.selectedId,
    required this.onChanged,
    this.minBalance,
  });

  final String title;
  final String? selectedId;
  final ValueChanged<String?> onChanged;

  /// Saldo minimum yang wajib dimiliki aset agar bisa dipilih.
  /// Aset dengan balance < [minBalance] ditandai merah & tidak bisa dipilih.
  final num? minBalance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assets = ref.watch(assetsControllerProvider).items;
    Asset? selected;
    for (final a in assets) {
      if (a.id == selectedId) {
        selected = a;
        break;
      }
    }

    return FieldTile(
      label: title,
      value: selected?.name ?? 'Belum dipilih',
      leading: Icons.account_balance_wallet_outlined,
      onTap: () async {
        final picked = await showCsModalTopBar<String>(
          context: context,
          builder: (sheetCtx) => _AssetPickerSheet(
            selectedId: selectedId,
            title: title,
            minBalance: minBalance,
          ),
        );
        if (picked != null) onChanged(picked);
      },
    );
  }
}

/// Tile input bergaya `csinput` yang bisa ditap.
class FieldTile extends StatelessWidget {
  const FieldTile({super.key, 
    required this.label,
    required this.value,
    required this.onTap,
    required this.leading,
  });

  final String label;
  final String value;
  final VoidCallback onTap;
  final IconData leading;

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
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: DompetBrand.csFill,
              borderRadius: BorderRadius.circular(DompetBrand.radius),
              border: Border.all(color: DompetBrand.csBorder, width: 1),
            ),
            child: Row(
              children: [
                Icon(leading, size: 18, color: Colors.white54),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: Colors.white38,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AssetPickerSheet extends ConsumerStatefulWidget {
  const _AssetPickerSheet({
    this.selectedId,
    this.title = 'Pilih Aset',
    this.minBalance,
  });

  final String? selectedId;
  final String title;
  final num? minBalance;

  @override
  ConsumerState<_AssetPickerSheet> createState() => _AssetPickerSheetState();
}

class _AssetPickerSheetState extends ConsumerState<_AssetPickerSheet> {
  final _ctrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    await ref.read(assetsControllerProvider.notifier).load();
  }

  String _formatBalance(String raw) {
    try {
      return Balance.parse(raw).toLocalStr();
    } on FormatException {
      return raw;
    }
  }

  num? _balanceValue(String raw) {
    try {
      return Balance.parse(raw).value;
    } on FormatException {
      return null;
    }
  }

  bool _insufficient(Asset asset) {
    final min = widget.minBalance;
    if (min == null || min <= 0) return false;
    final value = _balanceValue(asset.balance);
    if (value == null) return false;
    return value < min;
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(assetsControllerProvider);
    final assets = controller.items;
    final filtered = _query.isEmpty
        ? assets
        : assets
              .where((a) => a.name.toLowerCase().contains(_query.toLowerCase()))
              .toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: filtered.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'Aset kosong',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white38),
                  ),
                )
              : ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (widget.minBalance != null &&
                              widget.minBalance! > 0) ...[
                            const SizedBox(height: 4),
                            Text(
                              'Butuh saldo minimal: '
                              '${Balance.parse('IDR ${widget.minBalance}').toLocalStr()}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white54,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    for (final asset in filtered)
                      Builder(builder: (_) {
                        final insufficient = _insufficient(asset);
                        final selected = asset.id == widget.selectedId;
                        final accent = insufficient
                            ? DompetBrand.pink.withValues(alpha: 0.9)
                            : selected
                                ? const Color(0xFF34D399)
                                : Colors.white70;
                        return ListTile(
                          leading: Icon(
                            insufficient
                                ? Icons.error_outline
                                : Icons.account_balance_wallet_outlined,
                            color: insufficient
                                ? DompetBrand.pink.withValues(alpha: 0.9)
                                : Colors.white70,
                          ),
                          title: Text(
                            asset.name,
                            style: TextStyle(color: accent),
                          ),
                          subtitle: Text(
                            insufficient
                                ? 'Saldo tidak cukup · ${_formatBalance(asset.balance)}'
                                : '${asset.type.toUpperCase()} · ${_formatBalance(asset.balance)}',
                            style: TextStyle(
                              fontSize: 11,
                              color: insufficient
                                  ? DompetBrand.pink.withValues(alpha: 0.7)
                                  : Colors.white38,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _formatBalance(asset.balance),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: accent,
                                ),
                              ),
                              if (insufficient) ...[
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.error_outline,
                                  size: 18,
                                  color: DompetBrand.pink.withValues(
                                    alpha: 0.9,
                                  ),
                                ),
                              ] else if (selected) ...[
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.check,
                                  color: Color(0xFF34D399),
                                ),
                              ],
                            ],
                          ),
                          onTap: insufficient
                              ? null
                              : () => Navigator.of(context).pop(asset.id),
                        );
                      }),
                    const SizedBox(height: 8),
                  ],
                ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _ctrl,
                  onChanged: (v) => setState(() => _query = v),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Cari aset...',
                    hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.06),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 18,
                      color: Colors.white38,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 46,
                height: 46,
                child: Material(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: controller.loading ? null : _refresh,
                    child: controller.loading
                        ? const Padding(
                            padding: EdgeInsets.all(13),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white70,
                            ),
                          )
                        : const Icon(
                            Icons.refresh_rounded,
                            size: 20,
                            color: Colors.white70,
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
