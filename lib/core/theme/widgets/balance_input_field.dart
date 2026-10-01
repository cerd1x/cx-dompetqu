import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../utils/formatters.dart';
import '../cs_mix.dart';
import '../dompet_brand.dart';

/// Mata uang untuk picker — padanan `currencies` di `setting_store.svelte`.
class BalanceCurrency {
  const BalanceCurrency({
    required this.code,
    required this.symbol,
    required this.label,
  });

  final String code;
  final String symbol;
  final String label;
}

/// Daftar mata uang bawaan (sama dengan web).
const List<BalanceCurrency> kBalanceCurrencies = [
  BalanceCurrency(code: 'IDR', symbol: 'Rp', label: 'Indonesian Rupiah'),
  BalanceCurrency(code: 'USD', symbol: r'$', label: 'US Dollar'),
  BalanceCurrency(code: 'EUR', symbol: '€', label: 'Euro'),
  BalanceCurrency(code: 'SGD', symbol: r'S$', label: 'Singapore Dollar'),
  BalanceCurrency(code: 'MYR', symbol: 'RM', label: 'Malaysian Ringgit'),
];

/// Posisi nilai terformat — padanan `countPosition` di `InputBalance.svelte`.
enum BalanceCountPosition { above, label, below }

/// Posisi label — padanan `labelPosition` di `InputBalance.svelte`.
enum BalanceLabelPosition { above, below, left }

/// Input nominal uang — port Flutter dari `_components/InputBalance.svelte`.
///
/// - Memformat angka realtime sesuai locale (separator ribuan & desimal),
///   sambil menjaga posisi kursor tetap di digit yang benar.
/// - Picker mata uang bergaya `csglass` (dropdown melayang via [Overlay]).
/// - Container input `csinput` (base style web) + fokus gradient purple→red.
class BalanceInputField extends StatefulWidget {
  const BalanceInputField({
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

  /// Nama field (untuk form/semantics).
  final String? name;

  /// Nilai numerik terkontrol — padanan `count` yang `$bindable`.
  final num value;

  final String? label;

  /// Lebar baris input; `null` = selebar container.
  final double? width;

  final BalanceCountPosition countPosition;
  final BalanceLabelPosition labelPosition;
  final bool showCurrency;
  final List<BalanceCurrency> currencies;
  final String initialCurrency;

  /// Dipanggil saat nilai berubah; `null` saat input kosong/tidak valid.
  final ValueChanged<num?>? onChanged;

  final ValueChanged<String>? onCurrencyChanged;

  @override
  State<BalanceInputField> createState() => _BalanceInputFieldState();
}

class _BalanceInputFieldState extends State<BalanceInputField> {
  static const double _panelWidth = 160;
  static const double _optionHeight = 32;

  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  final GlobalKey _triggerKey = GlobalKey();

  late BalanceCurrency _currency;
  OverlayEntry? _overlayEntry;
  bool _menuOpen = false;
  bool _hovered = false;
  Offset _menuOffset = Offset.zero;

  String get _locale => currencyLocaleMap[_currency.code] ?? 'en_US';

  String get _groupSep =>
      NumberFormat.decimalPattern(_locale).symbols.GROUP_SEP;

  String get _decSep =>
      NumberFormat.decimalPattern(_locale).symbols.DECIMAL_SEP;

  @override
  void initState() {
    super.initState();
    _currency = widget.currencies.firstWhere(
      (c) => c.code == widget.initialCurrency,
      orElse: () => widget.currencies.first,
    );
    _controller = TextEditingController(
      text: _formatNumber(widget.value.toDouble()),
    );
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(BalanceInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && !_focusNode.hasFocus) {
      final parsed = _parseTextValue(_controller.text);
      if (parsed.isNaN || parsed != widget.value) {
        _controller.text = _formatNumber(widget.value.toDouble());
      }
    }
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // ── Formatting & parsing (port logika web) ─────────────────────────────

  double _parseTextValue(String s) {
    var t = s.replaceAll(_groupSep, '');
    final dec = _decSep;
    if (dec != '.') t = t.replaceAll(dec, '.');
    t = t.replaceAll(RegExp(r'[^\d.\-]'), '');
    final dotIdx = t.indexOf('.');
    if (dotIdx != -1) {
      t =
          t.substring(0, dotIdx + 1) +
          t.substring(dotIdx + 1).replaceAll('.', '');
    }
    return double.tryParse(t) ?? double.nan;
  }

  String _formatNumber(double n) {
    if (n.isNaN) return '';
    return NumberFormat('#,##0.##', _locale).format(n);
  }

  int _countDigitsBefore(String s, int pos) {
    var n = 0;
    for (var i = 0; i < pos; i++) {
      if (RegExp(r'\d').hasMatch(s[i])) n++;
    }
    return n;
  }

  int _digitIndexIn(String s, int target) {
    var n = 0;
    for (var i = 0; i < s.length; i++) {
      if (RegExp(r'\d').hasMatch(s[i])) {
        if (n == target) return i;
        n++;
      }
    }
    return s.length;
  }

  void _handleInput(String text) {
    final oldText = _controller.text;
    final rawCursor = _controller.selection.baseOffset;
    final cursor = rawCursor < 0 ? oldText.length : rawCursor;
    final digitsBefore = _countDigitsBefore(oldText, cursor);
    final parsed = _parseTextValue(text);
    widget.onChanged?.call(parsed.isNaN ? null : parsed);
    final formatted = _formatNumber(parsed);
    if (formatted != oldText) {
      final newPos = _digitIndexIn(formatted, digitsBefore);
      _controller.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: newPos),
      );
    }
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      if (widget.value == 0) {
        _controller.text = '';
      }
    } else {
      final parsed = _parseTextValue(_controller.text);
      if (parsed.isNaN || parsed != widget.value) {
        _controller.text = _formatNumber(widget.value.toDouble());
      }
    }
    setState(() {});
  }

