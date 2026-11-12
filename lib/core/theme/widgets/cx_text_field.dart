import 'package:material_ui/material_ui.dart';
import 'package:remix/remix.dart';

import 'package:dompetqu/core/theme/cs_mix.dart';
import 'package:dompetqu/core/theme/dompet_brand.dart';

enum CxTextFieldVariant { glass, csGlassInput, csInput }

/// Input text brand — padanan `TextField.svelte`/melt-ui + gaya daisyUI.
///
/// Constructor utama ([CxTextField]) secara default memakai gaya `csinput`
/// di web: radius `rounded-2xl`, padding `px-3 py-2`, fill/border
/// `rgba(200,163,182,...)` yang berubah mengikuti hover/focus
/// (`rgba(168,85,247,...)` saat fokus), placeholder `gray-100/40`, dan glass
/// frosted ([CsFrost] backdrop blur 6.1px). Variant lain: `glass` (frosted
/// putih) dan `csGlassInput` (pola `csglass-input`).
class CxTextField extends StatefulWidget {
  const CxTextField({
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
    this.variant = CxTextFieldVariant.csInput,
  });

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
  final CxTextFieldVariant variant;

  @override
  State<CxTextField> createState() => _CxTextFieldState();
}

class _CxTextFieldState extends State<CxTextField> {
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
    CxTextFieldVariant.glass => DompetBrand.radiusSm,
    CxTextFieldVariant.csGlassInput => DompetBrand.radiusSm,
    CxTextFieldVariant.csInput => DompetBrand.radius,
  };

  /// Padding per variant — `csinput` memakai `px-3 py-2` (12/8),
  /// `csglass-input` & `glass` memakai `p-4 py-2` (16/8).
  EdgeInsetsGeometryMix get _padding => switch (widget.variant) {
    CxTextFieldVariant.glass || CxTextFieldVariant.csGlassInput =>
      EdgeInsetsGeometryMix.symmetric(horizontal: 16, vertical: 8),
    CxTextFieldVariant.csInput => EdgeInsetsGeometryMix.symmetric(
      horizontal: 12,
      vertical: 8,
    ),
  };

  /// Fill per state — `csinput` hover/focus memakai
  /// `rgba(200,163,182,0.14)` (`csFillHover`).
  Color get _fillColor {
    final fill = switch (widget.variant) {
      CxTextFieldVariant.glass => DompetBrand.glassFill,
      CxTextFieldVariant.csGlassInput => DompetBrand.csFill,
      CxTextFieldVariant.csInput => DompetBrand.csFill,
    };
    if (widget.variant == CxTextFieldVariant.csInput &&
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
        CxTextFieldVariant.glass => (
          normal: DompetBrand.glassBorder,
          hover: const Color(0x29FFFFFF),
          focus: const Color(0x3DFFFFFF),
          ring: const Color(0x1AFFFFFF),
        ),
        CxTextFieldVariant.csGlassInput => (
          normal: DompetBrand.csBorder,
          hover: DompetBrand.csBorderHover,
          focus: DompetBrand.csBorderHover,
          ring: DompetBrand.csBorderHover,
        ),
        CxTextFieldVariant.csInput => (
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
    CxTextFieldVariant.glass => Colors.white38,
    CxTextFieldVariant.csGlassInput => const Color(
      0xFF374151,
    ), // placeholder-gray-700
    CxTextFieldVariant.csInput => const Color(
      0x66F3F4F6,
    ), // dark:placeholder:text-gray-100/40
  };

  TextFieldStyler get _style {
    final decoration =
        switch (widget.variant) {
          CxTextFieldVariant.glass => DompetBrand.glassDecoration(
            radius: DompetBrand.radiusSm,
          ),
          CxTextFieldVariant.csGlassInput => DompetBrand.csGlassInput(
            radius: DompetBrand.radiusSm,
          ),
          CxTextFieldVariant.csInput => DompetBrand.csInput(
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
        .decoration(decoration);
  }

  /// Gaya label kustom — mengikuti default Remix (`13`/`Colors.white70`),
  /// lalu menerapkan [CxTextField.labelStyle] di atasnya.
  TextStyle get _labelTextStyle {
    final base = const TextStyle(fontSize: 13, color: Colors.white70);
    final labelStyle = widget.labelStyle;
    return labelStyle == null ? base : base.merge(labelStyle);
  }

  @override
  Widget build(BuildContext context) {
    final field = SizedBox(
      height: 50,
      child: RemixTextField(
        controller: widget.controller,
        focusNode: _focusNode,
        hintText: widget.hintText,
        semanticLabel: widget.label,
        leading: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: widget.leading,
        ),
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
      ),
    );

    final frosted = CsFrost(
      radius: _radius,
      child: MouseRegion(
        cursor: widget.enabled
            ? SystemMouseCursors.text
            : SystemMouseCursors.basic,
        onEnter: widget.enabled ? (_) => setState(() => _hovered = true) : null,
        onExit: widget.enabled ? (_) => setState(() => _hovered = false) : null,
        child: field,
      ),
    );

    Widget content = frosted;
    final label = widget.label;
    if (label != null) {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: widget.enabled ? () => _focusNode.requestFocus() : null,
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(label, style: _labelTextStyle),
            ),
          ),
          const SizedBox(height: 8),
          frosted,
        ],
      );
    }

    return content;
  }
}
