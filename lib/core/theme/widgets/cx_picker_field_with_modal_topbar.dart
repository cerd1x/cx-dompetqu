import 'package:material_ui/material_ui.dart';
import 'package:mix/mix.dart';

import 'package:dompetqu/core/theme/widgets/cx_icons.dart';
import 'package:dompetqu/core/theme/dompet_brand.dart';
import 'package:dompetqu/core/theme/widgets/cx_modal_top_sheet.dart';

/// Field bergaya `csinput` yang membuka sheet modal top-bar berisi daftar item
/// yang bisa dicari.
///
/// Generalisasi dari `CustomerPickerField` (contacts) dan `AssetPickerField`
/// (assets): keduanya memakai pola yang sama — tile yang saat ditap membuka
/// [showCxModalTopBar], lalu menampilkan list + pencarian di bawahnya.
/// Perbedaan keduanya hanya sumber data, label, ikon, dan aturan "tidak bisa
/// dipilih" (mis. saldo minimum) yang spesifik fitur. Karena itu widget ini
/// sengaja tidak tahu soal provider/repository: pemanggil yang menyiapkan
/// `items`/`loadItems`/`onRefresh`, sehingga boundary domain–presentation tetap
/// utuh.
///
/// Contoh:
/// ```dart
/// CxPickerFieldWithModalTopbar<Contact>(
///   label: 'Customer',
///   items: contacts,
///   selectedItem: selected,
///   labelOf: (c) => c.name,
///   subtitleOf: (c) => c.phone ?? c.email ?? '',
///   icon: CxIcons.personOutline,
///   onChanged: (c) => setState(() => selected = c),
/// )
/// ```
class CxPickerFieldWithModalTopbar<T> extends StatelessWidget {
  const CxPickerFieldWithModalTopbar({
    super.key,
    required this.label,
    required this.items,
    required this.labelOf,
    required this.icon,
    required this.onChanged,
    this.selectedItem,
    this.isSelectedOf,
    this.subtitleOf,
    this.itemIconOf,
    this.placeholder = 'Belum dipilih',
    this.emptyText = 'Data kosong',
    this.searchHint,
    this.sheetTitle,
    this.loadItems,
    this.onRefresh,
    this.disabledOf,
    this.disabledHintOf,
  });

  /// Label field sekaligus judul sheet (bila [sheetTitle] null).
  final String label;

  /// Item yang ditampilkan di sheet. Urutan dipertahankan.
  final List<T> items;

  /// Teks utama tiap item (juga teks nilai field saat terpilih).
  final String Function(T item) labelOf;

  /// Ikon di sisi kiri tile sekaligus default ikon tiap item.
  final IconData icon;

  /// Dipanggil saat user memilih item.
  final ValueChanged<T> onChanged;

  /// Item yang sedang terpilih. Perbandingan memakai `==` sehingga item hasil
  /// refresh data tetap dianggap sama selama nilai domain-nya ekuivalen
  /// (model `freezed` sudah mengimplementasikan `==`).
  final T? selectedItem;

  /// Override cara menandai item terpilih (mis. bandingkan `id`). Default
  /// memakai `==` terhadap [selectedItem]; berguna saat [selectedItem] hanya
  /// ada di halaman awal sementara sheet memuat daftar lengkap.
  final bool Function(T item)? isSelectedOf;

  /// Baris sekunder tiap item (mis. telepon/email atau saldo).
  final String Function(T item)? subtitleOf;

  /// Override ikon per item bila berbeda dari [icon].
  final IconData Function(T item)? itemIconOf;

  /// Teks saat belum ada item terpilih.
  final String placeholder;

  /// Teks saat daftar kosong (termasuk saat hasil pencarian kosong).
  final String emptyText;

  /// Hint kolom pencarian. Default: `Cari <label>...`.
  final String? searchHint;

  /// Judul di dalam sheet bila berbeda dari [label].
  final String? sheetTitle;

  /// Dimuat sekali saat tile ditap, sebelum sheet dibuka; hasilnya menjadi isi
  /// sheet. Dipakai fitur yang list-nya dipaginasi/baru sebagian termuat —
  /// padanan `ensureAllLoaded()` di `CustomerPickerField`. Bila null, sheet
  /// memakai [items] apa adanya.
  final Future<List<T>> Function()? loadItems;

  /// Tombol refresh di dalam sheet. Bila diisi, hasilnya menggantikan isi list
  /// dan spinner tampil selama future berjalan.
  final Future<List<T>> Function()? onRefresh;

  /// Menandai item yang tidak boleh dipilih (mis. saldo tidak cukup).
  /// Item tetap tampil, tapi berwarna merah dan `onTap`-nya null.
  final bool Function(T item)? disabledOf;

  /// Keterangan pengganti subtitle untuk item yang di-disable.
  final String Function(T item)? disabledHintOf;

  @override
  Widget build(BuildContext context) {
    final selected = selectedItem;

    return _CxPickerFieldTile(
      label: label,
      value: selected == null ? placeholder : labelOf(selected),
      leading: icon,
      onTap: () async {
        final loader = loadItems;
        final source = loader == null ? items : await loader();
        if (!context.mounted) return;
        final picked = await showCxModalTopBar<T>(
          context: context,
          builder: (_) => _CxPickerSheet<T>(
            title: sheetTitle ?? label,
            items: source,
            selectedItem: selectedItem,
            isSelectedOf: isSelectedOf,
            labelOf: labelOf,
            subtitleOf: subtitleOf,
            itemIconOf: itemIconOf,
            defaultIcon: icon,
            emptyText: emptyText,
            searchHint: searchHint ?? 'Cari ${label.toLowerCase()}...',
            onRefresh: onRefresh,
            disabledOf: disabledOf,
            disabledHintOf: disabledHintOf,
          ),
        );
        if (picked != null) onChanged(picked);
      },
    );
  }
}

