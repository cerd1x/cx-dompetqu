import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:cx_dompetqiu/core/theme/widgets/cx_button_act_round.dart';
import 'package:cx_dompetqiu/features/order/view/widgets/order_tab.dart';
import 'package:cx_dompetqiu/core/theme/widgets/cx_icons.dart';

/// Padanan tombol aksi cepat di dashboard (`_dashboard/DashboardPage.svelte`).
class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    // Lebar efektif CxNavBar di HomeShell = layar - padding kiri/kanan 16;
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
            CxButtonActRound(
              icon: CxIcons.addRounded,
              label: 'Add Transaction',
              onTap: () =>
                  context.go('/orders', extra: const OrderRouteArgs.sale()),
            ),
            // receive section
            CxButtonActRound(
              icon: CxIcons.callReceivedRounded,
              label: 'Receive',
            ),
            // transfer section
            CxButtonActRound(
              icon: CxIcons.swapHorizRounded,
              label: 'Transfer',
            ),
            // charts section
            CxButtonActRound(
              icon: CxIcons.pieChartSharp,
              label: 'Charts',
              onTap: () => context.push('/charts'),
            ),
            // analytics section
            CxButtonActRound(
              icon: CxIcons.barChartRounded,
              label: 'Analytics',
              onTap: () => context.push('/analytics'),
            ),
            CxButtonActRound(
              icon: CxIcons.autoAwesomeRounded,
              label: 'AI Assistant',
              onTap: () => context.push('/gen-ai'),
            ),
          ],
        ),
      ),
    );
  }
}
