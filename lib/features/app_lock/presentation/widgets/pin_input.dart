import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mix/mix.dart';

import '../../../../core/theme/dompet_brand.dart';

/// Input numerik 6 digit untuk PIN lock screen.
class PinInput extends StatefulWidget {
  const PinInput({super.key, this.length = 6, this.onCompleted});

  final int length;
  final ValueChanged<String>? onCompleted;

  @override
  State<PinInput> createState() => PinInputState();
}

class PinInputState extends State<PinInput> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _focusNodes) {
      n.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.length, (i) {
        return Box(
          style: BoxStyler()
              .margin(
                EdgeInsetsGeometryMix.value(
                  const EdgeInsets.symmetric(horizontal: 5),
                ),
              )
              .constraints(
                BoxConstraintsMix.value(
                  (const BoxConstraints()).tighten(width: 44, height: 52),
                ),
              ),
          child: TextField(
            controller: _controllers[i],
            focusNode: _focusNodes[i],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            obscureText: true,
            obscuringCharacter: '●',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: DompetBrand.csFill,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(DompetBrand.radiusSm),
                borderSide: const BorderSide(
                  color: DompetBrand.csBorder,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(DompetBrand.radiusSm),
                borderSide: const BorderSide(
                  color: DompetBrand.purple,
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(DompetBrand.radiusSm),
                borderSide: const BorderSide(
                  color: Color(0xFFEF4444),
                  width: 1,
                ),
              ),
            ),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) {
              if (value.isNotEmpty && i < widget.length - 1) {
                _focusNodes[i + 1].requestFocus();
              }
              if (value.isEmpty && i > 0) {
                _focusNodes[i - 1].requestFocus();
              }
              _collectPin();
            },
            onEditingComplete: () => _handleBackspace(i),
          ),
        );
      }),
    );
  }

  void _handleBackspace(int index) {
    if ((_controllers[index].text.isEmpty ||
            _controllers[index].selection.isValid) &&
        index > 0 &&
        _controllers[index].text.isEmpty) {
      _controllers[index - 1].clear();
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _collectPin() {
    final buffer = StringBuffer();
    for (final c in _controllers) {
      buffer.write(c.text);
    }
    final pin = buffer.toString();
    if (pin.length == widget.length) {
      widget.onCompleted?.call(pin);
    }
  }

  void clear() {
    for (final c in _controllers) {
      c.clear();
    }
    _focusNodes[0].requestFocus();
  }
}
