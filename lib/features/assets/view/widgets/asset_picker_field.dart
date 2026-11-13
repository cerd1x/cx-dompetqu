import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cx_dompetqiu/core/theme/widgets/cx_icons.dart';
import 'package:cx_dompetqiu/core/theme/widgets/cx_picker_field_with_modal_topbar.dart';
import 'package:cx_dompetqiu/core/utils/balance.dart';
import 'package:cx_dompetqiu/features/assets/domain/models/asset.dart';
import 'package:cx_dompetqiu/features/assets/view/stores/assets_store.dart';

/// Picker aset dari [assetsStoreProvider] — padanan `AssetPicker.svelte`.
///
/// Komposisi tipis di atas [CxPickerFieldWithModalTopbar]: tile, sheet, list,
/// dan pencarian tinggal di core. Di sini hanya sumber data, pemetaan id, dan
/// aturan saldo minimum yang spesifik fitur aset.
///
/// Catatan perilaku:
/// - Tombol refresh sengaja tidak dipakai (tidak mengoper `onRefresh`); data
///   aset mengikuti `assetsStoreProvider` yang sudah dimuat layar pemanggil.
/// - Aset dengan saldo < [minBalance] tetap tampil tapi ditandai merah dan tidak
///   bisa dipilih, dengan keterangan batas saldo di bawah judul sheet.
class AssetPickerField extends ConsumerWidget {
  const AssetPickerField({
    super.key,
    this.title = 'Pilih Aset',
    required this.selectedId,
    required this.onChanged,
    this.minBalance,
    this.unShow = const [],
  });

  final String title;
  final String? selectedId;
  final ValueChanged<String?> onChanged;

  /// Id aset yang tidak ditampilkan (mis. aset sumber pada form transfer).
  final List<String> unShow;

  /// Saldo minimum yang wajib dimiliki aset agar bisa dipilih.
  /// Aset dengan balance < [minBalance] ditandai merah & tidak bisa dipilih.
  final num? minBalance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assets = ref.watch(assetsStoreProvider).items;
    Asset? selected;
    for (final a in assets) {
      if (a.id == selectedId) {
        selected = a;
        break;
      }
    }

    // Widget core tidak tahu aturan tiap fitur, jadi penyaringan `unShow`
    // dilakukan di sini — termasuk saat sheet dibuka ulang.
    final visible = assets.where((a) => !unShow.contains(a.id)).toList();

    return CxPickerFieldWithModalTopbar<Asset>(
      label: title,
      items: visible,
      labelOf: (a) => a.name,
      selectedItem: selected,
      isSelectedOf: (a) => a.id == selectedId,
      icon: CxIcons.accountBalanceWalletOutlined,
      emptyText: 'Aset kosong',
      searchHint: 'Cari aset...',
      header: _minBalanceHint(),
      subtitleOf: (a) =>
          '${a.type.toUpperCase()} · ${_formatBalance(a.balance)}',
      disabledOf: _insufficient,
      disabledHintOf: (a) => 'Saldo tidak cukup · ${_formatBalance(a.balance)}',
      // Form memakai id (bukan objek Asset), jadi nilai dari sheet dipetakan
      // ke id di boundary ini.
      onChanged: (asset) => onChanged(asset.id),
    );
  }

  /// Baris "Butuh saldo minimal: …" di bawah judul sheet; null bila tidak ada
  /// batas saldo sehingga sheet hanya menampilkan judul.
  String? _minBalanceHint() {
    final min = minBalance;
    if (min == null || min <= 0) return null;
    return 'Butuh saldo minimal: ${Balance.parse('IDR $min').toLocalStr()}';
  }

  bool _insufficient(Asset asset) {
    final min = minBalance;
    if (min == null || min <= 0) return false;
    final value = _balanceValue(asset.balance);
    if (value == null) return false;
    return value < min;
  }
}

/// Format string "ISO_CODE VALUE" ke mata uang lokal; kembalikan apa adanya
/// bila formatnya tidak dikenal (mis. data backend rusak).
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
