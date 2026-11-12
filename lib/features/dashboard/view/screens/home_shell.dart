import 'package:dompetqu/features/gen_ai/view/widgets/ai_bubble.dart';
import 'package:dompetqu/features/gen_ai/view/stores/ai_settings_store.dart';
import 'package:dompetqu/core/theme/widgets/cx_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:dompetqu/features/auth/view/stores/session_store.dart';
import 'package:dompetqu/core/theme/dompet_brand.dart';
import 'package:dompetqu/core/theme/widgets/cx_gradient_background.dart';
import 'package:dompetqu/features/dashboard/view/stores/bootstrap.dart';
import 'package:dompetqu/core/theme/widgets/cx_icons.dart';

/// Shell utama dengan ShellRoute — persistent bottom nav lewat GoRouter.
class HomeShell extends ConsumerStatefulWidget {
  final Widget child;

  const HomeShell({required this.child, super.key});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  /// Tab route → index mapping
  static const Map<String, int> _routeToIndex = {
    '/': 0,
    '/inventory': 1,
    '/contacts': 2,
    '/orders': 3,
    '/portfolio': 4,
  };

  static const _tabs = <NavItem>[
    NavItem(icon: CxIcons.spaceDashboardOutlined, name: 'Dashboard'),
    NavItem(icon: CxIcons.inventory2Outlined, name: 'Inventory'),
    NavItem(icon: CxIcons.contactsOutlined, name: 'Contacts'),
    NavItem(icon: CxIcons.receiptLongOutlined, name: 'Orders'),
    NavItem(icon: CxIcons.pieChartOutline, name: 'Portfolio'),
  ];

  @override
  void initState() {
    super.initState();
    // Warm-up data setelah frame pertama supaya app terbuka tanpa hambatan.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(sessionStoreProvider).isAuthenticated) {
        bootstrapDompetData(ref);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionStoreProvider);
    final showAiBubble =
        ref.watch(aiSettingsStoreProvider).value?.showAiBubble ?? true;
    final location = GoRouterState.of(context).matchedLocation;
    final currentIndex = _routeToIndex[location] ?? 0;

    // Reset cache saat sign-out, warm-up ulang saat akun baru sign-in.
    ref.listen(sessionStoreProvider, (prev, next) {
      if (next.status == AuthStatus.unauthenticated) {
        resetDompetData(ref);
      } else if (next.status == AuthStatus.authenticated &&
          prev?.status != AuthStatus.authenticated) {
        bootstrapDompetData(ref);
      }
    });

    // Blokir sampai sesi benar-benar terautentikasi.
    if (session.status != AuthStatus.authenticated) {
      return const Scaffold(
        body: Center(
          child: SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: DompetBrand.purple,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: CxGradientBackground(
          child: Stack(
            children: [
              Column(
                children: [
                  // pages section
                  Expanded(child: widget.child),
                  // nav bar section
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 14,
                      top: 8,
                    ),
                    child: Center(
                      child: CxNavBar(
                        stateActive: currentIndex,
                        navs: _tabs,
                        onPressed: (i) {
                          final routes = [
                            '/',
                            '/inventory',
                            '/contacts',
                            '/orders',
                            '/portfolio',
                          ];
                          context.go(routes[i]);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              // AI bubble section
              if (showAiBubble) const AiBubble(),
            ],
          ),
        ),
      ),
    );
  }
}
