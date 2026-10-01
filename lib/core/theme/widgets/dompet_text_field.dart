import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

import '../cs_mix.dart';
import '../dompet_brand.dart';
import 'balance_input_field.dart';

enum DompetTextFieldVariant { glass, csGlassInput, csInput }

/// Input text brand — padanan `TextField.svelte`/melt-ui + gaya daisyUI.
///
/// Constructor utama ([DompetTextField]) secara default memakai gaya `csinput`
/// di web: radius `rounded-2xl`, padding `px-3 py-2`, fill/border
/// `rgba(200,163,182,...)` yang berubah mengikuti hover/focus
/// (`rgba(168,85,247,...)` saat fokus), placeholder `gray-100/40`, dan glass
/// frosted ([CsFrost] backdrop blur 6.1px). Variant lain: `glass` (frosted
/// putih) dan `csGlassInput` (pola `csglass-input`).
class DompetTextField extends StatefulWidget {
  const DompetTextField({
    super.key,
    this.controller,
    this.hintText,
    this.label,
    this.labelStyle,
    this.leading,
    this.trailing,
    this.obscureText = false,
    this.autocorrect = true,
    this.enabled = true,
    this.error = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.variant = DompetTextFieldVariant.csInput,
  }) : _child = null;

  /// Input nominal + picker mata uang — port Flutter `InputBalance.svelte`.
  ///
  /// Memformat nominal realtime sesuai locale (separator ribuan & desimal)
  /// sambil menjaga posisi kursor, dengan dropdown mata uang bergaya
  /// `csglass` dan container input `csglass-input` (sama persis dengan web).
  DompetTextField.balance({
    super.key,
    String? name,
    num value = 0,
    String? label,
    double? width,
    BalanceCountPosition countPosition = BalanceCountPosition.above,
    BalanceLabelPosition labelPosition = BalanceLabelPosition.above,
    bool showCurrency = true,
    List<BalanceCurrency> currencies = kBalanceCurrencies,
    String initialCurrency = 'IDR',
    ValueChanged<num?>? onChanged,
    ValueChanged<String>? onCurrencyChanged,
  }) : _child = BalanceInputField(
         name: name,
         value: value,
         label: label,
         width: width,
         countPosition: countPosition,
         labelPosition: labelPosition,
         showCurrency: showCurrency,
         currencies: currencies,
         initialCurrency: initialCurrency,
         onChanged: onChanged,
         onCurrencyChanged: onCurrencyChanged,
       ),
       controller = null,
       hintText = null,
       label = null,
       labelStyle = null,
       leading = null,
       trailing = null,
       obscureText = false,
       autocorrect = true,
       enabled = true,
       error = false,
       keyboardType = null,
       textInputAction = null,
       onChanged = null,
       onSubmitted = null,
       variant = DompetTextFieldVariant.csInput;

  final TextEditingController? controller;
  final String? hintText;
  final String? label;

  /// Gaya label kustom; `null` = pakai default ([Colors.white70]).
  final TextStyle? labelStyle;
  final Widget? leading;
  final Widget? trailing;
  final bool obscureText;
  final bool autocorrect;
  final bool enabled;
  final bool error;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final DompetTextFieldVariant variant;

  /// Child khusus (mis. balance) yang merender dirinya sendiri di [build].
  final Widget? _child;

  @override
  State<DompetTextField> createState() => _DompetTextFieldState();

  static Widget password({
    Key? key,
    required TextEditingController controller,
    String? hintText,
    String? label,
    TextStyle? labelStyle,
    bool enabled = true,
    bool error = false,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    DompetTextFieldVariant variant = DompetTextFieldVariant.csInput,
  }) {
    return _DompetPasswordTextField(
      key: key,
      controller: controller,
      hintText: hintText,
      label: label,
      labelStyle: labelStyle,
      enabled: enabled,
      error: error,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      variant: variant,
    );
  }
}

