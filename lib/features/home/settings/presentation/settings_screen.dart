import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mix/mix.dart';

import '../../../../core/theme/cs_dialog.dart';
import '../../../../core/theme/dompet_brand.dart';
import '../../../../core/theme/widgets/dompet_card.dart';
import '../../../auth/application/session_controller.dart';
import '../../../app_lock/presentation/app_lock_setup_screen.dart';
import 'passkey_settings_section.dart';
import 'row_ai_setting_view.dart';
import 'row_currency_picker_view.dart';
import 'row_notifications_view.dart';
import '../application/settings_controller.dart';

/// Versi aplikasi — samakan dengan `version` di pubspec.yaml.
const String kAppVersion = '1.0.0+1';

/// Halaman Settings — padanan `src/routes/dompet/settings/+page.svelte`.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings =
        ref.watch(settingsControllerProvider).value ?? const AppSettings();

    return Scaffold(
      body: Box(
        style: BoxStyler().decoration(
          DecorationMix.value(
            const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF111827), // from-gray-900
                  Color(0x4D581C87), // via-purple-900/30
                  Color(0x4D7C2D12), // to-orange-900/30
                ],
              ),
            ),
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // header section
              _Header(title: 'Settings', onBack: () => context.pop()),
              // settings list section
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 8,
                    children: [
                      // dark mode section
                      _SettingsRow(
                        icon: Icons.dark_mode_outlined,
                        label: 'Dark Mode',
                        trailing: Switch(
                          value: settings.darkMode,
                          onChanged: (v) => ref
                              .read(settingsControllerProvider.notifier)
                              .setDarkMode(v),
                          activeThumbColor: DompetBrand.purple,
                        ),
                      ),
                      // appearance section — theme colors/gradient/opacity/blur
                      _SettingsRow(
                        icon: Icons.palette_outlined,
                        label: 'Penampilan',
                        onTap: () => context.push('/settings/appearance'),
                      ),
                      // notifications section
                      _SettingsRow(
                        icon: Icons.notifications_outlined,
                        label: 'Notifications',
                        onTap: () => _showNotifications(context),
                      ),
                      // profile section
                      _SettingsRow(
                        icon: Icons.account_circle_outlined,
                        label: 'Profile',
                        onTap: () => context.push('/settings/profile'),
                      ),
                      // app lock section
                      _SettingsRow(
                        icon: Icons.lock_outline,
                        label: 'App Lock',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const AppLockSetupScreen(),
                            ),
                          );
                        },
                      ),
                      // passkey section
                      DompetCard(
                        variant: DompetCardVariant.csGlassSurface,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        child: const PasskeySettingsSection(),
                      ),
                      // currency section
                      CurrencyPickerSection(currency: settings.currency),
                      // version section
                      _SettingsRow(
                        icon: Icons.info_outline,
                        label: 'Version',
                        trailing: Text(
                          kAppVersion,
                          style: TextStyle(fontSize: 12, color: Colors.white54),
                        ),
                      ),
                      // update section
                      _SettingsRow(
                        icon: Icons.system_update_outlined,
                        label: 'Update',
                        onTap: () {
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              const SnackBar(
                                content: Text('Sudah versi terbaru'),
                              ),
                            );
                        },
                      ),
                      // logout section
                      _SettingsRow(
                        icon: Icons.logout,
                        label: 'Logout',
                        labelColor: DompetBrand.pink,
                        iconColor: DompetBrand.pink,
                        showChevron: false,
                        onTap: () => _confirmLogout(context, ref),
                      ),
                      // AI settings section — chat, API key & model.
                      const AiSettingsSection(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (dialogCtx) => CsDialog(
        title: 'Logout ?',
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: const Text('BATAL'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              ref.read(sessionControllerProvider.notifier).signOut();
            },
            child: const Text('LOGOUT'),
          ),
        ],
        child: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
      ),
    );
  }

  void _showNotifications(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const NotificationsSheet(),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          // back button section
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_outlined),
            color: Colors.white,
            tooltip: 'back',
          ),
          // title section
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

/// Baris pengaturan dalam kartu `csglass-surface`.
class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.label,
    this.trailing,
    this.onTap,
    this.showChevron = true,
    this.iconColor = DompetBrand.purple,
    this.labelColor,
  });

  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showChevron;
  final Color iconColor;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    return DompetCard(
      variant: DompetCardVariant.csGlassSurface,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      onTap: onTap,
      child: Row(
        children: [
          // icon section
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(width: 12),
          // label section
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 14, color: labelColor ?? Colors.white),
            ),
          ),
          // trailing section
          trailing ??
              (onTap != null && showChevron
                  ? const Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: Colors.white54,
                    )
                  : const SizedBox.shrink()),
        ],
      ),
    );
  }
}
