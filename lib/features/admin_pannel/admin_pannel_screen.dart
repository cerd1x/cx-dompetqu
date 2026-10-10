import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mix/mix.dart';

import '../../core/theme/ui_style.dart';
import '../../core/theme/ui_style_controller.dart';
import '../../core/theme/widgets/dompet_avatar.dart';
import '../../core/theme/widgets/dompet_card.dart';
import '../../core/utils/formatters.dart';

/// Layar panel admin — diakses lewat route `/admin` (ikon di header Dashboard).
///
/// Layout bergaya dashboard mobile modern (inspirasi "Zest"): header sapaan,
/// kartu ringkasan bergradien, grid statistik, grafik aktivitas, dan daftar
/// menu admin.
///
/// Seluruh warna diambil dari [UiStyle] (`uiStyleControllerProvider`) sehingga
/// otomatis mengikuti primary/secondary/tertiary, gradient, dan opacity glass
/// yang dikonfigurasi pengguna — bukan warna hardcoded.
class AdminPannelScreen extends ConsumerWidget {
  const AdminPannelScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = ref.watch(uiStyleControllerProvider).value ?? const UiStyle();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            // header section
            const _AdminHeader(),
            const SizedBox(height: 24),
            // overview section
            _OverviewCard(style: style),
            const SizedBox(height: 16),
            // stats section
            _StatRow(style: style),
            const SizedBox(height: 24),
            const _SectionTitle('Aktivitas 7 Hari'),
            const SizedBox(height: 12),
            // chart section
            _ActivityChart(style: style),
            const SizedBox(height: 24),
            const _SectionTitle('Menu Admin'),
            const SizedBox(height: 12),
            // menu section
            _MenuList(style: style),
          ],
        ),
      ),
    );
  }
}

/// Header sapaan + tombol notifikasi dan avatar admin.
class _AdminHeader extends StatelessWidget {
  const _AdminHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // back section
        IconButton(
          tooltip: 'Kembali',
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            }
          },
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white54),
        ),
        const SizedBox(width: 4),
        // title section
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Selamat datang,',
                style: TextStyle(fontSize: 13, color: Colors.white54),
              ),
              Text(
                'Admin Panel',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        // notification section
        _GlassIconButton(icon: Icons.notifications_none_rounded, onTap: () {}),
        const SizedBox(width: 10),
        // avatar section
        const DompetAvatar(label: 'A', size: 42),
      ],
    );
  }
}

/// Tombol ikon bulat berbasis frosted glass.
class _GlassIconButton extends StatelessWidget {
  const _GlassIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Box(
          style: BoxStyler()
              .constraints(
                BoxConstraintsMix.value(
                  (const BoxConstraints()).tighten(width: 42, height: 42),
                ),
              )
              .decoration(
                DecorationMix.value(
                  BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.06),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.12),
                    ),
                  ),
                ),
              ),
          child: Icon(icon, size: 20, color: Colors.white70),
        ),
      ),
    );
  }
}

