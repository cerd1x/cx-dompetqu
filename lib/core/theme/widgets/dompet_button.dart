import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

import 'package:dompetqu/core/theme/cs_mix.dart';
import 'package:dompetqu/core/theme/dompet_brand.dart';

enum DompetButtonVariant { primary, outline, text }

/// Tombol brand DompetQu — padanan `btn` daisyUI + gradient web,
/// dengan konsep frosted glass: backdrop blur, glass edge, dan soft glow.
class DompetButton extends StatelessWidget {
  const DompetButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = DompetButtonVariant.primary,
    this.loading = false,
    this.enabled = true,
    this.leadingIcon,
    this.expand = false,
    this.height = 48,
  });

  final String label;
  final VoidCallback? onPressed;
  final DompetButtonVariant variant;
  final bool loading;
  final bool enabled;
  final IconData? leadingIcon;
  final bool expand;
  final double height;

  bool get _dimmed => !enabled && !loading;

  // Glass edge highlight (border atas/tepi kaca).
  static const _glassEdge = Color(0x4DFFFFFF); // white 30%
  static const _glassEdgeDim = Color(0x1AFFFFFF); // white 10%

  /// Gradient oranye → pink; konstan untuk semua state (idle/hover/pressed).
  static BoxDecorationMix _gradient({required double radius}) =>
      BoxDecorationMix(
        gradient: LinearGradientMix.value(
          const LinearGradient(
            colors: [Color(0xFFF97316), Color(0xFFEC4899)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        borderRadius: BorderRadiusGeometryMix.circular(radius),
        border: BorderMix.all(BorderSideMix(color: _glassEdge, width: 1)),
      );

  /// Panel kaca transparan dengan border khas CS glass.
  static BoxDecorationMix _glass({
    required Color fill,
    required Color border,
    required double radius,
  }) => BoxDecorationMix(
    color: fill,
    borderRadius: BorderRadiusGeometryMix.circular(radius),
    border: BorderMix.all(BorderSideMix(color: border, width: 1)),
  );

  ButtonStyler get _style {
    final base = ButtonStyler()
        .height(height)
        .labelFontWeight(FontWeight.w600)
        .labelFontSize(15)
        .iconColor(Colors.white)
        .spinnerIndicatorColor(Colors.white)
        .padding(EdgeInsetsGeometryMix.symmetric(horizontal: 12));

    return switch (variant) {
      DompetButtonVariant.primary =>
        _dimmed
            ? base
                  .decoration(
                    _glass(
                      fill: const Color(0x0AFFFFFF),
                      border: _glassEdgeDim,
                      radius: DompetBrand.radius,
                    ),
                  )
                  .labelColor(Colors.white38)
            : base.decoration(_gradient(radius: DompetBrand.radius)),
      DompetButtonVariant.outline =>
        _dimmed
            ? base
                  .decoration(
                    _glass(
                      fill: const Color(0x0AFFFFFF),
                      border: _glassEdgeDim,
                      radius: DompetBrand.radiusSm,
                    ),
                  )
                  .labelColor(Colors.white38)
            : base
                  .decoration(
                    _glass(
                      fill: DompetBrand.csFill,
                      border: DompetBrand.csBorder,
                      radius: DompetBrand.radiusSm,
                    ),
                  )
                  .onHovered(
                    ButtonStyler().decoration(
                      _glass(
                        fill: DompetBrand.csFillHover,
                        border: DompetBrand.csBorderHover,
                        radius: DompetBrand.radiusSm,
                      ),
                    ),
                  )
                  .onPressed(
                    ButtonStyler().decoration(
                      _glass(
                        fill: DompetBrand.csFill,
                        border: DompetBrand.csFocusBorder,
                        radius: DompetBrand.radiusSm,
                      ),
                    ),
                  ),
      DompetButtonVariant.text =>
        _dimmed
            ? base.color(Colors.transparent).labelColor(Colors.white38)
            : base
                  .color(Colors.transparent)
                  .labelColor(DompetBrand.purple)
                  .onHovered(ButtonStyler().labelColor(const Color(0xFFA78BFA)))
                  .onPressed(
                    ButtonStyler().labelColor(const Color(0xFF7C3AED)),
                  ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final button = SizedBox(
      width: expand ? double.infinity : null,
      child: RemixButton(
        label: label,
        leadingIcon: leadingIcon,
        onPressed: enabled && !loading ? onPressed : null,
        loading: loading,
        style: _style,
      ),
    );

    if (variant == DompetButtonVariant.text) return button;

    // Soft glow di luar area blur agar tidak ikut ter-clip.
    final List<BoxShadow>? glow = _dimmed
        ? null
        : switch (variant) {
            DompetButtonVariant.primary => [
              BoxShadow(
                color: DompetBrand.gold.withValues(alpha: 0.4),
                blurRadius: 28,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: DompetBrand.purple.withValues(alpha: 0.18),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
            DompetButtonVariant.outline => [
              BoxShadow(
                color: DompetBrand.csShadow,
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
            DompetButtonVariant.text => null,
          };

    return CsFrost(
      radius: variant == DompetButtonVariant.primary
          ? DompetBrand.radius
          : DompetBrand.radiusSm,
      shadow: glow,
      child: button,
    );
  }
}
