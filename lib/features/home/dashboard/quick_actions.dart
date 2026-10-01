import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/widgets/round_action_button.dart';
import '../order/order_tab.dart';

/// Padanan tombol aksi cepat di dashboard (`_dashboard/DashboardPage.svelte`).
class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    // Lebar efektif CSNavBar di HomeShell = layar - padding kiri/kanan 16;
    // baris aksi ini dibuat 15% lebih sempit darinya lalu di-center.
    final navBarWidth = MediaQuery.widthOf(context) - 32;
    return Center(
      child: SizedBox(
        width: navBarWidth * 0.85,
        child: Row(
          mainAxisAlignment: .center,
          spacing: 8,
          children: [
            // top up section
            RoundActionButton(
              icon: Icons.add_rounded,
              label: 'Add Transaction',
              onTap: () =>
                  context.push('/order', extra: const OrderRouteArgs.sale()),
            ),
            // receive section
            RoundActionButton(
              icon: Icons.call_received_rounded,
              label: 'Receive',
            ),
            // transfer section
            RoundActionButton(
              icon: Icons.swap_horiz_rounded,
              label: 'Transfer',
            ),
            // charts section
            RoundActionButton(
              icon: Icons.pie_chart_sharp,
              label: 'Charts',
              onTap: () => context.push('/charts'),
            ),
            // analytics section
            RoundActionButton(
              icon: Icons.bar_chart_rounded,
              label: 'Analytics',
              onTap: () => context.push('/analytics'),
            ),
          ],
        ),
      ),
    );
  }
}