  // ── Currency picker (dropdown overlay) ─────────────────────────────────

  void _toggleMenu() => _menuOpen ? _closeMenu() : _openMenu();

  void _openMenu() {
    final box = _triggerKey.currentContext?.findRenderObject() as RenderBox?;
    final overlayBox =
        Overlay.of(context).context.findRenderObject() as RenderBox?;
    if (box == null || overlayBox == null) return;

    final pos = box.localToGlobal(Offset.zero);
    final panelH = widget.currencies.length * _optionHeight + 8;
    final belowSpace = overlayBox.size.height - pos.dy - box.size.height;
    final above = belowSpace < panelH + 24 && pos.dy > panelH + 24;
    var left = pos.dx;
    if (left + _panelWidth > overlayBox.size.width - 8) {
      left = overlayBox.size.width - _panelWidth - 8;
    }
    left = left.clamp(8, overlayBox.size.width - _panelWidth - 8);
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
            width: _panelWidth,
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
                child: _buildCurrencyPanel(),
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

  void _selectCurrency(BalanceCurrency currency) {
    final changed = currency.code != _currency.code;
    _currency = currency;
    _closeMenu();
    if (changed) widget.onCurrencyChanged?.call(currency.code);
  }

  Widget _buildCurrencyPanel() {
    return CsFrost(
      radius: DompetBrand.radiusSm,
      shadow: const [
        BoxShadow(
          color: DompetBrand.csShadowDark,
          blurRadius: 30,
          offset: Offset(0, 4),
        ),
      ],
      child: Container(
        width: _panelWidth,
        decoration: BoxDecoration(
          color: DompetBrand.csFillDark,
          borderRadius: BorderRadius.circular(DompetBrand.radiusSm),
          border: Border.all(color: DompetBrand.csBorderDark, width: 1),
        ),
        padding: const EdgeInsets.all(4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final cur in widget.currencies) ...[
              _CurrencyOption(
                currency: cur,
                selected: cur.code == _currency.code,
                onTap: () => _selectCurrency(cur),
              ),
              if (cur != widget.currencies.last) const SizedBox(height: 2),
            ],
          ],
        ),
      ),
    );
  }

  // ── Sections ───────────────────────────────────────────────────────────

  Widget _buildLabel() {
    final labelWidget = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.label ?? '',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
          ),
        ),
        if (widget.countPosition == BalanceCountPosition.label)
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              '${_currency.code} ${_currency.symbol} ${widget.value}',
              style: const TextStyle(fontSize: 10, color: Colors.white38),
            ),
          ),
      ],
    );

    return switch (widget.labelPosition) {
      BalanceLabelPosition.above => Padding(
        padding: const EdgeInsets.only(left: 8, bottom: 2),
        child: labelWidget,
      ),
      BalanceLabelPosition.below => Padding(
        padding: const EdgeInsets.only(left: 8, top: 2),
        child: labelWidget,
      ),
      BalanceLabelPosition.left => Padding(
        padding: const EdgeInsets.only(left: 8, right: 4),
        child: labelWidget,
      ),
    };
  }

  Widget _buildFormattedValue() {
    final display = formatMoney(widget.value, _currency.code);
    return Padding(
      padding: widget.countPosition == BalanceCountPosition.above
          ? const EdgeInsets.only(left: 4, bottom: 2)
          : const EdgeInsets.only(left: 4, top: 2),
      child: Text(
        display,
        style: const TextStyle(fontSize: 12, color: Colors.white54),
      ),
    );
  }

  Widget _buildInputRow() {
    final focused = _focusNode.hasFocus;
    final borderColor = focused
        ? DompetBrand
              .csFocusBorder // focus:border-[rgba(168,85,247,0.65)]
        : _hovered
        ? DompetBrand
              .csBorderHover // hover:border-[rgba(200,163,182,0.65)]
        : DompetBrand.csBorder; // border-[rgba(200,163,182,0.4)]
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: CsFrost(
        radius: DompetBrand.radius, // rounded-2xl
        shadow: [
          focused
              ? const BoxShadow(
                  color: DompetBrand
                      .csFocusRing, // focus:ring-2 ring-[rgba(168,85,247,0.35)]
                  blurRadius: 0,
                  spreadRadius: 2,
                )
              : const BoxShadow(
                  color: DompetBrand
                      .csShadow, // shadow-[0_4px_30px_rgba(0,0,0,0.1)]
                  blurRadius: 30,
                  offset: Offset(0, 4),
                ),
        ],
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ), // px-3 py-2
          decoration: BoxDecoration(
            color: focused || _hovered
                ? DompetBrand
                      .csFillHover // hover/focus bg rgba(200,163,182,0.14)
                : DompetBrand.csFill, // bg-[rgba(200,163,182,0.08)]
            borderRadius: BorderRadius.circular(DompetBrand.radius),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Row(
            children: [
              if (widget.showCurrency) ...[
                _buildCurrencyTrigger(),
                const SizedBox(width: 8),
              ],
              Expanded(child: _buildTextField()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrencyTrigger() {
    return InkWell(
      key: _triggerKey,
      onTap: _toggleMenu,
      borderRadius: BorderRadius.circular(DompetBrand.radiusSm),
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
        color: DompetBrand.csFill,
          borderRadius: BorderRadius.circular(DompetBrand.radiusSm),
        border: Border.all(color: DompetBrand.csBorder, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _currency.symbol,
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
            const SizedBox(width: 4),
            Text(
              _currency.code,
              style: const TextStyle(fontSize: 10, color: Colors.white54),
            ),
            const SizedBox(width: 4),
            AnimatedRotation(
              turns: _menuOpen ? 0.5 : 0,
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

  Widget _buildTextField() {
    final focused = _focusNode.hasFocus;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      height: 32,
      decoration: BoxDecoration(
        gradient: focused
          ? LinearGradient(
                colors: [
                DompetBrand.gold.withValues(alpha: 0.16),
                DompetBrand.purple.withValues(alpha: 0.08),
                ],
              )
            : null,
        color: focused ? null : Colors.transparent,
        borderRadius: BorderRadius.circular(DompetBrand.radiusSm),
        border: Border.all(
        color: focused ? Colors.transparent : DompetBrand.csBorderHover,
          width: 1,
        ),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
            height: 1.0,
          ),
          cursorColor: DompetBrand.purple,
          textInputAction: TextInputAction.done,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[\d.,\-]')),
          ],
          onChanged: _handleInput,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasLabel = widget.label != null && widget.label!.isNotEmpty;

    final inputGroup = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.countPosition == BalanceCountPosition.above)
          _buildFormattedValue(),
        if (widget.width != null)
          SizedBox(width: widget.width, child: _buildInputRow())
        else
          _buildInputRow(),
        if (widget.countPosition == BalanceCountPosition.below)
          _buildFormattedValue(),
      ],
    );

    if (widget.labelPosition == BalanceLabelPosition.left && hasLabel) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildLabel(),
          Expanded(child: inputGroup),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (hasLabel && widget.labelPosition == BalanceLabelPosition.above)
          _buildLabel(),
        inputGroup,
        if (hasLabel && widget.labelPosition == BalanceLabelPosition.below)
          _buildLabel(),
      ],
    );
  }
}

class _CurrencyOption extends StatelessWidget {
  const _CurrencyOption({
    required this.currency,
    required this.selected,
    required this.onTap,
  });

  final BalanceCurrency currency;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      hoverColor: DompetBrand.csFillHover,
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: selected ? DompetBrand.csFillHover : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              child: Text(
                currency.symbol,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFFEA580C), // orange-600
                ),
              ),
            ),
            Expanded(
              child: Text(
                currency.code,
                style: TextStyle(
                  fontSize: 12,
                  color: selected ? DompetBrand.purple : const Color(0x80EA580C), // orange-600/50
                ),
              ),
            ),
            if (selected)
              Icon(
                Icons.check,
                size: 12,
                color: DompetBrand.purple,
              ),
          ],
        ),
      ),
    );
  }
}
