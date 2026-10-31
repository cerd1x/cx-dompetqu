import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'quick_actions.dart';
import 'recent_list_transaction.dart';
import 'stats_grid.dart';
import 'package:dompetqu/features/statistics/stores/statistics_store.dart';
import 'package:dompetqu/features/transactions/stores/transactions_store.dart';
import 'package:dompetqu/core/theme/widgets/app_header.dart';
import 'package:dompetqu/core/theme/widgets/placeholders.dart';

/// Padanan `_dashboard/DashboardPage.svelte` + `AppBar.svelte` (restyle fluttermix).
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(statisticsStoreProvider);
    final transactions = ref.watch(transactionsStoreProvider);

    return TabScaffold(
      // header section
      header: AppHeader(
        title: 'DompetQu',
        actions: [
          IconButton(
            tooltip: 'Admin Panel',
            onPressed: () => context.push('/admin'),
            icon: const Icon(
              Icons.admin_panel_settings_outlined,
              color: Colors.white54,
            ),
          ),
          IconButton(
            tooltip: 'Laporan Beta',
            onPressed: () => context.push('/beta-report'),
            icon: const Icon(Icons.bug_report_outlined, color: Colors.white54),
          ),
        ],
      ),
      body: Column(
        children: [
          // stats grid section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: StatsGrid(stats: stats),
          ),
          const SizedBox(height: 16),
          // recent list section
          Expanded(child: RecentListTransaction(transactions: transactions)),
          const SizedBox(height: 12),
          // quick actions section
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
            child: const QuickActions(),
          ),
        ],
      ),
    );
  }
}
