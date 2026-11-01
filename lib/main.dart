import 'dart:io';

import 'package:dompetqu/features/assets/view/screens/asset_detail_screen.dart';
import 'package:dompetqu/features/analytics/view/screens/analytics_screen.dart';
import 'package:dompetqu/features/contacts/domain/models/contact.dart';
import 'package:dompetqu/features/dashboard/view/widgets/home_shell.dart';
import 'package:dompetqu/features/gen_ai/view/screens/ai_setting_screen.dart';
import 'package:dompetqu/features/gen_ai/view/screens/gen_ai_screen.dart';
import 'package:dompetqu/features/order/view/screens/detail_payment_failed_view.dart';
import 'package:dompetqu/features/order/view/screens/order_screen.dart';
import 'package:dompetqu/features/payments/domain/models/payment.dart';
import 'package:dompetqu/features/order/view/widgets/order_tab.dart'
    show OrderRouteArgs, OrderTab;
import 'package:dompetqu/features/settings/view/screens/appearance_screen.dart';
import 'package:dompetqu/features/settings/view/screens/profile_screen.dart';
import 'package:dompetqu/features/settings/view/screens/settings_screen.dart';
import 'package:dompetqu/features/settings/view/stores/fps_indicator_store.dart';
import 'package:dompetqu/features/settings/view/stores/settings_store.dart';
import 'package:dompetqu/features/transactions/domain/models/transaction.dart';
import 'package:dompetqu/features/transactions/view/screens/transaction_detail_screen.dart';
import 'package:dompetqu/features/struct/view/screens/struct_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'core/diagnostics/fps_indicator.dart';
import 'core/logger/app_logger.dart';
import 'core/logger/log_config.dart';
import 'core/network/cookie_aware_client.dart';
import 'package:dompetqu/core/theme/app_theme.dart';
import 'package:dompetqu/core/theme/ui_style.dart';
import 'package:dompetqu/core/theme/ui_style_controller.dart';
import 'features/auth/view/stores/session_store.dart';
import 'features/auth/view/screens/auth_screen.dart';
import 'package:dompetqu/features/admin_pannel/view/screens/admin_pannel_screen.dart';
import 'package:dompetqu/features/admin_pannel/view/screens/killswitch_controll_screen.dart';
import 'package:dompetqu/features/beta_report/view/screens/beta_report_screen.dart';
import 'features/contacts/view/screens/contact_detail_screen.dart';
import 'features/contacts/view/screens/contact_merge.dart';
import 'features/app_lock/view/stores/app_lock_store.dart';
import 'features/app_lock/view/screens/app_lock_screen.dart';
import 'features/charts/view/screens/charts_trading.dart';

part 'generated/main.g.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppLogger.instance.installGlobalHooks();
  AppLogger.instance.info(
    'App dimulai (${const String.fromEnvironment('API_BASE_URL')})',
    tag: 'App',
  );
  await AppLogger.instance.enableFileLogging(
    directory: Directory("/home/cerd1x/Documents/cx-dompetqu"),
    features: fileLogFeatures,
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
    final settings = ref.watch(settingsStoreProvider).value;
    final darkMode = settings?.darkMode ?? true;
    // Toggle tampil/sembunyi overlay FPS (persist ke prefs). Default ON.
    final showFps = ref.watch(fpsIndicatorStoreProvider).value ?? true;
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
      // Overlay FPS dipasang di sini (bukan di `main()`) supaya berada di
      // dalam `MediaQuery`/`Directionality` milik `MaterialApp` dan tetap
      // terlihat di semua route, termasuk `/auth` dan `/app-lock`.
      // Visibilitas dikontrol runtime lewat toggle di Settings
      // (`fpsIndicatorStoreProvider`), jadi overlay ini juga bisa tampil di
      // build release; saat toggle mati widget hanya meneruskan `child`.
      builder: (context, child) => FpsIndicator(
        visible: showFps,
        child: child ?? const SizedBox.shrink(),
      ),
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
      final session = ref.read(sessionStoreProvider);
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
        final lockState = ref.read(appLockStoreProvider).value;
        if (lockState?.isEnabled == true && lockState?.locked == true) {
          return '/app-lock';
        }
      }
      // Go home once the app is no longer locked (unlocked or lock disabled).
      if (session.status == AuthStatus.authenticated && onLock) {
        final lockState = ref.read(appLockStoreProvider).value;
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
      GoRoute(path: '/ai-settings', builder: (_, _) => const AiSettingScreen()),
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
      GoRoute(
        path: '/payment-failed',
        // Payment dikirim utuh lewat `extra` — data sudah ada di daftar Failed,
        // jadi tidak perlu query ulang hanya untuk membuka detail.
        builder: (_, state) =>
            DetailPaymentFailedView(payment: state.extra as Payment),
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

  ref.listen(sessionStoreProvider, (previous, next) {
    if (previous?.status != next.status) {
      router.refresh();
    }
  });

  ref.listen(appLockStoreProvider, (previous, next) {
    final prevLocked = previous?.value?.locked;
    final nextLocked = next.value?.locked;
    if (prevLocked != nextLocked) {
      router.refresh();
    }
  });

  return router;
}
