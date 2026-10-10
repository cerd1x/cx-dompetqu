import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../../../core/theme/dompet_brand.dart';

/// Widget pola 3×3 untuk app lock.
/// Pengguna menggambar pola dengan menghubungkan titik-titik.
class PatternInput extends StatefulWidget {
  const PatternInput({super.key, this.onCompleted});

  final ValueChanged<List<int>>? onCompleted;

  @override
  State<PatternInput> createState() => PatternInputState();
}

class PatternInputState extends State<PatternInput> {
  final List<int> _selected = [];
  Offset? _currentPosition;
  final List<Offset> _dotCenters = [];
  bool _error = false;

  static const double _dotSize = 18;
  static const double _padding = 24;
  static const double _spacing = 80;

  @override
  Widget build(BuildContext context) {
    final boardSize = _padding * 2 + _spacing * 3;
    _calculateDotCenters(boardSize);
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: Box(
        style: BoxStyler()
            .constraints(
              BoxConstraintsMix.value(
                (const BoxConstraints()).tighten(
                  width: boardSize,
                  height: boardSize,
                ),
              ),
            )
            .decoration(
              DecorationMix.value(
                BoxDecoration(
                  color: DompetBrand.csFill,
                  borderRadius: BorderRadius.circular(DompetBrand.radius),
                  border: Border.all(color: DompetBrand.csBorder, width: 1),
                ),
              ),
            ),
        child: CustomPaint(
          painter: _PatternPainter(
            selected: _selected,
            dotCenters: _dotCenters,
            currentPosition: _currentPosition,
            error: _error,
            boardSize: boardSize,
          ),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }

  void _calculateDotCenters(double boardSize) {
    _dotCenters.clear();
    final startX = _padding + _spacing / 2;
    final startY = _padding + _spacing / 2;
    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        _dotCenters.add(
          Offset(startX + col * _spacing, startY + row * _spacing),
        );
      }
    }
  }

  int _hitTest(Offset pos) {
    for (int i = 0; i < _dotCenters.length; i++) {
      if ((pos - _dotCenters[i]).distance < _dotSize + 16) {
        return i;
      }
    }
    return -1;
  }

  void _onPanStart(DragStartDetails details) {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;
    final local = box.globalToLocal(details.globalPosition);
    final hit = _hitTest(local);
    if (hit >= 0 && !_selected.contains(hit)) {
      setState(() {
        _selected.add(hit);
        _currentPosition = _dotCenters[hit];
        _error = false;
      });
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;
    final local = box.globalToLocal(details.globalPosition);
    final hit = _hitTest(local);
    setState(() {
      _currentPosition = local;
      if (hit >= 0 && !_selected.contains(hit)) {
        _selected.add(hit);
      }
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _currentPosition = null;
    });
    if (_selected.length >= 4) {
      widget.onCompleted?.call(List.unmodifiable(_selected));
    } else if (_selected.isNotEmpty) {
      setState(() => _error = true);
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          setState(() {
            _selected.clear();
            _error = false;
          });
        }
      });
    }
  }

  void clear() {
    setState(() {
      _selected.clear();
      _error = false;
      _currentPosition = null;
    });
  }
}

class _PatternPainter extends CustomPainter {
  _PatternPainter({
    required this.selected,
    required this.dotCenters,
    required this.currentPosition,
    required this.error,
    required this.boardSize,
  });

  final List<int> selected;
  final List<Offset> dotCenters;
  final Offset? currentPosition;
  final bool error;
  final double boardSize;

  Color get _lineColor => error ? const Color(0xFFEF4444) : DompetBrand.purple;

  Color get _dotColor => error ? const Color(0xFFEF4444) : DompetBrand.purple;

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = _lineColor
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = DompetBrand.csBorder
      ..style = PaintingStyle.fill;

    final activePaint = Paint()
      ..color = _dotColor.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    final selectedPaint = Paint()
      ..color = _dotColor
      ..style = PaintingStyle.fill;

    // Draw all dots
    for (int i = 0; i < 9; i++) {
      final center = dotCenters[i];
      if (selected.contains(i)) {
        canvas.drawCircle(center, 20, activePaint);
        canvas.drawCircle(center, 10, selectedPaint);
      } else {
        canvas.drawCircle(center, 8, dotPaint);
      }
    }

    // Draw lines between selected dots
    if (selected.length > 1) {
      for (int i = 0; i < selected.length - 1; i++) {
        canvas.drawLine(
          dotCenters[selected[i]],
          dotCenters[selected[i + 1]],
          linePaint,
        );
      }
    }

    // Draw line from last selected to current finger position
    if (selected.isNotEmpty && currentPosition != null) {
      canvas.drawLine(
        dotCenters[selected.last],
        currentPosition!,
        linePaint..color = _lineColor.withValues(alpha: 0.5),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PatternPainter oldDelegate) {
    return oldDelegate.selected != selected ||
        oldDelegate.currentPosition != currentPosition ||
        oldDelegate.error != error;
  }
}
