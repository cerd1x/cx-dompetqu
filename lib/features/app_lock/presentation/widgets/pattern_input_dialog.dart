import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/dompet_brand.dart';
import '../../application/app_lock_controller.dart';
import 'pattern_input.dart';

/// Dialog modal input pola untuk layar kunci.
///
/// Dimiliki penuh oleh route dialog-nya sendiri sehingga tidak bergantung pada
/// GlobalKey bersama di layar induk (mencegah `Duplicate GlobalKey` saat dialog
/// dibuka ulang). Reset input dilakukan lewat remount (`ValueKey` berganti).
class PatternInputDialog extends ConsumerStatefulWidget {
  const PatternInputDialog({super.key});

  @override
  ConsumerState<PatternInputDialog> createState() =>
      _PatternInputDialogState();
}

class _PatternInputDialogState extends ConsumerState<PatternInputDialog> {
  int _resetTick = 0;
  String? _errorText;

  Future<void> _onPatternCompleted(List<int> pattern) async {
    final ok = await ref
        .read(appLockControllerProvider.notifier)
        .unlockWithPattern(pattern);
    if (!mounted) return;

    if (ok) {
      Navigator.of(context).pop(true);
      return;
    }

    setState(() {
      _errorText = 'Pola salah. Coba lagi.';
      _resetTick++;
    });

    final current = ref.read(appLockControllerProvider).value;
    if (current?.isLockedOut == true) {
      // Tutup dialog agar layar lockout (countdown) tetap terlihat.
      Navigator.of(context).pop(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: DompetBrand.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DompetBrand.radius),
        side: const BorderSide(color: DompetBrand.csBorder, width: 1),
      ),
      title: const Text(
        'Gambarkan Pola',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _errorText ?? 'Hubungkan minimal 4 titik untuk membuka',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color:
                  _errorText != null
                      ? const Color(0xFFEF4444)
                      : Colors.white.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 20),
          PatternInput(
            key: ValueKey('pattern_input_$_resetTick'),
            onCompleted: _onPatternCompleted,
          ),
        ],
      ),
    );
  }
}