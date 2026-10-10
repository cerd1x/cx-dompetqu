import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mix/mix.dart';

import '../../core/theme/widgets/dompet_button.dart';
import '../../core/theme/widgets/dompet_card.dart';
import '../../core/theme/widgets/dompet_combobox.dart';
import '../../core/theme/widgets/load_view_animating_progress_ripple.dart';
import '../../core/theme/widgets/scroll_refresh_wrapper.dart';
import 'application/killswitch_controller.dart';
import 'data/graphql_operations.dart';
import 'data/killswitch_remote_source.dart';

/// Layar kontrol kill switch — mematikan / menghidupkan root operation GraphQL
/// tanpa deploy (lihat `domain/killswitch` di cx-services).
///
/// Diakses lewat route `/admin/killswitch`. Memakai endpoint REST
/// `{baseUrl}/admin/killswitch` dengan header `x-admin-token`.
///
/// Catatan dari backend: perubahan switch terlihat di isolate lain paling lama
/// ~5 detik (cache TTL per-isolate).
class KillswitchControllScreen extends ConsumerStatefulWidget {
  const KillswitchControllScreen({super.key});

  @override
  ConsumerState<KillswitchControllScreen> createState() =>
      _KillswitchControllScreenState();
}

class _KillswitchControllScreenState
    extends ConsumerState<KillswitchControllScreen> {
  final _operationCtrl = TextEditingController();
  final _reasonCtrl = TextEditingController();
  final _tokenCtrl = TextEditingController();

  @override
  void dispose() {
    _operationCtrl.dispose();
    _reasonCtrl.dispose();
    _tokenCtrl.dispose();
    super.dispose();
  }

  KillswitchController get _controller =>
      ref.read(killswitchControllerProvider.notifier);

  Future<void> _saveToken() async {
    final value = _tokenCtrl.text.trim();
    if (value.isEmpty) {
      _snack('Token admin tidak boleh kosong.', false);
      return;
    }
    final tokenNotifier = ref.read(killswitchAdminTokenProvider.notifier);
    tokenNotifier.save(value);
    await _controller.load();
    if (!mounted) return;
    _snack('Token admin disimpan.', true);
  }

  void _clearToken() {
    _tokenCtrl.clear();
    ref.read(killswitchAdminTokenProvider.notifier).clear();
    _snack('Token admin dihapus.', false);
  }

  Future<void> _disable() async {
    final operation = _operationCtrl.text.trim();
    if (!kOperationKeyPattern.hasMatch(operation)) {
      _snack(
        'Pilih operation yang valid (Query.<field> / Mutation.<field>).',
        false,
      );
      return;
    }
    final ok = await _controller.disable(operation, reason: _reasonCtrl.text);
    if (!mounted) return;
    if (ok) {
      _operationCtrl.clear();
      _reasonCtrl.clear();
    }
    _snack(
      ok
          ? 'Operation "$operation" dimatikan.'
          : 'Gagal mematikan "$operation".',
      ok,
    );
  }

  Future<void> _enable(String operation) async {
    final ok = await _controller.enable(operation);
    if (!mounted) return;
    _snack(
      ok
          ? 'Operation "$operation" dihidupkan kembali.'
          : 'Gagal menghidupkan "$operation".',
      ok,
    );
  }

  void _snack(String message, bool success) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: success
              ? const Color(0xFF1B5E20)
              : const Color(0xFF7F1D1D),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(killswitchControllerProvider);
    final token = ref.watch(killswitchAdminTokenProvider);
    final hasToken = token.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Kembali',
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/admin');
            }
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('Kill Switch'),
        actions: [
          // refresh section
          IconButton(
            tooltip: 'Muat ulang',
            onPressed: state.loading ? null : _controller.load,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: ScrollRefreshWrapper(
          onRefresh: _controller.load,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
            children: [
              // token section
              _TokenField(
                controller: _tokenCtrl,
                busy: state.mutating,
                hasToken: hasToken,
                onSave: _saveToken,
                onClear: _clearToken,
              ),
              // form section
              _DisableForm(
                operationCtrl: _operationCtrl,
                reasonCtrl: _reasonCtrl,
                busy: state.mutating,
                onSubmit: _disable,
              ),
              // error section
              if (state.error != null) ...[
                const SizedBox(height: 12),
                _ErrorBanner(message: state.error!),
              ],
              const SizedBox(height: 24),
              // list section
              _SectionLabel(
                'Operation Dimatikan'
                '${state.entries.isEmpty ? '' : ' (${state.entries.length})'}',
              ),
              const SizedBox(height: 12),
              if (state.loading && state.entries.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: LoadViewAnimatingProgressRipple(
                    label: 'Memuat kill switch...',
                  ),
                )
              else if (state.entries.isEmpty)
                const _EmptyState()
              else
                for (final entry in state.entries) ...[
                  _EntryCard(
                    entry: entry,
                    busy: state.mutating,
                    onEnable: () => _enable(entry.operation),
                  ),
                  const SizedBox(height: 10),
                ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Form input token admin (sementara dari user, in-memory).
///
/// Token dipakai sebagai header `x-admin-token` pada endpoint kontrol.
class _TokenField extends StatefulWidget {
  const _TokenField({
    required this.controller,
    required this.busy,
    required this.hasToken,
    required this.onSave,
    required this.onClear,
  });

  final TextEditingController controller;
  final bool busy;
  final bool hasToken;
  final VoidCallback onSave;
  final VoidCallback onClear;

  @override
  State<_TokenField> createState() => _TokenFieldState();
}

class _TokenFieldState extends State<_TokenField> {
  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DompetCard(
        variant: DompetCardVariant.csGlassCard,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // header section
            Row(
              children: [
                Icon(
                  widget.hasToken ? Icons.key_rounded : Icons.key_off_rounded,
                  size: 20,
                  color: widget.hasToken
                      ? const Color(0xFF34D399)
                      : const Color(0xFFFBBF24),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Token Admin',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (widget.hasToken)
                  IconButton(
                    tooltip: 'Hapus token',
                    onPressed: widget.busy ? null : widget.onClear,
                    icon: const Icon(
                      Icons.logout_rounded,
                      size: 18,
                      color: Colors.white54,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            // token input section
            TextField(
              controller: widget.controller,
              enabled: !widget.busy,
              obscureText: _obscured,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: 'Masukkan x-admin-token',
                errorText: widget.hasToken ? null : 'Token belum diset.',
                suffixIcon: IconButton(
                  onPressed: () => setState(() => _obscured = !_obscured),
                  icon: Icon(
                    _obscured
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded,
                    size: 18,
                    color: Colors.white54,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // save section
            DompetButton(
              label: 'Simpan Token',
              leadingIcon: Icons.save_rounded,
              height: 40,
              loading: widget.busy,
              onPressed: widget.busy ? null : widget.onSave,
            ),
          ],
        ),
      ),
    );
  }
}

/// Form untuk mematikan satu operation GraphQL.
///
/// Operation dipilih dari combobox (`DropdownMenu`) berisi seluruh root field
/// GraphQL (lihat [kGraphqlOperations]) dengan pencarian, bukan input bebas.
class _DisableForm extends StatelessWidget {
  const _DisableForm({
    required this.operationCtrl,
    required this.reasonCtrl,
    required this.busy,
    required this.onSubmit,
  });

  final TextEditingController operationCtrl;
  final TextEditingController reasonCtrl;
  final bool busy;
  final Future<void> Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    return DompetCard(
      variant: DompetCardVariant.csGlassCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // heading section
          const Text(
            'Matikan Operation',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          // operation combobox section
          DompetCombobox<String>(
            controller: operationCtrl,
            enabled: !busy,
            items: kGraphqlOperations,
            labelOf: (op) => op,
            label: const Text('Operation key'),
            hintText: 'Query.transactions / Mutation.createTransaction',
            helperText: '${kGraphqlOperations.length} operation',
            textStyle: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 13,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          // reason input section
          TextField(
            controller: reasonCtrl,
            enabled: !busy,
            maxLines: 2,
            style: const TextStyle(fontSize: 13, color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Contoh: incident #42',
              labelText: 'Alasan (opsional)',
            ),
          ),
          const SizedBox(height: 14),
          // submit section
          DompetButton(
            label: 'Matikan Operation',
            leadingIcon: Icons.power_settings_new_rounded,
            loading: busy,
            onPressed: onSubmit,
          ),
        ],
      ),
    );
  }
}

/// Kartu satu operation yang sedang dimatikan.
class _EntryCard extends StatelessWidget {
  const _EntryCard({
    required this.entry,
    required this.busy,
    required this.onEnable,
  });

  final KillswitchEntry entry;
  final bool busy;
  final VoidCallback onEnable;

  String _formatDate(DateTime? date) {
    if (date == null) return '—';
    return DateFormat('dd MMM yyyy · HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.error;
    return DompetCard(
      variant: DompetCardVariant.csGlassCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // header section
          Row(
            children: [
              Box(
                style: BoxStyler()
                    .constraints(
                      BoxConstraintsMix.value(
                        (const BoxConstraints()).tighten(width: 34, height: 34),
                      ),
                    )
                    .decoration(
                      DecorationMix.value(
                        BoxDecoration(
                          color: accent.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                child: Icon(Icons.block_rounded, size: 18, color: accent),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  entry.operation,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          if (entry.reason != null && entry.reason!.isNotEmpty) ...[
            const SizedBox(height: 10),
            // reason section
            Text(
              entry.reason!,
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
          const SizedBox(height: 8),
          // meta section
          Row(
            children: [
              const Icon(
                Icons.schedule_rounded,
                size: 13,
                color: Colors.white38,
              ),
              const SizedBox(width: 4),
              Text(
                _formatDate(entry.disabledAt),
                style: const TextStyle(fontSize: 11, color: Colors.white38),
              ),
              const Spacer(),
              // action section
              DompetButton(
                label: 'Aktifkan',
                variant: DompetButtonVariant.outline,
                leadingIcon: Icons.restart_alt_rounded,
                height: 38,
                onPressed: busy ? null : onEnable,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Empty state saat tidak ada operation yang dimatikan.
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return DompetCard(
      variant: DompetCardVariant.csGlassCard,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        children: const [
          Icon(Icons.verified_rounded, color: Color(0xFF34D399), size: 36),
          SizedBox(height: 12),
          Text(
            'Semua operation aktif',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Tidak ada kill switch yang sedang menyala.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.white54),
          ),
        ],
      ),
    );
  }
}

/// Banner error ringkas.
class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Box(
      style: BoxStyler()
          .padding(
            EdgeInsetsGeometryMix.value(
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          )
          .decoration(
            DecorationMix.value(
              BoxDecoration(
                color: const Color(0xFF7F1D1D).withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0x66F87171)),
              ),
            ),
          ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: Color(0xFFF87171),
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(fontSize: 12, color: Color(0xFFFCA5A5)),
            ),
          ),
        ],
      ),
    );
  }
}

/// Label seksi dengan aksen garis.
class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Box(
          style: BoxStyler()
              .constraints(
                BoxConstraintsMix.value(
                  (const BoxConstraints()).tighten(width: 4, height: 16),
                ),
              )
              .decoration(
                DecorationMix.value(
                  BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
