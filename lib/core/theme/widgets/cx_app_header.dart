import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:dompetqu/core/theme/widgets/cx_avatar.dart';
import 'package:dompetqu/features/auth/view/stores/session_store.dart';
import 'package:dompetqu/features/auth/domain/models/auth_user.dart';

/// Header yang dipakai tab-tab di dalam shell — padanan `AppBar.svelte`.
class CxAppHeader extends ConsumerWidget {
  const CxAppHeader({super.key, this.title, this.subtitle, this.actions});

  final String? title;
  final String? subtitle;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(sessionStoreProvider).user;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: [
          // title section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (subtitle != null || user != null)
                  Text(
                    subtitle ??
                        (user != null
                            ? 'Halo, ${user.name.split(' ').first}'
                            : 'DompetQu'),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.white60,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                Text(
                  title ?? 'DompetQu',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          ...?actions,
          // avatar section
          if (user != null) ...[
            const SizedBox(width: 12),
            CxAvatar(
              label: CxUserAvatar.initials(user),
              onTap: () => context.push('/settings'),
            ),
          ],
        ],
      ),
    );
  }
}

/// Avatar lingkaran dengan inisial user (diganti CxAvatar ber-gradient).
class CxUserAvatar {
  CxUserAvatar._();

  static String initials(AuthUser? user) {
    if (user == null) return '?';
    final parts = user.name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first)
        .toUpperCase();
  }
}
