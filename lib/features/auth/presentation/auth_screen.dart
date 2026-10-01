import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remix/remix.dart';

import '../../../core/theme/dompet_brand.dart';
import '../../../core/theme/widgets/dompet_button.dart';
import '../../../core/theme/widgets/dompet_gradient_background.dart';
import '../../../core/theme/widgets/dompet_text_field.dart';
import '../application/session_controller.dart';
import '../data/passkey_service.dart';

enum _AuthMode { signIn, signUp }

/// Halaman auth — padanan `/auth` di web (sign in / sign up + passkey).
class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  _AuthMode _mode = _AuthMode.signIn;

  final _nameCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  String? _nameError;
  String? _usernameError;
  String? _passwordError;

  bool _passkeySupported = false;

  @override
  void initState() {
    super.initState();
    _checkPasskeySupport();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _checkPasskeySupport() async {
    final supported = await ref.read(passkeyServiceProvider).isSupported;
    if (mounted) setState(() => _passkeySupported = supported);
  }

  bool _validate() {
    final name = _nameCtrl.text.trim();
    final username = _usernameCtrl.text.trim();
    final password = _passwordCtrl.text;

    setState(() {
      _nameError = _mode == _AuthMode.signUp && name.isEmpty
          ? 'Nama wajib diisi'
          : null;
      _usernameError = username.isEmpty ? 'Username wajib diisi' : null;
      _passwordError = password.length < 6 ? 'Minimal 6 karakter' : null;
    });
    return _nameError == null &&
        _usernameError == null &&
        _passwordError == null;
  }

  Future<void> _submit() async {
    if (!_validate()) return;
    final controller = ref.read(sessionControllerProvider.notifier);
    final username = _usernameCtrl.text.trim();
    final password = _passwordCtrl.text;

    final ok = switch (_mode) {
      _AuthMode.signIn => await controller.signIn(
        username: username,
        password: password,
      ),
      _AuthMode.signUp => await controller.signUp(
        name: _nameCtrl.text.trim(),
        username: username,
        password: password,
      ),
    };
    if (!ok && mounted) setState(() {});
  }

  Future<void> _passkeySignIn() async {
    final ok = await ref
        .read(sessionControllerProvider.notifier)
        .signInWithPasskey();
    if (!ok && mounted) setState(() {});
  }

  Widget _fieldError(String? message) {
    if (message == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 4),
      child: Text(
        message,
        style: const TextStyle(color: DompetBrand.pink, fontSize: 12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sessionControllerProvider);
    return Scaffold(
      body: DompetGradientBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // logo section
                    Center(
                      child: Box(
                        style: BoxStyler()
                            .size(72, 72)
                            .alignment(.center)
                            .gradient(DompetBrand.gradient)
                            .borderRadius(.circular(22))
                            .boxShadows([
                              BoxShadowMix(
                                color: DompetBrand.purple.withValues(
                                  alpha: 0.45,
                                ),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ]),
                        child: const Icon(
                          Icons.account_balance_wallet_rounded,
                          size: 38,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // title section
                    Text(
                      'DompetQu',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    // subtitle section
                    Text(
                      _mode == _AuthMode.signIn
                          ? 'Selamat datang kembali'
                          : 'Buat akun baru',
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.white60),
                    ),
                    const SizedBox(height: 28),
                    // error banner section
                    if (state.error != null) ...[
                      _ErrorBanner(message: state.error!),
                      const SizedBox(height: 12),
                    ],
                    // name field section
                    if (_mode == _AuthMode.signUp) ...[
                      DompetTextField(
                        controller: _nameCtrl,
                        label: 'Nama',
                        leading: const Icon(
                          Icons.person_outline,
                          color: Colors.white54,
                        ),
                        textInputAction: TextInputAction.next,
                        error: _nameError != null,
                        onChanged: (_) => setState(() => _nameError = null),
                      ),
                      _fieldError(_nameError),
                      const SizedBox(height: 14),
                    ],
                    // username field section
                    DompetTextField(
                      controller: _usernameCtrl,
                      label: 'Username',
                      leading: const Icon(
                        Icons.badge_outlined,
                        color: Colors.white54,
                      ),
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                      error: _usernameError != null,
                      onChanged: (_) => setState(() => _usernameError = null),
                    ),
                    _fieldError(_usernameError),
                    const SizedBox(height: 14),
                    // password field section
                    DompetTextField.password(
                      controller: _passwordCtrl,
                      label: 'Password',
                      error: _passwordError != null,
                      onChanged: (_) => setState(() => _passwordError = null),
                      onSubmitted: (_) => _submit(),
                    ),
                    _fieldError(_passwordError),
                    const SizedBox(height: 22),
                    // submit section
                    DompetButton(
                      label: _mode == _AuthMode.signIn ? 'Masuk' : 'Daftar',
                      onPressed: state.busy ? null : _submit,
                      loading: state.busy,
                      expand: true,
                    ),
                    // passkey section
                    if (_passkeySupported) ...[
                      const SizedBox(height: 12),
                      DompetButton(
                        label: 'Sign in dengan Passkey',
                        variant: DompetButtonVariant.outline,
                        leadingIcon: Icons.fingerprint,
                        onPressed: state.busy ? null : _passkeySignIn,
                        expand: true,
                      ),
                    ],
                    const SizedBox(height: 4),
                    // toggle mode section
                    DompetButton(
                      label: _mode == _AuthMode.signIn
                          ? 'Belum punya akun? Daftar'
                          : 'Sudah punya akun? Masuk',
                      variant: DompetButtonVariant.text,
                      onPressed: () => setState(() {
                        _mode = _mode == _AuthMode.signIn
                            ? _AuthMode.signUp
                            : _AuthMode.signIn;
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFDB2777).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: DompetBrand.pink.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, size: 20, color: DompetBrand.pink),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
