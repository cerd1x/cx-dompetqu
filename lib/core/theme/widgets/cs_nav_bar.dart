import 'dart:async';
import 'dart:ui' show ImageFilter;

import 'package:dompetqu/core/theme/dompet_brand.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

const double _kBarHeight = 56;
const double _kBarPadding = 4;
const double _kItemHeight = 40;
const double _kItemRadius = 14;
const double _kItemSize = 40;
const double _kSpacing = 4;
const double _kBarRadius = _kBarHeight / 2;

class CSNavBar extends StatefulWidget {
  const CSNavBar({
    super.key,
    required this.onPressed,
    required this.navs,
    this.stateActive = 0,
    this.classAttr = "",
  });

  final void Function(int idx) onPressed;
  final int stateActive;
  final List<NavItem> navs;
  final String classAttr;

  @override
  State<CSNavBar> createState() => _CSNavBarState();
}

class _CSNavBarState extends State<CSNavBar> {
  late int _activeIndex;

  @override
  void initState() {
    super.initState();
    _activeIndex = widget.stateActive;
  }

  @override
  void didUpdateWidget(covariant CSNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.stateActive != oldWidget.stateActive) {
      _activeIndex = widget.stateActive;
    }
  }

  void _onTap(int idx) {
    setState(() {
      _activeIndex = idx;
    });
    widget.onPressed(idx);
  }

  Widget _buildItem(int i, BoxConstraints constraints) {
    final nav = widget.navs[i];
    final isActive = i == _activeIndex;

    if (isActive) {
      return Expanded(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutCubic,
          height: _kItemHeight,
          child: _NavBarItem(
            nav: nav,
            isActive: isActive,
            onTap: () => _onTap(i),
          ),
        ),
      );
    } else {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
        height: _kItemHeight,
        width: _kItemSize,
        child: _NavBarItem(
          nav: nav,
          isActive: isActive,
          onTap: () => _onTap(i),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(_kBarRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Box(
          style: BoxStyler()
              .padding(
                EdgeInsetsGeometryMix.value(
                  const EdgeInsets.fromLTRB(14, _kBarPadding, 14, _kBarPadding),
                ),
              )
              .constraints(
                BoxConstraintsMix.value(
                  (const BoxConstraints()).tighten(
                    width: null,
                    height: _kBarHeight,
                  ),
                ),
              )
              .decoration(
                DecorationMix.value(
                  BoxDecoration(
                    borderRadius: BorderRadius.circular(_kBarRadius),
                    gradient: const LinearGradient(
                      colors: [Color(0x99CC5500), Color(0x40000000)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(
                      color: const Color(0xCC8B5CF6),
                      width: 1,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x99000000),
                        blurRadius: 24,
                        offset: Offset(0, 10),
                      ),
                      BoxShadow(
                        color: Color(0x408B5CF6),
                        blurRadius: 28,
                        spreadRadius: -6,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                spacing: _kSpacing,
                children: [
                  for (int i = 0; i < widget.navs.length; i++)
                    _buildItem(i, constraints),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.nav,
    required this.isActive,
    required this.onTap,
  });

  final NavItem nav;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
        height: _kItemHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_kItemRadius),
          border: Border.all(
            color: isActive ? const Color(0x80D1D5DB) : const Color(0x4DFFA55C),
          ),
          gradient: isActive
              ? LinearGradient(
                  colors: [
                    DompetBrand.goldDark,
                    Colors.black,
                    DompetBrand.purple,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.35, 1],
                )
              : null,
          color: isActive ? null : const Color(0xFF111111),
        ),
        padding: isActive
            ? const EdgeInsets.symmetric(horizontal: 12, vertical: 4)
            : EdgeInsets.zero,
        child: isActive
            ? _ShimmerNavItem(nav: nav)
            : Center(
                key: const ValueKey('inactive'),
                child: Icon(nav.icon, size: 20, color: const Color(0xFFFFA55C)),
              ),
      ),
    );
  }
}

class _ShimmerNavItem extends StatefulWidget {
  const _ShimmerNavItem({required this.nav});

  final NavItem nav;

  @override
  State<_ShimmerNavItem> createState() => _ShimmerNavItemState();
}

class _ShimmerNavItemState extends State<_ShimmerNavItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fx = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3200),
  );
  bool _shimmerDone = false;
  Timer? _shimmerTimer;

  @override
  void initState() {
    super.initState();
    _shimmerTimer = Timer(const Duration(milliseconds: 1000), () {
      if (!mounted || _shimmerDone) return;
      _fx.forward().then((_) {
        if (mounted) setState(() => _shimmerDone = true);
      });
    });
  }

  @override
  void dispose() {
    _shimmerTimer?.cancel();
    _fx.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;

        // Minimum width needed for icon + gap + readable text
        final showText = availableWidth >= 46;

        return Stack(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              reverseDuration: Duration.zero,
              child: SizedBox(
                width: availableWidth,
                child: Row(
                  key: const ValueKey('active'),
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Box(
                      style: BoxStyler()
                          .constraints(
                            BoxConstraintsMix.value(
                              (const BoxConstraints()).tighten(
                                width: 45,
                                height: 45,
                              ),
                            ),
                          )
                          .decoration(
                            DecorationMix.value(
                              BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0x6686EFAC),
                                ),
                                gradient: const LinearGradient(
                                  colors: [DompetBrand.goldDark, Colors.black],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  stops: [0.0, 0.7],
                                ),
                              ),
                            ),
                          ),
                      child: Icon(
                        widget.nav.icon,
                        size: 20,
                        color: DompetBrand.gold,
                      ),
                    ),
                    if (showText) ...[
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.nav.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class NavItem {
  const NavItem({required this.icon, required this.name, this.active = false});

  final IconData icon;
  final String name;
  final bool active;
}
