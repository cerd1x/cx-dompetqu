import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Overlay indikator FPS untuk membuktikan apakah app benar-benar menyentuh
/// 120 fps di device, bukan hanya "terasa halus".
///
/// Kenapa diukur begini:
/// - **FPS** dihitung dari jumlah frame yang benar-benar diproduksi per detik
///   (`addPostFrameCallback` yang me-rearm diri), bukan dari `Timer`. Angka
///   yang turun berarti UI thread tidak sanggup menyusul vsync.
/// - **ui / raster ms** diambil dari `addTimingsCallback`. Ini pembeda yang
///   penting: kalau `ui` kecil (≈2 ms) tapi `raster` besar (≈14 ms), yang
///   harus diperbaiki adalah fill-rate/shadow/`BackdropFilter`, bukan pohon
///   widget. Kalau `ui` yang besar, tersangka utamanya `build`/`layout`.
/// - Nilai dipublikasikan **sekali per detik** lewat `ValueNotifier`, jadi
///   overlay ini sendiri tidak menambah beban frame yang sedang diukur
///   (observer tidak boleh mengubah yang diamati).
///
/// Catatan: `addTimingsCallback` melaporkan data di Android/iOS. Di desktop
/// (Linux) engine tidak selalu mengirim `FrameTiming`, sehingga baris
/// ui/raster bisa tampil `–`; angka FPS tetap jalan karena dihitung sendiri.
///
/// Visibilitas dikontrol **runtime** lewat [visible] (toggle di Settings,
/// dipersist ke SharedPreferences), bukan lagi gerbang compile-time. Karena
/// itu overlay ini ikut terbawa di build release juga — badge tidak
/// di-tree-shake, melainkan disembunyikan oleh [visible] == false.
class FpsIndicator extends StatefulWidget {
  const FpsIndicator({
    super.key,
    required this.child,
    this.visible = true,
  });

  final Widget child;

  /// Tampil/sembunyikan overlay FPS. Saat `false`, pengukuran berhenti dan
  /// widget hanya meneruskan [child] tanpa `Stack` (tanpa overhead).
  final bool visible;

  @override
  State<FpsIndicator> createState() => _FpsIndicatorState();
}

class _FpsIndicatorState extends State<FpsIndicator> {
  /// Angka terakhir yang dipublikasikan. Disimpan di notifier supaya hanya
  /// badge kecil yang rebuild, bukan seluruh `MaterialApp`.
  final ValueNotifier<_FpsStats> _stats = ValueNotifier(
    const _FpsStats(fps: 0),
  );

  /// Jam dinding untuk menghitung laju frame — `Timer` tidak dijamin presisi,
  /// jadi delta-nya diukur sendiri.
  final Stopwatch _clock = Stopwatch()..start();

  Timer? _ticker;
  int _lastTickUs = 0;

  // Akumulator satu interval (1 detik).
  int _frames = 0;
  int _buildUs = 0;
  int _rasterUs = 0;
  int _timingSamples = 0;

  /// Apakah pengukuran sedang berjalan — dipakai dispose agar melepas
  /// callback hanya bila benar-benar pernah dipasang.
  bool _measuring = false;

  @override
  void initState() {
    super.initState();
    if (widget.visible) _startMeasuring();
  }

  @override
  void didUpdateWidget(covariant FpsIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Toggle visibilitas terjadi saat runtime (via Settings), jadi siklus
    // hidup pengukuran harus di-manage di sini — `initState` tidak jalan ulang.
    if (widget.visible != oldWidget.visible) {
      widget.visible ? _startMeasuring() : _stopMeasuring();
    }
  }

  @override
  void dispose() {
    _stopMeasuring();
    _stats.dispose();
    super.dispose();
  }

