import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../../../core/theme/dompet_brand.dart';
import '../ai/ai_chat_sheet.dart';

/// Tombol melayang ELIPS untuk asisten AI yang bisa DISERET ke mana saja
/// di sekitar layar.
///
/// Tampilan & animasi:
/// - Elips frosted-glass (BackdropFilter blur kecil) dengan ring gradient
///   brand yang ter-blend (gold → purple → pink) + kilau cahaya menyapu.
/// - Animasi idle: napas skala halus, mengambang naik-turun, dan ikon
///   robot menoleh kiri-kanan (wiggle).
/// - Saat digenggam membesar sedikit (springy); saat dilepas MELEKAT ke
///   tepi kiri/kanan terdekat sebagai setengah elips di luar layar.
/// - Setelah 5 detik tanpa interaksi, opacity menurun otomatis.
///
/// Dipasang di dalam Stack body [HomeShell] — area di luar bubble tetap
/// tembus untuk sentuhan (Positioned, bukan full-screen hit test).
class AiBubble extends StatefulWidget {
  const AiBubble({super.key});

  /// Dimensi elips bubble.
  static const double width = 78;
  static const double height = 54;

  /// Jeda idle sebelum opacity menurun otomatis.
  static const Duration fadeAfter = Duration(seconds: 5);

  /// Nilai opacity saat idle.
  static const double dimmedOpacity = 0.35;

  @override
  State<AiBubble> createState() => _AiBubbleState();
}