/// Tile input bergaya `csinput` yang bisa ditap — salinan visual `FieldTile`
/// di `asset_picker_field.dart` supaya `core/` tidak bergantung ke `features/`.
class _CxPickerFieldTile extends StatelessWidget {
  const _CxPickerFieldTile({
    required this.label,
    required this.value,
    required this.leading,
    required this.onTap,
  });

  final String label;
  final String value;
  final IconData leading;
  final VoidCallback onTap;

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
          child: Box(
            style: BoxStyler()
                .padding(
                  EdgeInsetsGeometryMix.value(
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                )
                .decoration(
                  DecorationMix.value(
                    BoxDecoration(
                      color: DompetBrand.csFill,
                      borderRadius: BorderRadius.circular(DompetBrand.radius),
                      border: Border.all(color: DompetBrand.csBorder, width: 1),
                    ),
                  ),
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
                  CxIcons.chevronRightRounded,
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

/// Isi sheet: judul, daftar item, pencarian, dan tombol refresh opsional.
class _CxPickerSheet<T> extends StatefulWidget {
  const _CxPickerSheet({
    required this.title,
    required this.items,
    required this.labelOf,
    required this.defaultIcon,
    required this.emptyText,
    required this.searchHint,
    this.selectedItem,
    this.isSelectedOf,
    this.subtitleOf,
    this.itemIconOf,
    this.onRefresh,
    this.disabledOf,
    this.disabledHintOf,
  });

  final String title;
  final List<T> items;
  final T? selectedItem;
  final bool Function(T item)? isSelectedOf;
  final String Function(T item) labelOf;
  final String Function(T item)? subtitleOf;
  final IconData Function(T item)? itemIconOf;
  final IconData defaultIcon;
  final String emptyText;
  final String searchHint;
  final Future<List<T>> Function()? onRefresh;
  final bool Function(T item)? disabledOf;
  final String Function(T item)? disabledHintOf;

  @override
  State<_CxPickerSheet<T>> createState() => _CxPickerSheetState<T>();
}

class _CxPickerSheetState<T> extends State<_CxPickerSheet<T>> {
  final _ctrl = TextEditingController();
  String _query = '';

  /// List lokal supaya hasil [CxPickerFieldWithModalTopbar.onRefresh] langsung
  /// terpakai tanpa menunggu pemanggil rebuild.
  late List<T> _items = widget.items;
  bool _refreshing = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  bool _isDisabled(T item) => widget.disabledOf?.call(item) ?? false;

  Future<void> _refresh() async {
    final refresh = widget.onRefresh;
    if (refresh == null || _refreshing) return;
    setState(() => _refreshing = true);
    try {
      final next = await refresh();
      if (mounted) setState(() => _items = next);
    } finally {
      if (mounted) setState(() => _refreshing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final query = _query.trim().toLowerCase();
    final filtered = query.isEmpty
        ? _items
        : _items
              .where(
                (item) => widget.labelOf(item).toLowerCase().contains(query),
              )
              .toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // list section — `Flexible` (bukan `Expanded`) supaya tinggi sheet
        // menyesuaikan isi selama masih di bawah batas `showCxModalTopBar`.
        Flexible(
          child: filtered.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    widget.emptyText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white38),
                  ),
                )
              : ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    for (final item in filtered)
                      _buildItem(
                        item,
                        widget.isSelectedOf?.call(item) ??
                            item == widget.selectedItem,
                      ),
                    const SizedBox(height: 8),
                  ],
                ),
        ),

        // search section
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
                    hintText: widget.searchHint,
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
                      CxIcons.search,
                      size: 18,
                      color: Colors.white38,
                    ),
                  ),
                ),
              ),
              if (widget.onRefresh != null) ...[
                const SizedBox(width: 8),
                SizedBox(
                  width: 46,
                  height: 46,
                  child: Material(
                    color: Colors.white.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: _refreshing ? null : _refresh,
                      child: _refreshing
                          ? const Padding(
                              padding: EdgeInsets.all(13),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white70,
                              ),
                            )
                          : const Icon(
                              CxIcons.refreshRounded,
                              size: 20,
                              color: Colors.white70,
                            ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItem(T item, bool selected) {
    final disabled = _isDisabled(item);
    final label = widget.labelOf(item);
    final subtitle = disabled
        ? widget.disabledHintOf?.call(item)
        : widget.subtitleOf?.call(item);
    final accent = disabled
        ? DompetBrand.pink.withValues(alpha: 0.9)
        : selected
        ? const Color(0xFF34D399)
        : Colors.white;

    return ListTile(
      leading: Icon(
        disabled
            ? CxIcons.errorOutline
            : (widget.itemIconOf?.call(item) ?? widget.defaultIcon),
        color: disabled
            ? DompetBrand.pink.withValues(alpha: 0.9)
            : Colors.white70,
      ),
      title: Text(label, style: TextStyle(color: accent)),
      subtitle: subtitle == null || subtitle.isEmpty
          ? null
          : Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: disabled
                    ? DompetBrand.pink.withValues(alpha: 0.7)
                    : Colors.white38,
              ),
            ),
      trailing: selected && !disabled
          ? const Icon(CxIcons.check, color: Color(0xFF34D399))
          : null,
      onTap: disabled ? null : () => Navigator.of(context).pop(item),
    );
  }
}
