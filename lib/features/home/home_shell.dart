import 'package:dompetqu/features/home/widgets/cs_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/application/session_controller.dart';
import '../../core/theme/dompet_brand.dart';
import '../../core/theme/widgets/dompet_gradient_background.dart';
import 'application/bootstrap.dart';
import 'dashboard/dashboard_screen.dart';
import 'contacts/contacts_screen.dart';
import 'inventory/inventory_screen.dart';
import 'order/order_screen.dart';
import 'portfolio/portfolio_screen.dart';
import 'widgets/ai_bubble.dart';

/// Shell utama — padanan `+layout.svelte` + tab NavigationBar di `/dompet`.
class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    // Warm-up data setelah frame pertama supaya app terbuka tanpa hambatan.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(sessionControllerProvider).isAuthenticated) {
        bootstrapDompetData(ref);
      }
    });
  }

  static const _tabs = <NavItem>[
    NavItem(icon: Icons.space_dashboard_outlined, name: 'Dashboard'),
    NavItem(icon: Icons.inventory_2_outlined, name: 'Inventory'),
    NavItem(icon: Icons.contacts_outlined, name: 'Contacts'),
    NavItem(icon: Icons.receipt_long_outlined, name: 'Orders'),
    NavItem(icon: Icons.pie_chart_outline, name: 'Portfolio'),
  ];

  static final _pages = <Widget>[
    const DashboardScreen(),
    const InventoryScreen(),
    const ContactsScreen(),
    const OrderScreen(embedded: true),
    const PortfolioScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionControllerProvider);

    // Reset cache saat sign-out, warm-up ulang saat akun baru sign-in.
    ref.listen(sessionControllerProvider, (prev, next) {
      if (next.status == AuthStatus.unauthenticated) {
        resetDompetData(ref);
      } else if (next.status == AuthStatus.authenticated &&
          prev?.status != AuthStatus.authenticated) {
        bootstrapDompetData(ref);
      }
    });

    if (session.status == AuthStatus.unknown) {
      // loading section
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
        child: DompetGradientBackground(
          child: Stack(
            children: [
              Column(
                children: [
                  // pages section
                  Expanded(
                    child: IndexedStack(index: _index, children: _pages),
                  ),
                  // nav bar section
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 14,
                      top: 8,
                    ),
                    child: Center(
                      child: CSNavBar(
                        stateActive: _index,
                        navs: _tabs,
                        onPressed: (i) => setState(() => _index = i),
                      ),
                    ),
                  ),
                ],
              ),
              // AI bubble section — bisa diseret ke mana saja di layar
              AiBubble(),
            ],
          ),
        ),
      ),
    );
  }
}
