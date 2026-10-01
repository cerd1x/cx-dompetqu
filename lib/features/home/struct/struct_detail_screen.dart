import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/theme/widgets/dompet_card.dart';
import '../../../core/utils/balance.dart';
import '../models/transaction.dart';

/// Layar detail struktur transaksi + fitur ekspor ke PNG/img.
///
/// Seluruh kartu struktur dibungkus `RepaintBoundary` sehingga bisa di-capture
/// menjadi gambar PNG lalu disimpan ke direktori dokumen aplikasi.
class StructDetailScreen extends StatefulWidget {
  const StructDetailScreen({super.key, required this.transaction});

  final Transaction transaction;

  @override
  State<StructDetailScreen> createState() => _StructDetailScreenState();
}

class _StructDetailScreenState extends State<StructDetailScreen> {
  final GlobalKey _boundaryKey = GlobalKey();
  bool _saving = false;

  Transaction get tx => widget.transaction;

  _StructTone get _tone => switch (tx.type) {
    'income' => (
      color: const Color(0xFF34D399),
      sign: '+',
      icon: Icons.arrow_upward_rounded,
    ),
    'expense' => (
      color: const Color(0xFFF87171),
      sign: '-',
      icon: Icons.arrow_downward_rounded,
    ),
    _ => (
      color: const Color(0xFFFBBF24),
      sign: '',
      icon: Icons.swap_horiz_rounded,
    ),
  };

  /// Capture struktur card -> PNG -> simpan ke dokumen aplikasi.
  Future<void> _saveAsPng() async {
    final boundary = _boundaryKey.currentContext?.findRenderObject()
        as RenderRepaintBoundary?;
    if (boundary == null) {
      _showError('Tidak dapat menangkap gambar.');
      return;
    }

    setState(() => _saving = true);
    try {
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) throw StateError('encode PNG gagal');

      final baseDir = await getApplicationDocumentsDirectory();
      final stamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final file = File(
        '${baseDir.path}/struct_${stamp}_${tx.id}.png',
      );
      await file.writeAsBytes(byteData.buffer.asUint8List());

      if (!mounted) return;
      setState(() => _saving = false);
      _showSaved(file.path);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      _showError('Gagal menyimpan gambar: $e');
    }
  }

  void _showSaved(String path) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1C1F1E),
        title: const Text('Struktur Tersimpan'),
        content: Text(
          'Gambar struktur berhasil disimpan:\n\n$path',
          style: const TextStyle(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tone = _tone;
    final balance = Balance.parse(tx.amount);
    final amountText = '${tone.sign}${balance.toLocalStr()}';

    return Scaffold(
      backgroundColor: const Color(0xFF121412),
      appBar: AppBar(
        title: const Text('Detail Struktur'),
        actions: [
          IconButton(
            tooltip: 'Simpan sebagai PNG',
            onPressed: _saving ? null : _saveAsPng,
            icon: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.download_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            RepaintBoundary(
              key: _boundaryKey,
              child: _StructCard(
                tx: tx,
                tone: tone,
                amountText: amountText,
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _saving ? null : _saveAsPng,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                backgroundColor: const Color(0xFFFBBF24),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.black,
                      ),
                    )
                  : const Icon(Icons.image_outlined),
              label: Text(_saving ? 'Menyimpan…' : 'Simpan Struktur ke PNG'),
            ),
            const SizedBox(height: 8),
            Text(
              'Gambar akan tersimpan di folder dokumen aplikasi.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: Colors.white.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Kartu struktur — konten detail transaksi yang di-capture menjadi PNG.
class _StructCard extends StatelessWidget {
  const _StructCard({
    required this.tx,
    required this.tone,
    required this.amountText,
  });

  final Transaction tx;
  final _StructTone tone;
  final String amountText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // hero header
        DompetCard(
          variant: DompetCardVariant.csGlassSurface,
          radius: 20,
          padding: const EdgeInsets.symmetric(vertical: 28),
          child: Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: tone.color.withValues(alpha: 0.12),
                  border: Border.all(
                    color: tone.color.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                ),
                child: Icon(tone.icon, size: 28, color: tone.color),
              ),
              const SizedBox(height: 14),
              Text(
                amountText,
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                tx.displayName,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white.withValues(alpha: 0.75),
                ),
              ),
              const SizedBox(height: 4),
              _StatusPill(type: tx.type, status: tx.status),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // structured detail rows
        DompetCard(
          variant: DompetCardVariant.csGlassSurface,
          radius: 20,
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              _StructRow(label: 'ID Transaksi', value: tx.id, mono: true),
              _StructRow(
                label: 'Tanggal',
                value: DateFormat('d MMM yyyy, HH:mm').format(tx.createdAt),
              ),
              _StructRow(
                label: 'Tipe',
                value: tx.type.toUpperCase(),
              ),
              if (tx.category != null)
                _StructRow(label: 'Kategori', value: tx.category!),
              if (tx.description != null)
                _StructRow(label: 'Deskripsi', value: tx.description!),
              if (tx.capital != null)
                _StructRow(label: 'Modal', value: tx.capital!),
              if (tx.paymentMethod != null)
                _StructRow(
                  label: 'Metode',
                  value: tx.paymentMethod!.type.toUpperCase(),
                ),
              _StructRow(label: 'Status', value: tx.status, isLast: true),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.type, required this.status});

  final String type;
  final String status;

  @override
  Widget build(BuildContext context) {
    final ok = status.toLowerCase() == 'success';
    final color = ok ? const Color(0xFF34D399) : const Color(0xFFFBBF24);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 1),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: color,
        ),
      ),
    );
  }
}

class _StructRow extends StatelessWidget {
  const _StructRow({
    required this.label,
    required this.value,
    this.isLast = false,
    this.mono = false,
  });

  final String label;
  final String value;
  final bool isLast;
  final bool mono;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: Colors.white.withValues(alpha: 0.06),
                  width: 1,
                ),
              ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                fontFamily: mono ? 'monospace' : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

typedef _StructTone = ({Color color, String sign, IconData icon});
