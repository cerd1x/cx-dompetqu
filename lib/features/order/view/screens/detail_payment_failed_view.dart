import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:dompetqu/core/logger/app_logger.dart';
import 'package:dompetqu/core/logger/beta_report_remote.dart';
import 'package:dompetqu/core/theme/cs_dialog.dart';
import 'package:dompetqu/core/theme/widgets/cx_button.dart';
import 'package:dompetqu/core/theme/widgets/cx_card.dart';
import 'package:dompetqu/core/utils/formatters.dart';
import 'package:dompetqu/features/payments/domain/models/payment.dart';
import 'package:dompetqu/features/payments/view/stores/failed_payments_store.dart';
import 'package:dompetqu/features/payments/view/stores/payments_repository_provider.dart';
import 'package:dompetqu/features/payments/view/widgets/payment_widgets.dart';
import 'package:dompetqu/features/transactions/domain/models/payment_method_type.dart';

/// Layar detail satu payment gagal.
///
/// Dibuka dari baris tab Failed (`/payment-failed`). Berisi ringkasan payment,
/// analisis penyebab, serta dua aksi:
/// - **Retry** → `mutation retryPayment(paymentId)` (padanan `retryPayment` di
///   `cx-services/domain/payment/adapters/driving/graphql/payment.gql`).
/// - **Report** → kirim laporan ke `POST {baseUrl}/api/beta/report` karena
///   backend belum punya endpoint laporan khusus payment.
///
/// Penyebab kegagalan memakai `metadata.lastError` (pesan asli gateway) bila
/// tersedia. Bila tidak ada, penyebab diturunkan dari `status`, `gatewayRef`,
/// dan sisa `retryCount`. `metadata.nextRetryDelayMs` ditampilkan sebagai jeda
/// retry berikutnya (backoff `retry-policy.vo.ts`).
class DetailPaymentFailedView extends ConsumerStatefulWidget {
  const DetailPaymentFailedView({super.key, required this.payment});

  /// Payment yang dipilih dari daftar; dipakai sebagai data awal sebelum
  /// retry mengembalikan state terbaru dari backend.
  final Payment payment;

  @override
  ConsumerState<DetailPaymentFailedView> createState() =>
      _DetailPaymentFailedViewState();
}

