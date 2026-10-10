import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mix/mix.dart';

import '../../../../core/theme/dompet_brand.dart';
import '../../../../core/theme/widgets/dompet_card.dart';
import '../../../auth/application/session_controller.dart';

/// Halaman Profile — padanan `src/routes/dompet/settings/profile/+page.svelte`.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(sessionControllerProvider).user;

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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back_outlined),
                      color: Colors.white,
                      tooltip: 'back',
                    ),
                    const Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              // profile content section
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 16),
                      // avatar section
                      Center(
                        child: Box(
                          style: BoxStyler()
                              .width(96)
                              .height(96)
                              .decoration(
                                DecorationMix.value(
                                  const BoxDecoration(
                                    color: Color(0x338B5CF6),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          child: const Icon(
                            Icons.account_circle_outlined,
                            size: 48,
                            color: DompetBrand.purple,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // name section
                      Text(
                        user?.name ?? 'User Name',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      // username section
                      Text(
                        user?.username ?? '-',
                        style: TextStyle(fontSize: 14, color: Colors.white54),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      // detail rows section
                      const _DetailRow(label: 'Phone', value: '-'),
                      const _DetailRow(label: 'Location', value: '-'),
                      const _DetailRow(label: 'Member since', value: '-'),
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
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DompetCard(
      variant: DompetCardVariant.csGlassSurface,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
          Text(value, style: TextStyle(fontSize: 12, color: Colors.white54)),
        ],
      ),
    );
  }
}
