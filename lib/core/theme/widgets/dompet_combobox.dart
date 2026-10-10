import 'package:flutter/material.dart';

/// Combobox (dropdown dengan pencarian) bergaya DompetQu.
///
/// Membungkus `DropdownMenu` Material 3 dengan styling gelap + border glass dan
/// opsi pencarian, supaya konsisten dengan widget tema lain. Nilai yang dipilih
/// ditulis ke [controller] (teks = [labelOf] item), sehingga pemanggil bisa
/// membacanya seperti `TextField` biasa.
///
/// ```dart
/// DompetCombobox<String>(
///   controller: _ctrl,
///   items: kGraphqlOperations,
///   labelOf: (s) => s,
///   label: 'Operation key',
///   helperText: '${kGraphqlOperations.length} operation',
/// )
/// ```
class DompetCombobox<T> extends StatelessWidget {
  const DompetCombobox({
    super.key,
    required this.items,
    required this.labelOf,
    this.controller,
    this.initialSelection,
    this.onSelected,
    this.enabled = true,
    this.searchable = true,
    this.expand = true,
    this.menuHeight = 320,
    this.label,
    this.hintText,
    this.helperText,
    this.textStyle,
    this.menuBackgroundColor = const Color(0xFF17171C),
  });

  /// Daftar nilai yang bisa dipilih.
  final List<T> items;

  /// Label untuk tiap item (juga jadi nilai teks pada [controller]).
  final String Function(T value) labelOf;

  /// Controller teks. Diisi otomatis dengan label item saat dipilih.
  final TextEditingController? controller;

  /// Pilihan awal.
  final T? initialSelection;

  /// Callback saat item dipilih.
  final ValueChanged<T?>? onSelected;

  /// Aktif/tidaknya field.
  final bool enabled;

  /// Tampilkan pencarian (filter saat mengetik + search field di menu).
  final bool searchable;

  /// Bila `true`, field melebar penuh (expandedInsets nol).
  final bool expand;

  /// Tinggi maksimum menu dropdown.
  final double menuHeight;

  /// Label di atas field.
  final Widget? label;

  /// Placeholder saat kosong.
  final String? hintText;

  /// Teks bantuan di bawah field.
  final String? helperText;

  /// Gaya teks isi field.
  final TextStyle? textStyle;

  /// Warna latar menu dropdown.
  final Color menuBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
    );

    return DropdownMenu<T>(
      controller: controller,
      initialSelection: initialSelection,
      onSelected: onSelected,
      enabled: enabled,
      expandedInsets: expand ? EdgeInsets.zero : null,
      enableFilter: searchable,
      enableSearch: searchable,
      requestFocusOnTap: true,
      menuHeight: menuHeight,
      label: label,
      hintText: hintText,
      helperText: helperText,
      textStyle:
          textStyle ?? const TextStyle(fontSize: 13, color: Colors.white),
      dropdownMenuEntries: [
        for (final item in items)
          DropdownMenuEntry<T>(value: item, label: labelOf(item)),
      ],
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.04),
        border: border,
        enabledBorder: border,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(menuBackgroundColor),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        side: WidgetStatePropertyAll(
          BorderSide(color: Colors.white.withValues(alpha: 0.12)),
        ),
      ),
    );
  }
}
