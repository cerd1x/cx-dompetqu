import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mix/mix.dart';

import '../../core/logger/app_logger.dart';
import '../../core/logger/beta_report_remote.dart';
import '../../core/logger/log_level.dart';
import '../../core/logger/log_record.dart';
import '../../core/theme/widgets/dompet_button.dart';

/// Layar laporan beta: melihat log yang tertangkap, menyalin, dan mengirim
/// laporan ke backend (`POST /api/beta/report`).
class BetaReportScreen extends StatefulWidget {
  const BetaReportScreen({super.key});

  @override
  State<BetaReportScreen> createState() => _BetaReportScreenState();
}

class _BetaReportScreenState extends State<BetaReportScreen> {
  final _messageCtrl = TextEditingController();
  bool _sending = false;
  String? _result;
  bool _isError = false;

  AppLogger get _logger => AppLogger.instance;

  @override
  void dispose() {
    _messageCtrl.dispose();
    super.dispose();
  }

  Future<void> _copy() async {
    final text = _logger.exportText();
    if (text.isEmpty) {
      _setResult('Belum ada log yang bisa disalin.');
      return;
    }
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    _setResult('${_logger.records.length} baris log disalin.');
  }

  Future<void> _send() async {
    if (_logger.records.isEmpty) {
      _setResult('Belum ada log untuk dikirim.');
      return;
    }
    setState(() {
      _sending = true;
      _result = null;
    });
    try {
      await BetaReportRemote.instance.send(
        message: _messageCtrl.text.trim(),
        logs: _logger.exportJson(),
        appVersion: '1.0.0+1',
      );
      _logger.info('Laporan beta terkirim.', tag: 'BetaReport');
      if (!mounted) return;
      setState(() {
        _sending = false;
        _isError = false;
        _result = 'Laporan terkirim. Terima kasih atas masukannya!';
      });
    } on Exception catch (e) {
      _logger.error(
        'Gagal mengirim laporan beta.',
        error: e,
        tag: 'BetaReport',
      );
      if (!mounted) return;
      setState(() {
        _sending = false;
        _isError = true;
        _result = 'Gagal mengirim: $e';
      });
    }
  }

  void _setResult(String text) {
    setState(() {
      _isError = false;
      _result = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B12),
      appBar: AppBar(
        title: const Text('Laporan Beta'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _logger,
          builder: (context, _) {
            final records = _logger.latest(200);
            return Column(
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
                              loading: _sending,
                              onPressed: _sending ? null : _send,
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
                      if (_result != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          _result!,
                          style: TextStyle(
                            fontSize: 12,
                            color: _isError
                                ? const Color(0xFFF87171)
                                : const Color(0xFF34D399),
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      // summary section
                      Text(
                        '${_logger.records.length} log · '
                        '${_logger.errorCount} error',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white54,
                        ),
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
            );
          },
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
    );
  }
}
