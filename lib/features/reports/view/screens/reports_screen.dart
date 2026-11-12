import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mix/mix.dart';

import 'package:dompetqu/core/logger/app_logger.dart';
import 'package:dompetqu/core/logger/log_level.dart';
import 'package:dompetqu/core/logger/log_record.dart';
import 'package:dompetqu/core/theme/widgets/cx_button.dart';
import 'package:dompetqu/core/theme/widgets/cx_filter_chip.dart';
import 'package:dompetqu/features/reports/view/stores/reports_store.dart';
import 'package:dompetqu/core/theme/widgets/cx_icons.dart';

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
  Set<int> _selectedIndexes = {};

  AppLogger get _logger => AppLogger.instance;
  bool get _hasSelection => _selectedIndexes.isNotEmpty;

  @override
  void dispose() {
    _messageCtrl.dispose();
    super.dispose();
  }

  void _toggleSelection(int index) {
    setState(() {
      if (_selectedIndexes.contains(index)) {
        _selectedIndexes.remove(index);
      } else {
        _selectedIndexes.add(index);
      }
    });
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

  Future<void> _sendSelected() async {
    if (_selectedIndexes.isEmpty) return;
    final selectedRecords = _logger.records
        .asMap()
        .entries
        .where((entry) => _selectedIndexes.contains(entry.key))
        .map((entry) => entry.value)
        .toList();
    final messages = selectedRecords.map((r) => r.line).join('\n');
    await ref
        .read(reportsStoreProvider.notifier)
        .submitReport(message: 'Log terpilih:\n$messages');
    if (!mounted) return;
    setState(() => _selectedIndexes = {});
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
                        child: CxButton(
                          label: 'Kirim Laporan',
                          leadingIcon: CxIcons.sendRounded,
                          loading: store.submitting,
                          onPressed: store.submitting ? null : _send,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: CxButton(
                          label: 'Salin Log',
                          variant: CxButtonVariant.outline,
                          leadingIcon: CxIcons.copyRounded,
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
                  if (_hasSelection) ...[
                    const SizedBox(height: 8),
                    CxButton(
                      label: 'Kirim ${_selectedIndexes.length} Log Terpilih',
                      leadingIcon: CxIcons.sendRounded,
                      onPressed: _sendSelected,
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
            const SizedBox(height: 8),
            // filter tabs section
            SizedBox(
              height: 30,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  CxFilterChip(
                    label: 'All',
                    selected: store.filterLevel == null,
                    onTap: () => ref
                        .read(reportsStoreProvider.notifier)
                        .setFilterLevel(null),
                  ),
                  const SizedBox(width: 6),
                  for (final level in LogLevel.values) ...[
                    CxFilterChip(
                      label: level.name.toUpperCase(),
                      selected: store.filterLevel == level,
                      onTap: () => ref
                          .read(reportsStoreProvider.notifier)
                          .setFilterLevel(level),
                    ),
                    const SizedBox(width: 6),
                  ],
                ],
              ),
            ),
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
                        return _LogTile(
                          record: r,
                          isSelected: _selectedIndexes.contains(index),
                          onSelect: () => _toggleSelection(index),
                        );
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
  const _LogTile({
    required this.record,
    required this.isSelected,
    required this.onSelect,
  });

  final LogRecord record;
  final bool isSelected;
  final VoidCallback onSelect;

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
      child: InkWell(
        onTap: onSelect,
        borderRadius: BorderRadius.circular(10),
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
                    color: isSelected
                        ? const Color(0x3360A5FA)
                        : const Color(0x0FFFFFFF),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF60A5FA)
                          : Colors.transparent,
                      width: 1,
                    ),
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
                onTap: () =>
                    Clipboard.setData(ClipboardData(text: record.line)),
                borderRadius: BorderRadius.circular(6),
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(
                    CxIcons.copyRounded,
                    size: 14,
                    color: Colors.white38,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
