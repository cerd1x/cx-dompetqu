import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import '../../../../core/theme/dompet_brand.dart';

/// Tombol autentikasi biometrik (fingerprint / face).
class BiometricButton extends StatefulWidget {
  const BiometricButton({super.key, this.onAuthenticated});

  final VoidCallback? onAuthenticated;

  @override
  State<BiometricButton> createState() => _BiometricButtonState();
}

class _BiometricButtonState extends State<BiometricButton> {
  final LocalAuthentication _auth = LocalAuthentication();
  bool _isAvailable = false;
  List<BiometricType> _availableTypes = [];

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    try {
      final available = await _auth.canCheckBiometrics;
      final types = await _auth.getAvailableBiometrics();
      if (mounted) {
        setState(() {
          _isAvailable = available;
          _availableTypes = types;
        });
      }
    } on PlatformException {
      if (mounted) setState(() => _isAvailable = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAvailable) return const SizedBox.shrink();

    final icon = _availableTypes.contains(BiometricType.face)
        ? Icons.face_outlined
        : Icons.fingerprint;

    final label = _availableTypes.contains(BiometricType.face)
        ? 'Face ID'
        : 'Fingerprint';

    return GestureDetector(
      onTap: () async {
        try {
          final ok = await _auth.authenticate(
            localizedReason: 'Autentikasi untuk membuka aplikasi',
            persistAcrossBackgrounding: true,
            biometricOnly: true,
          );
          if (ok) widget.onAuthenticated?.call();
        } on PlatformException {
          // Biometric auth failed silently
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: DompetBrand.csFill,
              border: Border.all(color: DompetBrand.csBorder, width: 1),
            ),
            child: Icon(icon, size: 32, color: DompetBrand.purple),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white54,
            ),
          ),
        ],
      ),
    );
  }
}
