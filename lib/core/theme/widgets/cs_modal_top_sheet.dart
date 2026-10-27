import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../dompet_brand.dart';

Future<T?> showCsModalTopBar<T>({
  required BuildContext context,
  bool isScrollControlled = false,
  bool barrierDismissible = true,
  Color barrierColor = const Color(0x99000000),
  String barrierLabel = 'Dismiss',
  Duration transitionDuration = const Duration(milliseconds: 350),
  Curve transitionCurve = Curves.easeOutCubic,
  required WidgetBuilder builder,
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: barrierLabel,
    barrierColor: barrierColor,
    transitionDuration: transitionDuration,
    pageBuilder: (ctx, anim1, anim2) {
      final mediaQuery = MediaQuery.of(ctx);
      final topPadding = mediaQuery.viewPadding.top;
      final maxHeight = mediaQuery.size.height * 0.5;

      return SafeArea(
        top: false,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: maxHeight,
              maxWidth: mediaQuery.size.width,
            ),
            child: Material(
              color: Colors.transparent,
              child: _CsTopBarDragHandle(
                content: builder(ctx),
                topPadding: topPadding,
              ),
            ),
          ),
        ),
      );
    },
    transitionBuilder: (ctx, anim1, anim2, child) {
      final slideAnim = Tween<Offset>(
        begin: const Offset(0, -1),
        end: Offset.zero,
      ).chain(CurveTween(curve: transitionCurve)).animate(anim1);

      return SlideTransition(
        position: slideAnim,
        child: FadeTransition(opacity: anim1, child: child),
      );
    },
  );
}

class _CsTopBarDragHandle extends StatelessWidget {
  const _CsTopBarDragHandle({required this.content, required this.topPadding});

  final Widget content;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.primaryDelta != null && details.primaryDelta! > 0) {
          Navigator.of(context).pop();
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Box(
            style: BoxStyler()
                .margin(
                  EdgeInsetsGeometryMix.value(
                    EdgeInsets.only(top: topPadding + 8),
                  ),
                )
                .constraints(
                  BoxConstraintsMix.value(
                    (const BoxConstraints()).tighten(width: 36, height: 4),
                  ),
                )
                .decoration(
                  DecorationMix.value(
                    BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
          ),
          Flexible(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
              child: Box(
                style: BoxStyler().decoration(
                  DecorationMix.value(
                    BoxDecoration(
                      // Warna sudah di-precomposite di atas latar gelap
                      // (brand 40% + background gelap), jadi panel tetap
                      // terbaca sebagai kaca berwarna tanpa `BackdropFilter`.
                      // Blur backdrop di sheet ini ikut di-render ulang tiap
                      // frame selama animasi slide; tiga nilai pertama adalah
                      // hasil komposisi 0.4 * brand + 0.6 * #0A0A0A.
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF5A472F),
                          Color(0xFF24113F),
                          Colors.black,
                          Color(0xFF65455B),
                        ],
                      ),
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(20),
                      ),
                      border: Border(
                        bottom: BorderSide(
                          color: DompetBrand.csBorder,
                          width: 1,
                        ),
                        left: BorderSide(color: DompetBrand.csBorder, width: 1),
                        right: BorderSide(
                          color: DompetBrand.csBorder,
                          width: 1,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x99000000),
                          blurRadius: 14,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                  ),
                ),
                child: content,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
