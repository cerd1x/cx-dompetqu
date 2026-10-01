import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../cs_mix.dart';
import '../dompet_brand.dart';

/// Generic item untuk [CSSelectPicker].
class CSSelectItem<T> {
  const CSSelectItem({
    required this.value,
    required this.label,
    this.symbol,
    this.icon,
  });

  final T value;
  final String label;
  final String? symbol;
  final IconData? icon;
}

/// Generic overlay-based select picker — bergaya `csglass` (frosted glass),
/// positioning pintar di atas/bawah trigger, ESC untuk tutup, klik outside tutup.
///
/// Contoh:
/// ```dart
/// CSSelectPicker<String>(
///   items: [CSSelectItem(value: 'idr', label: 'IDR', symbol: 'Rp')],
///   value: 'idr',
///   onChanged: (v) => print(v),
///   itemBuilder: (item, selected) => Text(item.label),
/// )
/// ```
class CSSelectPicker<T> extends StatefulWidget {
  const CSSelectPicker({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    this.itemBuilder,
    this.triggerBuilder,
    this.panelWidth = 160,
    this.optionHeight = 32,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.borderRadius = DompetBrand.radiusSm,
  });

  /// Daftar opsi yang bisa dipilih.
  final List<CSSelectItem<T>> items;

  /// Nilai terpilih saat ini.
  final T value;

  /// Dipanggil saat user memilih item baru.
  final ValueChanged<T> onChanged;

  /// Custom builder untuk item di panel dropdown.
  /// Default: menampilkan symbol (jika ada) + label, dengan check icon jika selected.
  final Widget Function(CSSelectItem<T> item, bool selected)? itemBuilder;

  /// Custom builder untuk trigger button.
  /// Default: menampilkan symbol + label + dropdown arrow.
  final Widget Function(
    CSSelectItem<T> selectedItem,
    bool menuOpen,
    VoidCallback onTap,
  )?
  triggerBuilder;

  final double panelWidth;
  final double optionHeight;
  final EdgeInsets padding;
  final double borderRadius;

  @override
  State<CSSelectPicker<T>> createState() => _CSSelectPickerState<T>();
}

class _CSSelectPickerState<T> extends State<CSSelectPicker<T>> {
  final GlobalKey _triggerKey = GlobalKey();
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  bool _menuOpen = false;
  Offset _menuOffset = Offset.zero;

  CSSelectItem<T> get _selectedItem => widget.items.firstWhere(
    (i) => i.value == widget.value,
    orElse: () => widget.items.first,
  );

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleMenu() => _menuOpen ? _closeMenu() : _openMenu();

  void _openMenu() {
    final box = _triggerKey.currentContext?.findRenderObject() as RenderBox?;
    final overlayBox =
        Overlay.of(context).context.findRenderObject() as RenderBox?;
    if (box == null || overlayBox == null) return;

    final pos = box.localToGlobal(Offset.zero);
    final panelH = widget.items.length * widget.optionHeight + 8;
    final belowSpace = overlayBox.size.height - pos.dy - box.size.height;
    final above = belowSpace < panelH + 24 && pos.dy > panelH + 24;
    var left = pos.dx;
    if (left + widget.panelWidth > overlayBox.size.width - 8) {
      left = overlayBox.size.width - widget.panelWidth - 8;
    }
    left = left.clamp(8, overlayBox.size.width - widget.panelWidth - 8);
    _menuOffset = Offset(
      left,
      above ? pos.dy - panelH - 11 : pos.dy + box.size.height + 11,
    );

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _closeMenu,
            ),
          ),
          Positioned(
            left: _menuOffset.dx,
            top: _menuOffset.dy,
            width: widget.panelWidth,
            child: Material(
              type: MaterialType.transparency,
              child: Focus(
                autofocus: true,
                onKeyEvent: (node, event) {
                  if (event is KeyDownEvent &&
                      event.logicalKey == LogicalKeyboardKey.escape) {
                    _closeMenu();
                    return KeyEventResult.handled;
                  }
                  return KeyEventResult.ignored;
                },
                child: _buildPanel(),
              ),
            ),
          ),
        ],
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _menuOpen = true);
  }

  void _closeMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) setState(() => _menuOpen = false);
  }

  void _selectItem(CSSelectItem<T> item) {
    if (item.value != widget.value) {
      widget.onChanged(item.value);
    }
    _closeMenu();
  }

  Widget _buildPanel() {
    return CsFrost(
      radius: widget.borderRadius,
      shadow: const [
        BoxShadow(
          color: DompetBrand.csShadowDark,
          blurRadius: 30,
          offset: Offset(0, 4),
        ),
      ],
      child: Container(
        width: widget.panelWidth,
        decoration: BoxDecoration(
          color: DompetBrand.csFillDark,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(color: DompetBrand.csBorderDark, width: 1),
        ),
        padding: const EdgeInsets.all(4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < widget.items.length; i++) ...[
              _buildItem(
                widget.items[i],
                widget.items[i].value == widget.value,
              ),
              if (i != widget.items.length - 1) const SizedBox(height: 2),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildItem(CSSelectItem<T> item, bool selected) {
    if (widget.itemBuilder != null) {
      return InkWell(
        onTap: () => _selectItem(item),
        borderRadius: BorderRadius.circular(8),
        hoverColor: DompetBrand.csFillHover,
        child: Container(
          height: widget.optionHeight,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: selected ? DompetBrand.csFillHover : null,
            borderRadius: BorderRadius.circular(8),
          ),
          child: widget.itemBuilder!(item, selected),
        ),
      );
    }

    return InkWell(
      onTap: () => _selectItem(item),
      borderRadius: BorderRadius.circular(8),
      hoverColor: DompetBrand.csFillHover,
      child: Container(
        height: widget.optionHeight,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: selected ? DompetBrand.csFillHover : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            if (item.symbol != null)
              SizedBox(
                width: 40,
                child: Text(
                  item.symbol!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFEA580C), // orange-600
                  ),
                ),
              ),
            if (item.icon != null)
              SizedBox(
                width: 24,
                child: Icon(item.icon, size: 14, color: Colors.white70),
              ),
            Expanded(
              child: Text(
                item.label,
                style: TextStyle(
                  fontSize: 12,
                  color: selected
                      ? DompetBrand.purple
                      : const Color(0x80EA580C),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (selected)
              Icon(Icons.check, size: 12, color: DompetBrand.purple),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultTrigger(
    CSSelectItem<T> item,
    bool menuOpen,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: DompetBrand.csFill,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(color: DompetBrand.csBorder, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item.symbol != null) ...[
              Text(
                item.symbol!,
                style: const TextStyle(fontSize: 12, color: Colors.white),
              ),
              const SizedBox(width: 4),
            ],
            if (item.icon != null) ...[
              Icon(item.icon, size: 14, color: Colors.white70),
              const SizedBox(width: 4),
            ],
            Text(
              item.label,
              style: const TextStyle(fontSize: 10, color: Colors.white54),
            ),
            const SizedBox(width: 4),
            AnimatedRotation(
              turns: menuOpen ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final trigger =
        widget.triggerBuilder?.call(_selectedItem, _menuOpen, _toggleMenu) ??
        _buildDefaultTrigger(_selectedItem, _menuOpen, _toggleMenu);
    return Container(key: _triggerKey, child: trigger);
  }
}
