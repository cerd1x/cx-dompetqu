import 'package:flutter/material.dart';

import 'package:dompetqu/core/theme/widgets/cx_text_field.dart';
import 'package:dompetqu/core/theme/widgets/cx_icons.dart';

/// Input password brand — padanan `CxTextField.password` web.
///
/// Menampilkan ikon gembok di kiri dan toggle visibilitas di kanan.
class CxTextFieldPassword extends StatefulWidget {
  const CxTextFieldPassword({
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
    this.variant = CxTextFieldVariant.csInput,
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
  final CxTextFieldVariant variant;

  @override
  State<CxTextFieldPassword> createState() => _CxTextFieldPasswordState();
}

class _CxTextFieldPasswordState extends State<CxTextFieldPassword> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return CxTextField(
      controller: widget.controller,
      hintText: widget.hintText,
      label: widget.label,
      labelStyle: widget.labelStyle,
      leading: const Icon(CxIcons.lockOutline, color: Colors.white54),
      trailing: IconButton(
        tooltip: _obscure ? 'Lihat password' : 'Sembunyikan password',
        icon: Icon(
          _obscure ? CxIcons.visibility : CxIcons.visibilityOff,
          color: Colors.white54,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
        constraints: const BoxConstraints(minHeight: 50),
        onPressed: () => setState(() => _obscure = !_obscure),
      ),
      obscureText: _obscure,
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