class _DetailPaymentFailedViewState
    extends ConsumerState<DetailPaymentFailedView> {
  late Payment _payment = widget.payment;
  bool _retrying = false;
  bool _reporting = false;
  String? _reportResult;
  bool _reportFailed = false;

  AppLogger get _log => AppLogger.instance;

  // retry section
  Future<void> _retry() async {
    if (!_payment.canRetry) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => CsDialog(
        title: 'Retry payment?',
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Retry'),
          ),
        ],
        child: Text(
          'Percobaan ${_payment.retryCount + 1} dari '
          '${_payment.maxRetries} akan dikirim ulang ke gateway.',
          style: const TextStyle(height: 1.4),
        ),
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _retrying = true);
    try {
      final updated = await ref
          .read(paymentsRepositoryProvider)
          .retry(_payment.id);
      if (!mounted) return;
      // Daftar failed perlu dimuat ulang: payment bisa pindah status.
      ref.invalidate(failedPaymentsProvider);
      _log.info(
        'Retry payment ${_payment.id} → ${updated.status}',
        tag: 'PaymentsDetail',
      );
      setState(() {
        _payment = updated;
        _retrying = false;
      });
      _showSnack('Status payment sekarang ${updated.status.toUpperCase()}.');
    } catch (e) {
      _log.error(
        'Gagal retry payment ${_payment.id}',
        error: e,
        tag: 'PaymentsDetail',
      );
      if (!mounted) return;
      setState(() => _retrying = false);
      _showSnack('Retry gagal: $e', isError: true);
    }
  }

  // report section
  Future<void> _report() async {
    setState(() {
      _reporting = true;
      _reportResult = null;
    });
    try {
      await BetaReportRemote.instance.send(
        message: _reportMessage(),
        logs: _log.exportJson(),
        appVersion: '1.0.0+1',
      );
      _log.info(
        'Laporan payment ${_payment.id} terkirim.',
        tag: 'PaymentsDetail',
      );
      if (!mounted) return;
      setState(() {
        _reporting = false;
        _reportFailed = false;
        _reportResult = 'Laporan terkirim. Terima kasih!';
      });
    } on Exception catch (e) {
      _log.error(
        'Gagal mengirim laporan payment ${_payment.id}',
        error: e,
        tag: 'PaymentsDetail',
      );
      if (!mounted) return;
      setState(() {
        _reporting = false;
        _reportFailed = true;
        _reportResult = 'Gagal mengirim laporan: $e';
      });
    }
  }

  /// Ringkasan diagnosa yang dikirim ke backend — sengaja tanpa data sensitif
  /// (tidak ada nomor kartu/token; hanya id dan metadata payment).
  String _reportMessage() {
    final p = _payment;
    return [
      'Laporan payment gagal',
      'id=${p.id}',
      'invoiceId=${p.invoiceId ?? '-'}',
      'amount=${p.amount} ${p.currency}',
      'method=${p.method}',
      'status=${p.status}',
      'gatewayRef=${p.gatewayRef ?? '-'}',
      'retry=${p.retryCount}/${p.maxRetries}',
      'paymentType=${p.metadata?.paymentType ?? '-'}',
      'lastError=${p.metadata?.lastError ?? '-'}',
      'nextRetryDelayMs=${p.metadata?.nextRetryDelayMs ?? '-'}',
      'createdAt=${p.createdAt.toIso8601String()}',
      'updatedAt=${p.updatedAt?.toIso8601String() ?? '-'}',
    ].join('\n');
  }

  void _showSnack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? const Color(0xFF7F1D1D) : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = _payment;
    final analysis = _analysis;
    final triedOut = !p.canRetry;

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Payment Gagal')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          // summary section
          CxCard(
            variant: CxCardVariant.csGlassSurface,
            radius: 16,
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  size: 44,
                  color: Color(0xFFF87171),
                ),
                const SizedBox(height: 12),
                Text(
                  formatMoney(p.amount, p.currency),
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                PaymentStatusPill(status: p.status),
                const SizedBox(height: 10),
                Text(
                  p.displayName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // penyebab section
          _SectionTitle('Penyebab kegagalan'),
          CxCard(
            variant: CxCardVariant.csGlassSurface,
            radius: 16,
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  analysis.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  analysis.detail,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Colors.white70,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 10),
                for (final hint in analysis.hints)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '•  ',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: Colors.white38,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            hint,
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: Colors.white54,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // detail section
          _SectionTitle('Detail payment'),
          _InfoRow(label: 'Payment ID', value: p.id),
          if (p.invoiceId != null)
            _InfoRow(label: 'Invoice', value: p.invoiceId!),
          _InfoRow(
            label: 'Metode',
            value: PaymentMethodType.fromRaw(p.method)?.label ?? p.method,
          ),
          _InfoRow(
            label: 'Gateway ref',
            value: p.gatewayRef?.isNotEmpty == true ? p.gatewayRef! : '—',
          ),
          _InfoRow(label: 'Retry', value: '${p.retryCount} / ${p.maxRetries}'),
          if (p.metadata?.nextRetryDelayMs != null)
            _InfoRow(
              label: 'Jeda retry',
              value: _formatDelay(p.metadata!.nextRetryDelayMs!),
            ),
          _InfoRow(
            label: 'Dibuat',
            value: DateFormat('d MMM yyyy, HH:mm').format(p.createdAt),
          ),
          if (p.updatedAt != null)
            _InfoRow(
              label: 'Diperbarui',
              value: DateFormat('d MMM yyyy, HH:mm').format(p.updatedAt!),
            ),
          if (p.description != null && p.description!.isNotEmpty)
            _InfoRow(label: 'Deskripsi', value: p.description!),
          const SizedBox(height: 24),

          // action section
          Row(
            children: [
              Expanded(
                child: CxButton(
                  label: 'Report',
                  variant: CxButtonVariant.outline,
                  leadingIcon: Icons.flag_outlined,
                  loading: _reporting,
                  onPressed: _reporting ? null : _report,
                  height: 46,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CxButton(
                  label: 'Retry',
                  leadingIcon: Icons.refresh_rounded,
                  loading: _retrying,
                  enabled: !triedOut,
                  onPressed: _retrying || triedOut ? null : _retry,
                  height: 46,
                ),
              ),
            ],
          ),
          if (triedOut) ...[
            const SizedBox(height: 8),
            const Text(
              'Retry tidak tersedia: batas percobaan sudah tercapai.',
              style: TextStyle(fontSize: 11.5, color: Colors.white38),
            ),
          ],
          if (_reportResult != null) ...[
            const SizedBox(height: 10),
            Text(
              _reportResult!,
              style: TextStyle(
                fontSize: 12,
                color: _reportFailed
                    ? const Color(0xFFF87171)
                    : const Color(0xFF34D399),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Penyebab kegagalan untuk bagian "Kemungkinan penyebab".
  ///
  /// `metadata.lastError` (pesan asli gateway) diprioritaskan; bila kosong
  /// dipakai tebakan dari kondisi payment. `nextRetryDelayMs` ditambahkan
  /// sebagai hint jeda retry berikutnya di semua kasus.
  ({String title, String detail, List<String> hints}) get _analysis {
    final p = _payment;
    final lastError = p.metadata?.lastError;
    final delay = p.metadata?.nextRetryDelayMs;
    final delayHint = delay == null
        ? null
        : 'Retry berikutnya dijadwalkan setelah ${_formatDelay(delay)}.';

    if (lastError != null && lastError.isNotEmpty) {
      return (
        title: 'Pesan dari gateway',
        detail: lastError,
        hints: [
          ?delayHint,
          if (p.canRetry)
            'Sisa percobaan: ${p.maxRetries - p.retryCount} kali.'
          else
            'Batas retry tercapai — buat payment baru atau kirim Report.',
        ],
      );
    }

    final derived = _derivedAnalysis(p);
    return (
      title: derived.title,
      detail: derived.detail,
      hints: [...derived.hints, ?delayHint],
    );
  }

  /// Tebakan penyebab saat `metadata.lastError` tidak tersedia (payment lama
  /// atau gateway yang tidak mengisi pesan error).
  ({String title, String detail, List<String> hints}) _derivedAnalysis(
    Payment p,
  ) {
    if (!p.canRetry) {
      return (
        title: 'Batas retry tercapai',
        detail:
            'Payment sudah dicoba ${p.retryCount} dari ${p.maxRetries} kali. '
            'Backend menolak percobaan berikutnya sampai batas direset.',
        hints: [
          'Buat payment baru dari invoice yang sama, atau',
          'kirim Report agar admin dapat mereset retry.',
        ],
      );
    }
    final gatewayRef = p.gatewayRef;
    if (gatewayRef == null || gatewayRef.isEmpty) {
      return (
        title: 'Gerbang pembayaran tidak merespons',
        detail:
            'Tidak ada referensi transaksi (gatewayRef) yang tersimpan. '
            'Biasanya terjadi ketika koneksi ke gateway terputus sebelum '
            'transaksi tercatat.',
        hints: [
          'Periksa koneksi internet lalu coba Retry.',
          'Bila tetap gagal, kirim Report agar tim menelusuri log.',
        ],
      );
    }
    return (
      title: 'Transaksi ditolak gateway',
      detail:
          'Gateway menolak transaksi dengan referensi $gatewayRef. Penyebab '
          'umum: saldo/limit tidak cukup, kartu kedaluwarsa, atau data metode '
          'pembayaran tidak valid.',
      hints: [
        'Pastikan saldo/limit mencukupi sebelum Retry.',
        'Sisa percobaan: ${p.maxRetries - p.retryCount} kali.',
      ],
    );
  }

  /// Format jeda backoff dari backend menjadi teks ringkas.
  static String _formatDelay(double milliseconds) {
    if (milliseconds < 1000) return '${milliseconds.round()} ms';
    final seconds = milliseconds / 1000;
    if (seconds < 60) {
      final isWhole = seconds == seconds.roundToDouble();
      return '${seconds.toStringAsFixed(isWhole ? 0 : 1)} detik';
    }
    return '${(seconds / 60).toStringAsFixed(1)} menit';
  }
}

/// Judul kecil pemisah antar bagian di layar detail.
class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 2),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: Colors.white38,
        ),
      ),
    );
  }
}

/// Baris label–nilai; gaya sama dengan `_DetailRow` di layar detail transaksi.
class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white54, fontSize: 13),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
