import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

import 'cs_mix.dart';
import 'dompet_brand.dart';

/// Dialog dengan CsFrost (frosted glass effect) di panel.
///
/// Scrim memakai warna statis (BUKAN BackdropFilter fullscreen): blur
/// fullscreen memaksa kompositor membaca & blur ulang seluruh framebuffer
/// setiap frame (termasuk semua blur kartu di belakangnya) dan membatalkan
/// raster cache — sumber utama jank saat dialog dibuka. Blur scrim hanya
/// aktif jika [overlayBlur] > 0 (opt-in).
///
/// Gunakan [CsDialog] untuk semua dialog di app dengan styling konsisten.
/// Contoh:
/// ```dart
/// showDialog(
///   context: context,
///   builder: (_) => CsDialog(
///     title: 'Confirm',
///     child: Text('Really delete?'),
///     actions: [
///       TextButton(onPressed: () => Navigator.pop(context), child: Text('No')),
///       TextButton(onPressed: () { /* delete */ Navigator.pop(context); }, child: Text('Yes')),
///     ],
///   ),
/// );
/// ```
class CsDialog extends StatelessWidget {
  const CsDialog({
    super.key,
    this.title,
    required this.child,
    this.actions,
    this.radius = 20,
    this.blur = 5,
    this.overlayBlur = 0,
    this.padding = 24,
    this.maxWidth = 500,
  });

  /// Judul dialog (opsional). Jika ada, ditampilkan di atas child.
  final String? title;

  /// Konten utama dialog.
  final Widget child;

  /// Tombol aksi di bawah (biasanya confirm/cancel).
  final List<Widget>? actions;

  /// Border radius untuk dialog.
  final double radius;

  /// Blur sigma untuk backdrop filter pada dialog (CsFrost).
  final double blur;

  /// Blur sigma untuk overlay/scrim di belakang dialog. Default 0 —
  /// scrim blur fullscreen sangat mahal (lihat doc class); nilai > 0
  /// mengaktifkannya secara eksplisit.
  final double overlayBlur;

  /// Padding di dalam dialog.
  final double padding;

  /// Lebar maksimal dialog.
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pop(),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // scrim statis — murah, tidak memicu re-blur tiap frame
          const ColoredBox(color: Color(0x73000000)),
          if (overlayBlur > 0)
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: overlayBlur,
                sigmaY: overlayBlur,
              ),
              child: const SizedBox.expand(),
            ),
          CsFrost(
            radius: radius,
            blur: blur,
            shadow: [
              const BoxShadow(
                color: Color(0x59000000),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
            child: GestureDetector(
              onTap: () {},
              child: Dialog(
                backgroundColor: Colors.transparent,
                insetPadding: const EdgeInsets.all(16),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: Box(
                    style: BoxStyler()
                        .gradient(DompetBrand.gradientWithAlpha(.4))
                        .borderRounded(radius)
                        .borderAll(color: DompetBrand.csBorder, width: 1.5)
                        .paddingAll(padding),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (title != null) ...[
                            Text(
                              title!,
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                            ),
                            const SizedBox(height: 16),
                          ],
                          child,
                          if (actions != null && actions!.isNotEmpty) ...[
                            const SizedBox(height: 24),
                            Wrap(
                              alignment: WrapAlignment.end,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 12,
                              runSpacing: 8,
                              children: actions!,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
