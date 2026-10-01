import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

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
        child: FadeTransition(
          opacity: anim1,
          child: child,
        ),
      );
    },
  );
}

class _CsTopBarDragHandle extends StatelessWidget {
  const _CsTopBarDragHandle({
    required this.content,
    required this.topPadding,
  });

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
          Container(
            margin: EdgeInsets.only(top: topPadding + 8),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Flexible(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        DompetBrand.gold.withValues(alpha: 0.4),
                        Colors.purple.shade900.withValues(alpha: 0.4),
                        Colors.black.withValues(alpha: 0.4),
                        DompetBrand.pink.withValues(alpha: 0.4),
                      ],
                    ),
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(20),
                    ),
                    border: Border(
                      bottom: BorderSide(color: DompetBrand.csBorder, width: 1),
                      left: BorderSide(color: DompetBrand.csBorder, width: 1),
                      right: BorderSide(color: DompetBrand.csBorder, width: 1),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x99000000),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: content,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
