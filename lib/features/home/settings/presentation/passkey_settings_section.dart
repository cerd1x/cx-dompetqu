import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../auth/data/auth_remote_source.dart';
import '../../../auth/data/passkey_service.dart';
import '../../../auth/models/passkey.dart';
import '../../../../core/theme/dompet_brand.dart';

/// Bagian kelola passkey — padanan `PasskeySettings.svelte` di web.
class PasskeySettingsSection extends ConsumerStatefulWidget {
  const PasskeySettingsSection({super.key});

  @override
  ConsumerState<PasskeySettingsSection> createState() =>
      _PasskeySettingsSectionState();
}

class _PasskeySettingsSectionState
    extends ConsumerState<PasskeySettingsSection> {
  PasskeyService get _service => ref.read(passkeyServiceProvider);

  bool _available = false;
  List<PasskeyCredential> _passkeys = const [];
  bool _loading = true;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final available = await _service.isSupported;
      final list = available
          ? await _service.passkeys()
          : <PasskeyCredential>[];
      if (!mounted) return;
      setState(() {
        _available = available;
        _passkeys = list;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _available = false;
        _loading = false;
      });
    }
  }

  Future<void> _onAdd() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await _service.registerPasskey(deviceName: defaultTargetPlatform.name);
      _showSnack('Passkey berhasil ditambahkan');
      await _load();
    } catch (e) {
      _showSnack(e is AuthException ? e.message : 'Gagal menambahkan passkey');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _onDelete(PasskeyCredential passkey) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final ok = await _service.deletePasskey(passkey.id);
      _showSnack(ok ? 'Passkey dihapus' : 'Gagal menghapus passkey');
      if (ok) await _load();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  String _formatDate(DateTime? value) {
    if (value == null) return '-';
    return DateFormat('d MMM y', 'id_ID').format(value);
  }

  @override
  Widget build(BuildContext context) {
    final textSm = Theme.of(context).textTheme.bodyMedium;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // header row section
        Row(
          children: [
            Icon(Icons.fingerprint, size: 20, color: DompetBrand.primary),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Passkey (Biometrik)',
                style: TextStyle(fontSize: 14),
              ),
            ),
            // add button section
            if (_available)
              _OutlinedButton(
                label: _busy ? '…' : '+ Tambah',
                onPressed: _busy ? null : _onAdd,
              ),
          ],
        ),
        const SizedBox(height: 8),
        // status section
        if (_loading)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'Memuat…',
              style: TextStyle(fontSize: 12, color: Colors.white54),
            ),
          )
        else if (!_available)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'Passkey tidak didukung di perangkat ini.',
              style: TextStyle(fontSize: 12, color: Colors.white54),
            ),
          )
        else ...[
          // availability badge section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                const Icon(
                  Icons.fingerprint,
                  size: 12,
                  color: Color(0xFF4ADE80),
                ),
                const SizedBox(width: 4),
                Text(
                  'Biometrik tersedia',
                  style: TextStyle(
                    fontSize: 12,
                    color: const Color(0xFF4ADE80),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // passkey list section
          if (_passkeys.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Belum ada passkey terdaftar.',
                style: TextStyle(fontSize: 12, color: Colors.white54),
              ),
            )
          else
            for (final passkey in _passkeys)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: Row(
                  children: [
                    // passkey info section
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            passkey.deviceName ?? 'Perangkat',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textSm,
                          ),
                          Text(
                            'Ditambahkan ${_formatDate(passkey.createdAt)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // delete button section
                    TextButton(
                      onPressed: _busy ? null : () => _onDelete(passkey),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFFF87171),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        minimumSize: const Size(0, 32),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Hapus',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
        ],
      ],
    );
  }
}

class _OutlinedButton extends StatelessWidget {
  const _OutlinedButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: BorderSide(color: DompetBrand.csBorder, width: 1),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        minimumSize: const Size(0, 28),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
