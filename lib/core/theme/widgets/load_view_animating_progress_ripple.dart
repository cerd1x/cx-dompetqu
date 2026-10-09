import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../dompet_brand.dart';

/// Indikator loading memakai `SpinKitRipple` dari flutter_spinkit.
///
/// Berbeda dari spinner biasa, efek ripple berdenyut dari pusat sehingga cocok
/// dipakai sebagai state "sedang memuat" satu layar penuh (full-screen) maupun
/// inline di dalam konten.
///
/// ```dart
/// const LoadViewAnimatingProgressRipple()
/// LoadViewAnimatingProgressRipple(label: 'Memuat data...')
/// ```
class LoadViewAnimatingProgressRipple extends StatelessWidget {
  const LoadViewAnimatingProgressRipple({
    super.key,
    this.size = 72,
    this.color,
    this.borderWidth = 6,
    this.duration = const Duration(milliseconds: 1800),
    this.label,
    this.labelStyle,
    this.padding = const EdgeInsets.all(24),
  });

  /// Diameter ripple.
  final double size;

  /// Warna ripple. Default mengikuti [DompetBrand.gold].
  final Color? color;

  /// Ketebalan garis ripple.
  final double borderWidth;

  /// Durasi satu siklus animasi.
  final Duration duration;

  /// Teks opsional di bawah indikator.
  final String? label;

  /// Gaya teks [label]. Default abu transparan.
  final TextStyle? labelStyle;

  /// Padding pembungkus indikator.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final accent = color ?? DompetBrand.gold;

    return Padding(
      padding: padding,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // indicator section
            SpinKitRipple(
              color: accent,
              size: size,
              borderWidth: borderWidth,
              duration: duration,
            ),
            // label section
            if (label != null) ...[
              const SizedBox(height: 12),
              Text(
                label!,
                textAlign: TextAlign.center,
                style:
                    labelStyle ??
                    const TextStyle(color: Colors.white54, fontSize: 13),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
