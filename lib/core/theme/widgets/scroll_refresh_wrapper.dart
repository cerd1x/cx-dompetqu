import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../dompet_brand.dart';

/// Cara memicu refresh pada [ScrollRefreshWrapper].
enum ScrollRefreshMode {
  /// Tarik ke bawah saat berada di paling atas (pull-to-refresh).
  pull,

  /// Refresh otomatis begitu scroll kembali mentok ke atas.
  reachTop,
}

/// Pembungkus scrollable yang menjalankan [onRefresh] saat scroll mentok ke
/// atas.
///
/// Dua mode tersedia lewat [mode]:
/// - [ScrollRefreshMode.pull] (default): pengguna menarik ke bawah di posisi
///   paling atas lalu melepas. Indikatornya kustom memakai `SpinKitHourGlass`.
/// - [ScrollRefreshMode.reachTop]: memanggil [onRefresh] otomatis ketika posisi
///   scroll benar-benar mentok ke atas setelah sebelumnya digeser turun.
///
/// ```dart
/// ScrollRefreshWrapper(
///   onRefresh: () => ref.read(assetsControllerProvider.notifier).load(),
///   child: ListView.builder(...),
/// )
/// ```
///
/// Tips: agar pull-to-refresh tetap bekerja walau konten belum melebihi tinggi
/// layar, pastikan scrollable anak memakai
/// `physics: const AlwaysScrollableScrollPhysics()`.
class ScrollRefreshWrapper extends StatefulWidget {
  const ScrollRefreshWrapper({
    super.key,
    required this.child,
    required this.onRefresh,
    this.mode = ScrollRefreshMode.pull,
    this.reachTopThreshold = 0.0,
    this.onlyOnUserDrag = true,
    this.displacement = 48,
    this.triggerExtent = 72,
    this.maxExtent = 120,
    this.color,
    this.backgroundColor = Colors.transparent,
    this.size = 32,
  }) : assert(
         maxExtent > 0,
         'maxExtent harus lebih besar dari 0',
       ),
       assert(
         triggerExtent > 0,
         'triggerExtent harus lebih besar dari 0',
       );

  /// Konten scrollable (ListView, SingleChildScrollView, CustomScrollView, …).
  final Widget child;

  /// Aksi refresh. Dipanggil sekali per pemicu; selama Future belum selesai,
  /// pemicu berikutnya diabaikan.
  final Future<void> Function() onRefresh;

  /// Mode pemicu refresh.
  final ScrollRefreshMode mode;

  /// Ambang "mentok atas" untuk [ScrollRefreshMode.reachTop] (biasanya `0`).
  final double reachTopThreshold;

  /// Bila `true`, [ScrollRefreshMode.reachTop] hanya terpicu oleh gestur
  /// pengguna — bukan perubahan posisi programatik.
  final bool onlyOnUserDrag;

  /// Jarak indikator bertahan dari tepi atas selagi refresh berjalan
  /// (mode [ScrollRefreshMode.pull]).
  final double displacement;

  /// Jarak tarikan minimum agar refresh terpicu (mode pull).
  final double triggerExtent;

  /// Jarak tarikan maksimum yang bisa dicapai (mode pull).
  final double maxExtent;

  /// Warna indikator. Default mengikuti [DompetBrand.gold].
  final Color? color;

  /// Latar di belakang indikator saat area teratas terbuka (mode pull).
  final Color backgroundColor;

  /// Ukuran spinner `SpinKitHourGlass`/`SpinKitFadingCube`.
  final double size;

  @override
  State<ScrollRefreshWrapper> createState() => _ScrollRefreshWrapperState();
}

class _ScrollRefreshWrapperState extends State<ScrollRefreshWrapper>
    with SingleTickerProviderStateMixin {
  /// Baru `true` setelah pengguna menggeser menjauh dari atas, sehingga
  /// [ScrollRefreshMode.reachTop] tidak terpicu saat pertama kali dibuka.
  bool _armed = false;

  bool _refreshing = false;

  /// Jarak bukaan area teratas saat ini (mode pull).
  double _dragExtent = 0;

  late final AnimationController _settle;

  Color get _accent => widget.color ?? DompetBrand.gold;

  @override
  void initState() {
    super.initState();
    _settle = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      upperBound: widget.maxExtent,
    )..addListener(_onSettleTick);
  }

  @override
  void dispose() {
    _settle.dispose();
    super.dispose();
  }

  void _onSettleTick() {
    if (!mounted) return;
    setState(() => _dragExtent = _settle.value);
  }

  Future<void> _trigger() async {
    if (_refreshing) return;
    setState(() => _refreshing = true);
    try {
      await widget.onRefresh();
    } finally {
      if (mounted) setState(() => _refreshing = false);
    }
  }

  // --- mode reachTop -------------------------------------------------------

  bool _onReachTopNotification(ScrollNotification notification) {
    if (notification is! ScrollUpdateNotification) return false;

    final atTop = notification.metrics.pixels <= widget.reachTopThreshold;
    if (!atTop) {
      _armed = true;
      return false;
    }

    final userDriven = notification.dragDetails != null;
    final allowed = !widget.onlyOnUserDrag || userDriven;
    if (_armed && allowed) {
      _armed = false;
      _trigger();
    }
    return false;
  }

  // --- mode pull -----------------------------------------------------------

  bool _onPullNotification(ScrollNotification notification) {
    if (_refreshing) return false;

    if (notification is OverscrollNotification) {
      final m = notification.metrics;
      if (m.pixels <= m.minScrollExtent && notification.overscroll < 0) {
        _settle.stop();
        _settle.value = (_dragExtent - notification.overscroll).clamp(
          0.0,
          widget.maxExtent,
        );
      }
    } else if (notification is ScrollEndNotification) {
      if (_dragExtent >= widget.triggerExtent) {
        _settle.animateTo(
          widget.displacement.clamp(0.0, widget.maxExtent),
        );
        _trigger().whenComplete(() {
          if (mounted) _settle.animateTo(0);
        });
      } else if (_dragExtent > 0) {
        _settle.animateTo(0);
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mode == ScrollRefreshMode.reachTop) {
      return NotificationListener<ScrollNotification>(
        onNotification: _onReachTopNotification,
        child: Stack(
          children: [
            widget.child,
            if (_refreshing)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _TopSpinner(color: _accent, size: widget.size),
              ),
          ],
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: _onPullNotification,
      child: Stack(
        children: [
          // indicator section — terlihat saat area teratas terbuka
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: ClipRect(
                child: Container(
                  height: _dragExtent,
                  color: widget.backgroundColor,
                  alignment: Alignment.center,
                  child: Opacity(
                    opacity: _refreshing
                        ? 1
                        : (_dragExtent / widget.triggerExtent).clamp(0.0, 1.0),
                    child: SpinKitHourGlass(color: _accent, size: widget.size),
                  ),
                ),
              ),
            ),
          ),
          // content section — digeser turun mengikuti tarikan
          Transform.translate(
            offset: Offset(0, _dragExtent),
            child: widget.child,
          ),
        ],
      ),
    );
  }
}

/// Indikator loading `SpinKitFadingCube` untuk mode reachTop.
class _TopSpinner extends StatelessWidget {
  const _TopSpinner({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(child: SpinKitFadingCube(color: color, size: size)),
    );
  }
}