/// Label seksi dengan aksen garis kecil.
class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Box(
          style: BoxStyler()
              .constraints(
                BoxConstraintsMix.value(
                  (const BoxConstraints()).tighten(width: 4, height: 16),
                ),
              )
              .decoration(
                DecorationMix.value(
                  BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

/// Kartu ringkasan bergradien sesuai [UiStyle.gradientColors].
class _OverviewCard extends StatelessWidget {
  const _OverviewCard({required this.style});

  final UiStyle style;

  @override
  Widget build(BuildContext context) {
    final gradient = LinearGradient(
      colors: style.gradientColors,
      begin: style.gradientBegin,
      end: style.gradientEnd,
    );

    return Box(
      style: BoxStyler()
          .padding(EdgeInsetsGeometryMix.value(const EdgeInsets.all(20)))
          .decoration(
            DecorationMix.value(
              BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
                boxShadow: [
                  BoxShadow(
                    color: style.primary.withValues(alpha: 0.35),
                    blurRadius: 30,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
            ),
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // caption section
          Row(
            children: [
              const Icon(
                Icons.account_balance_wallet_rounded,
                color: Colors.black87,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Total Pendapatan',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black.withValues(alpha: 0.7),
                ),
              ),
              const Spacer(),
              Box(
                style: BoxStyler()
                    .padding(
                      EdgeInsetsGeometryMix.value(
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      ),
                    )
                    .decoration(
                      DecorationMix.value(
                        BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                child: const Text(
                  'Bulan ini',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // value section
          Text(
            formatMoney(128450000, 'IDR'),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          // mini stats section
          Row(
            children: [
              _MiniStat(label: 'Hari ini', value: formatMoney(2450000, 'IDR')),
              const SizedBox(width: 24),
              _MiniStat(
                label: 'Pertumbuhan',
                value: '+12,4%',
                valueColor: Colors.black87,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Stat kecil di dalam kartu overview.
class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.label,
    required this.value,
    this.valueColor = Colors.black87,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.black.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

/// Baris tiga kartu statistik memakai warna aksen [UiStyle].
class _StatRow extends StatelessWidget {
  const _StatRow({required this.style});

  final UiStyle style;

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        label: 'Pengguna',
        value: '1.248',
        icon: Icons.people_alt_rounded,
        color: style.primary,
      ),
      (
        label: 'Transaksi',
        value: '8.902',
        icon: Icons.receipt_long_rounded,
        color: style.secondary,
      ),
      (
        label: 'Produk',
        value: '312',
        icon: Icons.inventory_2_rounded,
        color: style.tertiary,
      ),
    ];

    return Row(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const SizedBox(width: 12),
          Expanded(
            child: DompetCard(
              variant: DompetCardVariant.csGlassCard,
              radius: 18,
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // icon section
                  Box(
                    style: BoxStyler()
                        .constraints(
                          BoxConstraintsMix.value(
                            (const BoxConstraints()).tighten(
                              width: 36,
                              height: 36,
                            ),
                          ),
                        )
                        .decoration(
                          DecorationMix.value(
                            BoxDecoration(
                              color: items[i].color.withValues(alpha: 0.16),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                    child: Icon(items[i].icon, size: 18, color: items[i].color),
                  ),
                  const SizedBox(height: 10),
                  // value section
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      items[i].value,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  // label section
                  Text(
                    items[i].label,
                    style: const TextStyle(fontSize: 11, color: Colors.white54),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Grafik batang sederhana untuk aktivitas mingguan.
class _ActivityChart extends StatelessWidget {
  const _ActivityChart({required this.style});

  final UiStyle style;

  static const _days = ['S', 'S', 'R', 'K', 'J', 'S', 'M'];
  static const _values = [0.4, 0.65, 0.5, 0.9, 0.72, 1.0, 0.58];

  @override
  Widget build(BuildContext context) {
    return DompetCard(
      variant: DompetCardVariant.csGlassCard,
      radius: 20,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Column(
        children: [
          // bars section
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var i = 0; i < _values.length; i++)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: FractionallySizedBox(
                                heightFactor: _values[i],
                                child: Box(
                                  style: BoxStyler().decoration(
                                    DecorationMix.value(
                                      BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            style.primary,
                                            style.secondary.withValues(
                                              alpha: 0.5,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // day label section
                          Text(
                            _days[i],
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.white54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Daftar menu admin berbentuk kartu glass dengan item yang bisa ditekan.
class _MenuList extends StatelessWidget {
  const _MenuList({required this.style});

  final UiStyle style;

  @override
  Widget build(BuildContext context) {
    return DompetCard(
      variant: DompetCardVariant.csGlassCard,
      radius: 20,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < _items.length; i++) ...[
            if (i > 0)
              const Divider(height: 1, indent: 60, color: Color(0x14FFFFFF)),
            _MenuItem(entry: _items[i]),
          ],
        ],
      ),
    );
  }

  static final _items = [
    (
      icon: Icons.people_alt_rounded,
      title: 'Kelola Pengguna',
      subtitle: 'Tambah, edit, nonaktifkan akun',
      route: '/analytics',
    ),
    (
      icon: Icons.receipt_long_rounded,
      title: 'Transaksi',
      subtitle: 'Monitor dan verifikasi transaksi',
      route: '/order',
    ),
    (
      icon: Icons.inventory_2_rounded,
      title: 'Produk & Aset',
      subtitle: 'Inventaris dan kategori',
      route: '/charts',
    ),
    (
      icon: Icons.bug_report_outlined,
      title: 'Laporan Beta',
      subtitle: 'Tinjau log dan masukan pengguna',
      route: '/beta-report',
    ),
    (
      icon: Icons.power_settings_new_rounded,
      title: 'Kill Switch',
      subtitle: 'Matikan/hidupkan operation GraphQL',
      route: '/admin/killswitch',
    ),
    (
      icon: Icons.settings_rounded,
      title: 'Pengaturan',
      subtitle: 'Konfigurasi aplikasi',
      route: '/settings',
    ),
  ];
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({required this.entry});

  final ({IconData icon, String title, String subtitle, String route}) entry;

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push(entry.route),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // icon section
              Box(
                style: BoxStyler()
                    .constraints(
                      BoxConstraintsMix.value(
                        (const BoxConstraints()).tighten(width: 34, height: 34),
                      ),
                    )
                    .decoration(
                      DecorationMix.value(
                        BoxDecoration(
                          color: accent.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                child: Icon(entry.icon, size: 18, color: accent),
              ),
              const SizedBox(width: 14),
              // text section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      entry.subtitle,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              ),
              // trailing section
              const Icon(
                Icons.chevron_right_rounded,
                color: Colors.white38,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
