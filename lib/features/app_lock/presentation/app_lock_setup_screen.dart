import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';

import '../../../core/theme/cs_dialog.dart';
import '../../../core/theme/dompet_brand.dart';
import '../../../core/theme/widgets/dompet_card.dart';
import '../application/app_lock_controller.dart';
import '../models/lock_method.dart';
import 'widgets/pattern_input.dart';
import 'widgets/pin_input.dart';

/// Layar pengaturan app lock — pilih kredensial (PIN/pola) & set biometrik.
class AppLockSetupScreen extends ConsumerStatefulWidget {
  const AppLockSetupScreen({super.key});

  @override
  ConsumerState<AppLockSetupScreen> createState() =>
      _AppLockSetupScreenState();
}

class _AppLockSetupScreenState extends ConsumerState<AppLockSetupScreen> {
  LockCredential? _selectedCredential;
  bool _isConfirming = false;
  String? _firstInput;
  String? _errorText;

  /// Pilihan biometrik saat setup kredensial baru/ubah.
  bool _biometricOption = false;
  bool _biometricAvailable = false;

  // PIN
  final _pinKey = GlobalKey<PinInputState>();
  // Pattern
  final _patternKey = GlobalKey<PatternInputState>();
  final LocalAuthentication _auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
  }

  Future<void> _checkBiometricAvailability() async {
    try {
      final available = await _auth.canCheckBiometrics;
      if (mounted && available) {
        setState(() => _biometricAvailable = true);
      }
    } on PlatformException {
      // Perangkat tanpa biometrik -> toggle disembunyikan.
    }
  }

  @override
  Widget build(BuildContext context) {
    final lockAsync = ref.watch(appLockControllerProvider);
    final lockState = lockAsync.value;
    final isAlreadySetup = lockState?.isEnabled == true;

    // Kredensial yang sedang dikonfigurasi: pilihan user, atau yang aktif.
    final credential =
        _selectedCredential ?? (isAlreadySetup ? lockState?.credential : null);
    final editing = _selectedCredential != null;

    return Scaffold(
      body: Container(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              _Header(
                title: 'App Lock',
                onBack: () => context.pop(),
                actions: [
                  if (isAlreadySetup)
                    TextButton(
                      onPressed: _confirmDisable,
                      child: const Text(
                        'Nonaktif',
                        style: TextStyle(
                          color: Color(0xFFEF4444),
                          fontSize: 13,
                        ),
                      ),
                    ),
                ],
              ),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Status indicator
                      if (isAlreadySetup) _buildStatusCard(lockState!),
                      const SizedBox(height: 16),
                      // Credential selection
                      _buildMethodSelector(credential),
                      if (credential != null) ...[
                        const SizedBox(height: 16),
                        // Input area
                        _buildInputArea(credential),
                        if (_biometricAvailable) ...[
                          const SizedBox(height: 8),
                          _buildBiometricToggle(
                            editing: editing,
                            biometricOn:
                                editing
                                    ? _biometricOption
                                    : (lockState?.biometricEnabled ?? false),
                          ),
                        ],
                        const SizedBox(height: 16),
                        // Error text
                        if (_errorText != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              _errorText!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFFEF4444),
                              ),
                            ),
                          ),
                        // Confirm button
                        _buildConfirmButton(),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: DompetBrand.purple,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(48),
      ),
      onPressed: () {
        // Reset alur input kredensial (fallback manual).
        if (_isConfirming) {
          setState(() {
            _isConfirming = false;
            _firstInput = null;
            _errorText = null;
          });
          if (_selectedCredential == LockCredential.pin) {
            _pinKey.currentState?.clear();
          } else {
            _patternKey.currentState?.clear();
          }
        }
      },
      child: Text(_isConfirming ? 'Mulai Ulang' : 'Lanjut'),
    );
  }

  Widget _buildStatusCard(AppLockState state) {
    final biometricText = state.biometricEnabled ? ' + Biometrik' : '';
    return DompetCard(
      variant: DompetCardVariant.csGlassSurface,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.shield_outlined, size: 20, color: Colors.green),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'App Lock Aktif',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Kredensial: ${state.credential.label}$biometricText',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMethodSelector(LockCredential? credential) {
    final methods = [
      (LockCredential.pin, Icons.pin_outlined, 'PIN', '6 digit numerik'),
      (
        LockCredential.pattern,
        Icons.grid_3x3_outlined,
        'Pola',
        'Gambarkan pola 3x3',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pilih Kredensial',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 8),
        ...methods.map((m) {
          final isSelected = credential == m.$1;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: DompetCard(
              variant: DompetCardVariant.csGlassSurface,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              onTap: _isConfirming
                  ? null
                  : () => setState(() {
                      _selectedCredential = m.$1;
                      _biometricOption =
                          ref
                              .read(appLockControllerProvider)
                              .value
                              ?.biometricEnabled ??
                          false;
                      _errorText = null;
                      _firstInput = null;
                      _isConfirming = false;
                    }),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? DompetBrand.purple.withValues(alpha: 0.2)
                          : DompetBrand.csFill,
                      border: Border.all(
                        color: isSelected
                            ? DompetBrand.purple
                            : DompetBrand.csBorder,
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      m.$2,
                      size: 20,
                      color: isSelected ? DompetBrand.purple : Colors.white54,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          m.$3,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isSelected ? Colors.white : Colors.white70,
                          ),
                        ),
                        Text(
                          m.$4,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white38,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    const Icon(
                      Icons.check_circle,
                      size: 20,
                      color: DompetBrand.purple,
                    ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildInputArea(LockCredential credential) {
    return switch (credential) {
      LockCredential.pin => _buildPinInput(),
      LockCredential.pattern => _buildPatternInput(),
    };
  }

  Widget _buildPinInput() {
    return Column(
      children: [
        Text(
          _isConfirming ? 'Konfirmasi PIN' : 'Masukkan PIN',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 12),
        PinInput(
          key: _pinKey,
          onCompleted: (pin) => _handlePinCompleted(pin),
        ),
      ],
    );
  }

  Widget _buildPatternInput() {
    return Column(
      children: [
        Text(
          _isConfirming ? 'Konfirmasi Pola' : 'Gambarkan Pola',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 12),
        PatternInput(
          key: _patternKey,
          onCompleted: (pattern) => _handlePatternCompleted(pattern),
        ),
      ],
    );
  }

  /// Toggle biometrik sebagai opsi tambahan di atas kredensial.
  ///
  /// Saat sedang edit kredensial nilai disimpan ke [_biometricOption] dan
  /// dipersist saat konfirmasi; saat tidak edit (app lock sudah aktif) nilai
  /// langsung dipersist via controller.
  Widget _buildBiometricToggle({
    required bool editing,
    required bool biometricOn,
  }) {
    return DompetCard(
      variant: DompetCardVariant.csGlassSurface,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.fingerprint, size: 20, color: DompetBrand.purple),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Biometrik',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                Text(
                  'Buka cepat dengan sidik jari / Face ID',
                  style: const TextStyle(fontSize: 12, color: Colors.white38),
                ),
              ],
            ),
          ),
          Switch(
            value: biometricOn,
            onChanged: _isConfirming
                ? null
                : (value) {
                    if (editing) {
                      setState(() => _biometricOption = value);
                    } else {
                      final notifier = ref.read(
                        appLockControllerProvider.notifier,
                      );
                      if (value) {
                        notifier.enableBiometric();
                      } else {
                        notifier.disableBiometric();
                      }
                    }
                  },
          ),
        ],
      ),
    );
  }

  /// Nilai biometrik yang dipakai saat konfirmasi setup.
  ///
  /// Saat sedang edit kredensial → pilihan user di [_biometricOption].
  /// Saat tidak edit (ubah kredensial yang sudah ada) → pertahankan nilai
  /// biometrik yang sedang aktif.
  bool _effectiveBiometricOption() {
    if (_selectedCredential == null) {
      return ref
              .read(appLockControllerProvider)
              .value
              ?.biometricEnabled ??
          false;
    }
    return _biometricOption;
  }

  void _handlePinCompleted(String pin) {
    if (!_isConfirming) {
      setState(() {
        _firstInput = pin;
        _isConfirming = true;
        _errorText = null;
      });
      _pinKey.currentState?.clear();
    } else {
      if (pin == _firstInput) {
        ref
            .read(appLockControllerProvider.notifier)
            .setupPin(pin, biometricEnabled: _effectiveBiometricOption());
        _showSuccessAndPop();
      } else {
        setState(() {
          _errorText = 'PIN tidak cocok. Mulai dari awal.';
          _isConfirming = false;
          _firstInput = null;
        });
        _pinKey.currentState?.clear();
      }
    }
  }

  void _handlePatternCompleted(List<int> pattern) {
    if (!_isConfirming) {
      setState(() {
        _firstInput = pattern.join(',');
        _isConfirming = true;
        _errorText = null;
      });
      _patternKey.currentState?.clear();
    } else {
      final confirmStr = pattern.join(',');
      if (confirmStr == _firstInput) {
        ref
            .read(appLockControllerProvider.notifier)
            .setupPattern(pattern, biometricEnabled: _biometricOption);
        _showSuccessAndPop();
      } else {
        setState(() {
          _errorText = 'Pola tidak cocok. Mulai dari awal.';
          _isConfirming = false;
          _firstInput = null;
        });
        _patternKey.currentState?.clear();
      }
    }
  }

  void _showSuccessAndPop() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('App Lock berhasil diaktifkan')),
      );
    context.pop();
  }

  Future<void> _confirmDisable() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => CsDialog(
        title: 'Nonaktifkan App Lock?',
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(false),
            child: const Text('BATAL'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(dialogCtx).pop(true),
            child: const Text('NONAKTIFKAN'),
          ),
        ],
        child: const Text(
          'Aplikasi tidak akan terkunci lagi. Lanjutkan?',
        ),
      ),
    );
    if (confirmed != true || !mounted) return;

    await ref.read(appLockControllerProvider.notifier).disableLock();
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('App Lock dinonaktifkan')),
      );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.title,
    required this.onBack,
    this.actions = const [],
  });

  final String title;
  final VoidCallback onBack;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_outlined),
            color: Colors.white,
            tooltip: 'back',
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          ...actions,
        ],
      ),
    );
  }
}