class _DompetTextFieldState extends State<DompetTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _hovered = false;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (mounted) setState(() => _focused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  double get _radius => switch (widget.variant) {
    DompetTextFieldVariant.glass => DompetBrand.radiusSm,
    DompetTextFieldVariant.csGlassInput => DompetBrand.radiusSm,
    DompetTextFieldVariant.csInput => DompetBrand.radius,
  };

  /// Padding per variant — `csinput` memakai `px-3 py-2` (12/8),
  /// `csglass-input` & `glass` memakai `p-4 py-2` (16/8).
  EdgeInsetsGeometryMix get _padding => switch (widget.variant) {
    DompetTextFieldVariant.glass || DompetTextFieldVariant.csGlassInput =>
      EdgeInsetsGeometryMix.symmetric(horizontal: 16, vertical: 8),
    DompetTextFieldVariant.csInput => EdgeInsetsGeometryMix.symmetric(
      horizontal: 12,
      vertical: 8,
    ),
  };

  /// Fill per state — `csinput` hover/focus memakai
  /// `rgba(200,163,182,0.14)` (`csFillHover`).
  Color get _fillColor {
    final fill = switch (widget.variant) {
      DompetTextFieldVariant.glass => DompetBrand.glassFill,
      DompetTextFieldVariant.csGlassInput => DompetBrand.csFill,
      DompetTextFieldVariant.csInput => DompetBrand.csFill,
    };
    if (widget.variant == DompetTextFieldVariant.csInput &&
        (_hovered || _focused)) {
      return DompetBrand.csFillHover;
    }
    return fill;
  }

  /// Border & ring per state — padanan util web:
  /// `csglass-input` (hover/focus `rgba(200,163,182,...)`) dan
  /// `csinput` (focus `rgba(168,85,247,...)`).
  ({Color normal, Color hover, Color focus, Color ring}) get _stateColors =>
      switch (widget.variant) {
        DompetTextFieldVariant.glass => (
          normal: DompetBrand.glassBorder,
          hover: const Color(0x29FFFFFF),
          focus: const Color(0x3DFFFFFF),
          ring: const Color(0x1AFFFFFF),
        ),
        DompetTextFieldVariant.csGlassInput => (
          normal: DompetBrand.csBorder,
          hover: DompetBrand.csBorderHover,
          focus: DompetBrand.csBorderHover,
          ring: DompetBrand.csBorderHover,
        ),
        DompetTextFieldVariant.csInput => (
          normal: DompetBrand.csBorder,
          hover: DompetBrand.csBorderHover,
          focus: DompetBrand.csFocusBorder,
          ring: DompetBrand.csFocusRing,
        ),
      };
  Color get _borderColor {
    if (widget.error) return DompetBrand.pink;
    final colors = _stateColors;
    if (_focused) return colors.focus;
    if (_hovered) return colors.hover;
    return colors.normal;
  }

  Color get _hintColor => switch (widget.variant) {
    DompetTextFieldVariant.glass => Colors.white38,
    DompetTextFieldVariant.csGlassInput => const Color(
      0xFF374151,
    ), // placeholder-gray-700
    DompetTextFieldVariant.csInput => const Color(
      0x66F3F4F6,
    ), // dark:placeholder:text-gray-100/40
  };

  List<BoxShadow>? get _frostShadow {
    if (!_focused) return null;
    return [
      BoxShadow(color: _stateColors.ring, blurRadius: 0, spreadRadius: 2),
    ];
  }

  TextFieldStyler get _style {
    final decoration =
        switch (widget.variant) {
          DompetTextFieldVariant.glass => DompetBrand.glassDecoration(
            radius: DompetBrand.radiusSm,
          ),
          DompetTextFieldVariant.csGlassInput => DompetBrand.csGlassInput(
            radius: DompetBrand.radiusSm,
          ),
          DompetTextFieldVariant.csInput => DompetBrand.csInput(
            radius: DompetBrand.radius,
          ),
        }.merge(
          BoxDecorationMix(
            color: _fillColor,
            border: BorderMix.all(BorderSideMix(color: _borderColor, width: 1)),
          ),
        );

    return TextFieldStyler()
        .text(TextStyler(style: TextStyleMix.fontSize(15))) // text-md
        .hintText(TextStyler(style: TextStyleMix.fontSize(15)))
        .padding(_padding)
        .color(Colors.white)
        .hintColor(_hintColor)
        .cursorColor(DompetBrand.purple)
        .decoration(decoration);
  }

  /// Gaya label kustom — mengikuti default Remix (`13`/`Colors.white70`),
  /// lalu menerapkan [DompetTextField.labelStyle] di atasnya.
  TextStyle get _labelTextStyle {
    final base = const TextStyle(fontSize: 13, color: Colors.white70);
    final labelStyle = widget.labelStyle;
    return labelStyle == null ? base : base.merge(labelStyle);
  }

  @override
  Widget build(BuildContext context) {
    final child = widget._child;
    if (child != null) return child;

    final field = RemixTextField(
      controller: widget.controller,
      focusNode: _focusNode,
      hintText: widget.hintText,
      semanticLabel: widget.label,
      leading: widget.leading,
      trailing: widget.trailing,
      obscureText: widget.obscureText,
      autocorrect: widget.autocorrect,
      enabled: widget.enabled,
      error: widget.error,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      style: _style,
    );

    final frosted = CsFrost(
      radius: _radius,
      shadow: _frostShadow,
      child: MouseRegion(
        cursor: widget.enabled
            ? SystemMouseCursors.text
            : SystemMouseCursors.basic,
        onEnter: widget.enabled ? (_) => setState(() => _hovered = true) : null,
        onExit: widget.enabled ? (_) => setState(() => _hovered = false) : null,
        child: field,
      ),
    );

    final label = widget.label;
    if (label == null) return frosted;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(label, style: _labelTextStyle),
        ),
        const SizedBox(height: 8),
        frosted,
      ],
    );
  }
}

class _DompetPasswordTextField extends StatefulWidget {
  const _DompetPasswordTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.label,
    this.labelStyle,
    this.enabled = true,
    this.error = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.variant = DompetTextFieldVariant.csInput,
  });

  final TextEditingController controller;
  final String? hintText;
  final String? label;
  final TextStyle? labelStyle;
  final bool enabled;
  final bool error;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final DompetTextFieldVariant variant;

  @override
  State<_DompetPasswordTextField> createState() =>
      _DompetPasswordTextFieldState();
}

class _DompetPasswordTextFieldState extends State<_DompetPasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return DompetTextField(
      controller: widget.controller,
      hintText: widget.hintText,
      label: widget.label,
      labelStyle: widget.labelStyle,
      leading: const Icon(Icons.lock_outline, color: Colors.white54),
      trailing: IconButton(
        tooltip: _obscureText ? 'Lihat password' : 'Sembunyikan password',
        icon: Icon(
          _obscureText ? Icons.visibility : Icons.visibility_off,
          color: Colors.white54,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      ),
      obscureText: _obscureText,
      autocorrect: false,
      enabled: widget.enabled,
      error: widget.error,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      variant: widget.variant,
    );
  }
}
