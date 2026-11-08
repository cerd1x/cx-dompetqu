import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mix/mix.dart';

import 'package:dompetqu/core/logger/app_logger.dart';
import 'package:dompetqu/core/logger/log_level.dart';
import 'package:dompetqu/core/logger/log_record.dart';
import 'package:dompetqu/core/theme/widgets/dompet_button.dart';
import 'package:dompetqu/features/reports/view/stores/reports_store.dart';

/// Layar laporan: menampilkan hasil dari [AppLogger] (log yang tertangkap),
/// menyalinnya, dan menyimpan laporan ke backend/database via store.
class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  final _messageCtrl = TextEditingController();
  String? _copyResult;

  AppLogger get _logger => AppLogger.instance;

  @override
  void dispose() {
    _messageCtrl.dispose();
    super.dispose();
  }

  Future<void> _copy() async {
    final text = _logger.exportText();
    if (text.isEmpty) {
      setState(() => _copyResult = 'Belum ada log yang bisa disalin.');
      return;
    }
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    setState(
      () => _copyResult = '${_logger.records.length} baris log disalin.',
    );
  }

  Future<void> _send() async {
    await ref
        .read(reportsStoreProvider.notifier)
        .submitReport(message: _messageCtrl.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final store = ref.watch(reportsStoreProvider);
    final records = store.records;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B12),
      appBar: AppBar(
        title: const Text('Reports'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // report form section
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // description input section
                  TextField(
                    controller: _messageCtrl,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      hintText: 'Deskripsi masalah (opsional)...',
                      filled: true,
                      fillColor: Color(0x14FFFFFF),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // action buttons section
                  Row(
                    children: [
                      Expanded(
                        child: DompetButton(
                          label: 'Kirim Laporan',
                          leadingIcon: Icons.send_rounded,
                          loading: store.submitting,
                          onPressed: store.submitting ? null : _send,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DompetButton(
                          label: 'Salin Log',
                          variant: DompetButtonVariant.outline,
                          leadingIcon: Icons.copy_rounded,
                          onPressed: _copy,
                        ),
                      ),
                    ],
                  ),
                  // result section
                  if (store.submitSuccess) ...[
                    const SizedBox(height: 8),
                    const Text(
                      'Laporan terkirim. Terima kasih atas masukannya!',
                      style: TextStyle(fontSize: 12, color: Color(0xFF34D399)),
                    ),
                  ],
                  if (store.submitError != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      store.submitError!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFF87171),
                      ),
                    ),
                  ],
                  if (_copyResult != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _copyResult!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF34D399),
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  // summary section
                  Text(
                    '${_logger.records.length} log · ${_logger.errorCount} error',
                    style: const TextStyle(fontSize: 12, color: Colors.white54),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0x1FFFFFFF)),
            // log list section
            Expanded(
              child: records.isEmpty
                  ? const Center(
                      child: Text(
                        'Belum ada log.',
                        style: TextStyle(color: Colors.white38),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: records.length,
                      itemBuilder: (context, index) {
                        final r = records[index];
                        return _LogTile(record: r);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogTile extends StatelessWidget {
  const _LogTile({required this.record});

  final LogRecord record;

  @override
  Widget build(BuildContext context) {
    final level = record.level;
    final color = switch (level) {
      LogLevel.error => const Color(0xFFF87171),
      LogLevel.warn => const Color(0xFFFBBF24),
      LogLevel.success => const Color(0xFF34D399),
      LogLevel.debug => const Color(0xFF94A3B8),
      LogLevel.info => const Color(0xFF60A5FA),
    };
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Box(
        style: BoxStyler()
            .padding(
              EdgeInsetsGeometryMix.value(
                const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              ),
            )
            .constraints(
              BoxConstraintsMix.value(
                (const BoxConstraints()).tighten(
                  width: double.infinity,
                  height: null,
                ),
              ),
            )
            .decoration(
              DecorationMix.value(
                BoxDecoration(
                  color: const Color(0x0FFFFFFF),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // log content section
            Expanded(
              child: Text(
                record.line,
                style: TextStyle(
                  fontSize: 11,
                  fontFamily: 'monospace',
                  color: color,
                  height: 1.3,
                ),
              ),
            ),
            // copy button section
            InkWell(
              onTap: () => Clipboard.setData(ClipboardData(text: record.line)),
              borderRadius: BorderRadius.circular(6),
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(
                  Icons.copy_rounded,
                  size: 14,
                  color: Colors.white38,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