  /// Pasang seluruh sumber frame/timer pengukuran.
  ///
  /// `addPostFrameCallback` tidak memicu frame sendiri — ia hanya menumpang
  /// frame yang memang sedang digambar. Karena itu, saat app idle callback
  /// ini berhenti dipanggil sama sekali (tidak ada frame = tidak ada kerja),
  /// dan ia bisa dihentikan hanya dengan tidak me-rearm dirinya.
  /// (Catatan: `addPersistentFrameCallback` tidak dipakai karena tidak ada
  /// API untuk melepasnya, sehingga callback tetap terpanggil setelah
  /// dispose.)
  void _startMeasuring() {
    if (_measuring) return;
    _measuring = true;
    _clock
      ..reset()
      ..start();
    _lastTickUs = 0;
    _resetAccumulators();
    SchedulerBinding.instance.addPostFrameCallback(_onFrame);
    SchedulerBinding.instance.addTimingsCallback(_onTimings);
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _publish());
  }

  /// Lepas seluruh callback/timer. Aman dipanggil saat sudah berhenti.
  void _stopMeasuring() {
    if (!_measuring) return;
    _measuring = false;
    SchedulerBinding.instance.removeTimingsCallback(_onTimings);
    // `_onFrame` dilepas dengan tidak me-rearm dirinya lagi (lihat `_onFrame`);
    // tidak ada API eksplisit untuk melepas post-frame callback tunggal.
    _ticker?.cancel();
    _ticker = null;
  }

  void _resetAccumulators() {
    _frames = 0;
    _buildUs = 0;
    _rasterUs = 0;
    _timingSamples = 0;
  }

  /// Hitung satu frame, lalu pasang lagi untuk frame berikutnya.
  ///
  /// Berhenti otomatis saat `mounted == false` atau pengukuran dimatikan
  /// (visible=false); tidak perlu (dan tidak bisa) dilepas manual seperti
  /// persistent frame callback.
  void _onFrame(Duration _) {
    if (!mounted || !_measuring) return;
    _frames++;
    SchedulerBinding.instance.addPostFrameCallback(_onFrame);
  }

  void _onTimings(List<FrameTiming> timings) {
    if (!_measuring) return;
    for (final timing in timings) {
      _buildUs += timing.buildDuration.inMicroseconds;
      _rasterUs += timing.rasterDuration.inMicroseconds;
      _timingSamples++;
    }
  }

  /// Rangkum interval terakhir lalu reset akumulator.
  ///
  /// Saat app diam tidak ada frame yang diproduksi; angka terakhir sengaja
  /// dipertahankan supaya idle tidak terbaca sebagai 0 fps (padahal idle itu
  /// justru kondisi terbaik).
  void _publish() {
    if (!mounted || !_measuring) return;
    final nowUs = _clock.elapsedMicroseconds;
    final deltaUs = nowUs - _lastTickUs;
    if (deltaUs <= 0) return;

    final measured = _frames * Duration.microsecondsPerSecond / deltaUs;
    final hasTiming = _timingSamples > 0;
    final previous = _stats.value;

    _stats.value = _FpsStats(
      fps: _frames > 0 ? measured : previous.fps,
      uiMs: hasTiming ? _buildUs / _timingSamples / 1000 : previous.uiMs,
      rasterMs: hasTiming
          ? _rasterUs / _timingSamples / 1000
          : previous.rasterMs,
    );

    _lastTickUs = nowUs;
    _resetAccumulators();
  }

  @override
  Widget build(BuildContext context) {
    // Saat disembunyikan: teruskan child apa adanya, tanpa Stack/tanpa
    // RepaintBoundary tambahan (nol overhead render).
    if (!widget.visible) return widget.child;

    return Stack(
      fit: StackFit.expand,
      children: [
        widget.child,
        // Ditempel di bawah status bar supaya tidak menutupi tombol header.
        Positioned(
          top: MediaQuery.paddingOf(context).top + 8,
          right: 8,
          child: IgnorePointer(
            // Layer sendiri: perubahan teks tiap detik tidak memicu repaint
            // isi layar di belakangnya.
            child: RepaintBoundary(
              child: ValueListenableBuilder<_FpsStats>(
                valueListenable: _stats,
                builder: (_, stats, _) => _FpsBadge(stats: stats),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Nilai hasil satu interval pengukuran.
@immutable
class _FpsStats {
  const _FpsStats({required this.fps, this.uiMs, this.rasterMs});

  final double fps;
  final double? uiMs;
  final double? rasterMs;
}

/// Badge kecil di pojok kanan atas.
class _FpsBadge extends StatelessWidget {
  const _FpsBadge({required this.stats});

  final _FpsStats stats;

  /// Ambang mengikuti target 120 fps: hijau = aman, kuning = setengah target,
  /// merah = di bawah 50 fps (jelas terasa patah).
  Color get _color {
    if (stats.fps >= 100) return const Color(0xFF4ADE80);
    if (stats.fps >= 50) return const Color(0xFFFBBF24);
    return const Color(0xFFF87171);
  }

  String _ms(double? value) => value == null ? '–' : value.toStringAsFixed(1);

  @override
  Widget build(BuildContext context) {
    final digits = stats.fps <= 0 ? '–' : stats.fps.round().toString();

    // `tabularFigures` menjaga lebar digit tetap supaya badge tidak bergoyang
    // setiap angka berubah (mencegah layout pass tambahan tiap detik).
    const numberStyle = TextStyle(
      fontSize: 13,
      height: 1.1,
      fontWeight: FontWeight.w700,
      fontFeatures: [FontFeature.tabularFigures()],
    );
    const metaStyle = TextStyle(
      fontSize: 9,
      height: 1.2,
      color: Colors.white70,
      fontFeatures: [FontFeature.tabularFigures()],
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xCC000000),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0x33FFFFFF)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(digits, style: numberStyle.copyWith(color: _color)),
                const SizedBox(width: 2),
                Text('fps', style: metaStyle),
              ],
            ),
            Text(
              'ui ${_ms(stats.uiMs)} · r ${_ms(stats.rasterMs)} ms',
              style: metaStyle,
            ),
          ],
        ),
      ),
    );
  }
}