class _AiBubbleState extends State<AiBubble>
    with SingleTickerProviderStateMixin {
  Offset? _pos;
  bool _dragging = false;
  bool _dockedLeft = true;
  bool _dimmed = false;
  Timer? _idleTimer;

  /// Fraksi lebar yang menempel di luar layar saat melekat
  /// (0.5 = tepat setengah elips terlihat).
  static const double _dockRatio = 0.5;

  late final AnimationController _fx = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3200),
  )..repeat();

  @override
  void initState() {
    super.initState();
    // Posisi awal: melekat di tepi kanan, sedikit di atas nav bar.
    WidgetsBinding.instance.addPostFrameCallback((_) => _placeInitial());
  }

  @override
  void dispose() {
    _idleTimer?.cancel();
    _fx.dispose();
    super.dispose();
  }

  void _placeInitial() {
    if (!mounted) return;
    final mq = MediaQuery.sizeOf(context);
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    setState(() {
      _dockedLeft = false;
      _pos = Offset(
        _dockX(isLeft: false, screenWidth: mq.width),
        mq.height - bottomInset - AiBubble.height - 96,
      );
    });
    _resetIdle();
  }

  /// Posisi X saat melekat: [AiBubble._dockRatio] lebar di luar layar.
  double _dockX({required bool isLeft, required double screenWidth}) =>
      isLeft
          ? -AiBubble.width * _dockRatio
          : screenWidth - AiBubble.width + AiBubble.width * _dockRatio;

  /// Reset timer idle → opacity kembali penuh, jadwalkan fade ulang.
  void _resetIdle() {
    _idleTimer?.cancel();
    if (mounted && _dimmed) setState(() => _dimmed = false);
    _idleTimer = Timer(AiBubble.fadeAfter, () {
      if (mounted) setState(() => _dimmed = true);
    });
  }

  void _onPanStart(DragStartDetails d) {
    _resetIdle();
    setState(() => _dragging = true);
  }

  void _onPanUpdate(DragUpdateDetails d) {
    final pos = _pos;
    if (pos == null) return;
    final mq = MediaQuery.sizeOf(context);
    _resetIdle();
    setState(() {
      _pos = Offset(
        (pos.dx + d.delta.dx).clamp(0, mq.width - AiBubble.width),
        (pos.dy + d.delta.dy).clamp(0, mq.height - AiBubble.height),
      );
    });
  }

  /// Lepas jari → lekat ke tepi terdekat (setengah elips).
  void _onPanEnd(DragEndDetails d) {
    final pos = _pos;
    if (!mounted || pos == null) return;
    final mq = MediaQuery.sizeOf(context);
    final nearLeft = pos.dx + AiBubble.width / 2 < mq.width / 2;
    _resetIdle();
    setState(() {
      _dragging = false;
      _dockedLeft = nearLeft;
      _pos = Offset(
        _dockX(isLeft: nearLeft, screenWidth: mq.width),
        pos.dy.clamp(0, mq.height - AiBubble.height),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final pos = _pos;
    if (pos == null) return const SizedBox.shrink();
    return AnimatedPositioned(
      key: const ValueKey('ai-bubble'),
      duration: _dragging ? Duration.zero : const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      left: pos.dx,
      top: pos.dy,
      child: GestureDetector(
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        onTapDown: (_) => _resetIdle(),
        onTap: () {
          _resetIdle();
          AiChatSheet.show(context);
        },
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: _dimmed ? AiBubble.dimmedOpacity : 1,
          child: _buildFace(),
        ),
      ),
    );
  }

  // ── tampilan ────────────────────────────────────────────────────────

  /// Elips frosted-glass dengan 4 animasi dari satu controller:
  /// napas skala, mengambang, wiggle ikon, dan sheen menyapu permukaan.
  Widget _buildFace() {
    return AnimatedBuilder(
      animation: _fx,
      builder: (_, _) {
        final t = _fx.value;
        final breathe = 1 + 0.045 * math.sin(t * 2 * math.pi);
        final scale = _dragging ? breathe * 1.07 : breathe;
        final bob = 2.4 * math.sin(t * 2 * math.pi);
        final wiggle = 0.14 * math.sin((t % 0.5) * 4 * math.pi);
        final sheen = ((t * 1.6) % 1.0) * 2 - 1; // -1 .. 1 menyapu

        return Transform.translate(
          offset: Offset(0, _dragging ? 0 : bob),
          child: Transform.scale(scale: scale, child: _glassBody(wiggle, sheen)),
        );
      },
    );
  }

  Widget _glassBody(double iconTilt, double sheen) {
    final w = AiBubble.width;
    final h = AiBubble.height;
    final radius = BorderRadius.all(Radius.elliptical(w / 2, h / 2));

    // Geser ikon ke sisi yang masih terlihat saat melekat di tepi.
    final iconShift = !_dragging && _dockedLeft ? w * 0.26 : 0.0;
    final iconShiftRight = !_dragging && !_dockedLeft ? w * 0.26 : 0.0;

    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        borderRadius: radius,
        // ring gradient ter-blend sebagai bingkai tipis.
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            DompetBrand.goldLight.withValues(alpha: 0.95),
            DompetBrand.purple.withValues(alpha: 0.75),
            DompetBrand.pink.withValues(alpha: 0.85),
            DompetBrand.gold.withValues(alpha: 0.95),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: DompetBrand.goldGlow,
            blurRadius: 20,
            offset: Offset(_dockedLeft ? -4 : 4, 6),
          ),
          BoxShadow(
            color: DompetBrand.purple.withValues(alpha: 0.22),
            blurRadius: 14,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(1.6),
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          // frosted glass sungguhan — blur konten di belakang bubble.
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: radius,
              // blend gradient semi transparan di atas hasil blur.
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.20),
                  DompetBrand.goldLight.withValues(alpha: 0.14),
                  DompetBrand.purple.withValues(alpha: 0.16),
                  DompetBrand.blackBg.withValues(alpha: 0.34),
                ],
                stops: const [0.0, 0.42, 0.72, 1.0],
              ),
            ),
            alignment: Alignment.center,
            padding: EdgeInsets.fromLTRB(iconShift, 0, iconShiftRight, 0),
            child: Stack(
              children: [
                // sheen section — kilau menyapu melintasi permukaan
                Positioned.fill(
                  child: Transform.translate(
                    offset: Offset(sheen * w, 0),
                    child: IgnorePointer(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.transparent,
                              Colors.white.withValues(alpha: 0.28),
                              Colors.transparent,
                            ],
                            stops: const [0.35, 0.5, 0.65],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // icon section — robot lucu menoleh kiri-kanan
                Center(
                  child: Transform.rotate(
                    angle: iconTilt,
                    child: Icon(
                      Icons.smart_toy_rounded,
                      size: 26,
                      color: DompetBrand.goldLight,
                      shadows: [
                        Shadow(
                          color: DompetBrand.primary.withValues(alpha: 0.8),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
