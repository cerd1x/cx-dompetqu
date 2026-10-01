import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/dompet_brand.dart';
import '../application/app_lock_controller.dart';
import '../models/lock_method.dart';
import 'widgets/biometric_button.dart';
import 'widgets/pattern_input_dialog.dart';
import 'widgets/pin_input.dart';

/// Layar kunci yang muncul saat aplikasi terkunci.
class AppLockScreen extends ConsumerStatefulWidget {
  const AppLockScreen({super.key});

  @override
  ConsumerState<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends ConsumerState<AppLockScreen> {
  final _pinKey = GlobalKey<PinInputState>();
  String? _errorText;
  Timer? _countdownTimer;
  bool _patternDialogVisible = false;

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lockAsync = ref.watch(appLockControllerProvider);
    final lockState = lockAsync.value;

    _schedulePatternDialogIfNeeded(lockState);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) {
            // Prevent back navigation on lock screen
          }
        },
        child: Scaffold(
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF111827),
                  Color(0x4D581C87),
                  Color(0x4D7C2D12),
                ],
              ),
            ),
            child: SafeArea(
              child: lockState == null
                  ? const Center(child: CircularProgressIndicator())
                  : _buildContent(lockState),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(AppLockState lockState) {
    if (lockState.isLockedOut) {
      return _buildLockout();
    }

    return Column(
      children: [
        const Spacer(flex: 2),
        // App icon & title
        Icon(
          Icons.lock_outline,
          size: 48,
          color: DompetBrand.purple.withValues(alpha: 0.8),
        ),
        const SizedBox(height: 12),
        Text(
          'DompetQu Terkunci',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
        const SizedBox(height: 8),
        if (_errorText != null)
          Text(
            _errorText!,
            style: const TextStyle(fontSize: 13, color: Color(0xFFEF4444)),
          )
        else
          Text(
            _getMethodHint(lockState),
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
        const Spacer(flex: 2),
        // Input section
        _buildInput(lockState),
        const Spacer(flex: 3),
        // Biometric quick-unlock option (jika aktif)
        if (lockState.biometricEnabled)
          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: BiometricButton(
              onAuthenticated: () {
                ref
                    .read(appLockControllerProvider.notifier)
                    .completeUnlock();
              },
            ),
          ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildInput(AppLockState lockState) {
    return switch (lockState.credential) {
      LockCredential.pin => PinInput(
        key: _pinKey,
        onCompleted: (pin) async {
          final ok = await ref
              .read(appLockControllerProvider.notifier)
              .unlockWithPin(pin);
          if (!ok && mounted) {
            setState(() {
              _errorText = 'PIN salah. Coba lagi.';
            });
            _pinKey.currentState?.clear();
          }
        },
      ),
      LockCredential.pattern => Center(
        child: OutlinedButton.icon(
          onPressed: _patternDialogVisible ? null : _openPatternDialog,
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: const BorderSide(color: DompetBrand.csBorder, width: 1),
          ),
          icon: const Icon(Icons.draw_outlined),
          label: const Text('Gambarkan pola'),
        ),
      ),
    };
  }

  Widget _buildLockout() {
    final lockState = ref.watch(appLockControllerProvider).value;
    final remaining = lockState?.lockoutUntil?.difference(DateTime.now());
    final minutes = remaining?.inMinutes ?? 0;
    final seconds = (remaining?.inSeconds ?? 0) % 60;
    _scheduleCountdownTicks();

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.lock_clock, size: 48, color: Color(0xFFEF4444)),
          const SizedBox(height: 16),
          const Text(
            'Terlalu banyak percobaan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coba lagi dalam $minutes:${seconds.toString().padLeft(2, '0')}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  /// Buka dialog pola otomatis saat kredensial pola & layar siap.
  void _schedulePatternDialogIfNeeded(AppLockState? state) {
    if (state == null || state.isLockedOut || _patternDialogVisible) return;
    if (state.credential != LockCredential.pattern) return;

    _patternDialogVisible = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _openPatternDialog();
    });
  }

  /// Dialog modal input pola yang self-contained (tanpa GlobalKey bersama).
  ///
  /// Dialog mengelola unlock sendiri dan menutup dirinya saat sukses atau
  /// lockout, sehingga tidak terjadi `Duplicate GlobalKey` pada pola yang
  /// dibuka ulang.
  Future<void> _openPatternDialog() async {
    _patternDialogVisible = true;
    try {
      await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (_) => const PatternInputDialog(),
      );
    } finally {
      if (mounted) {
        // Beri jarak sampai route dialog selesai keluar agar dialog baru tidak
        // bertumpuk dengan yang lama.
        await Future<void>.delayed(const Duration(milliseconds: 300));
        if (mounted) _patternDialogVisible = false;
      }
    }
  }

  /// Rebuild tiap detik selama lockout aktif agar hitung mundur tetap berjalan.
  void _scheduleCountdownTicks() {
    if (_countdownTimer != null) return;
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final current = ref.read(appLockControllerProvider).value;
      if (current == null || !current.isLockedOut) {
        _countdownTimer?.cancel();
        _countdownTimer = null;
      } else {
        setState(() {});
      }
    });
  }

  String _getMethodHint(AppLockState state) {
    final credentialHint = switch (state.credential) {
      LockCredential.pin => 'Masukkan PIN untuk membuka',
      LockCredential.pattern => 'Gambarkan pola untuk membuka',
    };
    if (!state.biometricEnabled) return credentialHint;
    return '$credentialHint, atau gunakan biometrik';
  }
}