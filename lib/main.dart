import 'dart:io';

import 'package:dompetqu/features/home/asset-detail/asset_detail_screen.dart';
import 'package:dompetqu/features/home/analytics/analytics_screen.dart';
import 'package:dompetqu/features/home/models/contact.dart';
import 'package:dompetqu/features/home/transaction/transaction_detail_screen.dart';
import 'package:dompetqu/features/home/struct/struct_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'core/graphql/graphql_providers.dart';
import 'core/logger/app_logger.dart';
import 'core/network/cookie_aware_client.dart';
import 'package:dompetqu/core/theme/app_theme.dart';
import 'package:dompetqu/core/theme/ui_style.dart';
import 'package:dompetqu/core/theme/ui_style_controller.dart';
import 'features/auth/application/session_controller.dart';
import 'features/auth/presentation/auth_screen.dart';
import 'features/admin_pannel/admin_pannel_screen.dart';
import 'features/admin_pannel/killswitch_controll_screen.dart';
import 'features/beta_report/beta_report_screen.dart';
import 'features/home/contacts/contact_detail_screen.dart';
import 'features/home/contacts/contact_merge.dart';
import 'features/home/home_shell.dart';
import 'features/home/models/transaction.dart';
import 'features/home/order/order_screen.dart';
import 'features/home/order/order_tab.dart';
import 'features/app_lock/application/app_lock_controller.dart';
import 'features/app_lock/presentation/app_lock_screen.dart';
import 'features/home/settings/application/settings_controller.dart';
import 'features/home/settings/presentation/appearance_screen.dart';
import 'features/home/settings/presentation/profile_screen.dart';
import 'features/home/settings/presentation/settings_screen.dart';
import 'features/charts/charts_trading.dart';
import 'features/gen_ai/presentation/gen_ai_screen.dart';

part 'main.g.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppLogger.instance.installGlobalHooks();
  AppLogger.instance.info(
    'App dimulai (${const String.fromEnvironment('API_BASE_URL')})',
    tag: 'App',
  );
  await AppLogger.instance.enableFileLogging(
    directory: Directory("/home/cerd1x/Documents/cx-dompetqu"),
  );

  final cookieClient = CookieAwareClient();
  await cookieClient.restore();

  runApp(
    ProviderScope(
      overrides: [cookieAwareClientProvider.overrideWithValue(cookieClient)],
      child: const DompetQuApp(),
    ),
  );
}

class DompetQuApp extends ConsumerWidget {
  const DompetQuApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final settings = ref.watch(settingsControllerProvider).value;
    final darkMode = settings?.darkMode ?? true;
    final uiStyle =
        ref.watch(uiStyleControllerProvider).value ?? const UiStyle();
    return MaterialApp.router(
      title: 'DompetQu',
      theme: AppTheme.fromStyle(
        uiStyle,
        brightness: darkMode ? Brightness.dark : Brightness.light,
      ),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

/// Router utama. Redirect ke `/auth` saat sesi tidak terautentikasi.
///
/// Tidak memakai `ref.watch` di dalam `redirect` karena perubahan state saat
/// navigasi berlangsung memicu re-run redirect di zona guard go_router dan
/// melempar `GoException: Bad state: Future already completed`. Dipakai
/// `ref.read` + `ref.listen` yang memanggil `router.refresh()` saat status
/// sesi berubah (pola resmi dari go_router + Riverpod).
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final session = ref.read(sessionControllerProvider);
      if (session.status == AuthStatus.unknown) return null;
      final onAuth = state.matchedLocation == '/auth';
      final onLock = state.matchedLocation == '/app-lock';
      if (session.status == AuthStatus.unauthenticated && !onAuth) {
        return '/auth';
      }
      if (session.status == AuthStatus.authenticated && onAuth) {
        return '/';
      }
      // Show app lock screen if app lock is enabled and user is authenticated
      if (session.status == AuthStatus.authenticated && !onAuth && !onLock) {
        final lockState = ref.read(appLockControllerProvider).value;
        if (lockState?.isEnabled == true && lockState?.locked == true) {
          return '/app-lock';
        }
      }
      // Go home once the app is no longer locked (unlocked or lock disabled).
      if (session.status == AuthStatus.authenticated && onLock) {
        final lockState = ref.read(appLockControllerProvider).value;
        if (lockState != null &&
            (lockState.isEnabled != true || lockState.locked != true)) {
          return '/';
        }
      }
      return null;
    },
    routes: [
      GoRoute(path: '/auth', builder: (_, _) => const AuthScreen()),
      GoRoute(
        path: '/beta-report',
        builder: (_, _) => const BetaReportScreen(),
      ),
      GoRoute(path: '/admin', builder: (_, _) => const AdminPannelScreen()),
      GoRoute(
        path: '/admin/killswitch',
        builder: (_, _) => const KillswitchControllScreen(),
      ),
      GoRoute(path: '/app-lock', builder: (_, _) => const AppLockScreen()),
      GoRoute(path: '/', builder: (_, _) => const HomeShell()),
      GoRoute(path: '/settings', builder: (_, _) => const SettingsScreen()),
      GoRoute(
        path: '/settings/appearance',
        builder: (_, _) => const AppearanceScreen(),
      ),
      GoRoute(
        path: '/settings/profile',
        builder: (_, _) => const ProfileScreen(),
      ),
      GoRoute(path: '/gen-ai', builder: (_, _) => const GenAiScreen()),
      GoRoute(
        path: '/order',
        builder: (_, state) {
          // Argumen typed: tab tujuan + parameter spesifiknya (mis. produk
          // untuk form Sale). Absen/tipe lain → default Bookkeeping.
          final args = state.extra;
          return OrderScreen(
            initialTab: args is OrderRouteArgs
                ? args.tab
                : OrderTab.bookkeeping,
            product: args is OrderRouteArgs ? args.product : null,
          );
        },
      ),
      GoRoute(
        path: '/asset-detail/:id',
        builder: (_, state) {
          final id = state.extra is String ? state.extra as String : '';
          return AssetDetailScreen(assetId: id);
        },
      ),
      GoRoute(
        path: '/transaction-detail',
        builder: (_, state) =>
            TransactionDetailScreen(transaction: state.extra as Transaction),
      ),
      GoRoute(path: '/analytics', builder: (_, _) => const AnalyticsScreen()),
      GoRoute(
        path: '/contact-detail/:id',
        builder: (_, state) => ContactDetailScreen(
          contactId: state.pathParameters['id'] ?? '',
          // Dikirim dari list agar tetap tampil walau kontak belum termuat
          // (list dimuat per halaman).
          initialContact: state.extra as Contact?,
        ),
      ),
      GoRoute(
        path: '/contact-merge/:id',
        builder: (_, state) =>
            ContactMergeScreen(contactId: state.pathParameters['id'] ?? ''),
      ),
      GoRoute(
        path: '/struct-details',
        builder: (_, state) =>
            StructDetailScreen(transaction: state.extra as Transaction),
      ),
      GoRoute(
        path: '/charts',
        builder: (_, state) => TradingChartScreen(
          symbol: (state.extra is String) ? state.extra as String : 'BTCUSDT',
        ),
      ),
    ],
  );

  ref.listen(sessionControllerProvider, (previous, next) {
    if (previous?.status != next.status) {
      router.refresh();
    }
  });

  ref.listen(appLockControllerProvider, (previous, next) {
    final prevLocked = previous?.value?.locked;
    final nextLocked = next.value?.locked;
    if (prevLocked != nextLocked) {
      router.refresh();
    }
  });

  return router;
}
