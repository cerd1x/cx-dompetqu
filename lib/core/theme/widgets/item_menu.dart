import 'package:flutter/material.dart';
import 'package:cue/cue.dart';
import 'package:material_ui/material_ui.dart' show GlobalMaterialLocalizations;

import 'round_action_button.dart';

/// Data satu aksi yang ditampilkan [ItemMenu].
class ItemMenuAction {
  const ItemMenuAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
}

/// Tombol menu (titik tiga) yang membuka daftar aksi item — digeneralisasi
/// dari `ProductItemMenu` agar bisa dipakai untuk item apa pun.
class ItemMenu extends StatefulWidget {
  const ItemMenu({super.key, required this.actions});

  final List<ItemMenuAction> actions;

  @override
  State<ItemMenu> createState() => _ItemMenuState();
}

class _ItemMenuState extends State<ItemMenu> {
  bool _isOpen = false;

  Future<void> _toggle(ShowModalFunction showModal) async {
    setState(() => _isOpen = true);
    await showModal();
    if (mounted) setState(() => _isOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Localizations(
      delegates: GlobalMaterialLocalizations.delegates,
      locale: const Locale('id', 'ID'),
      child: CueModalTransition(
        barrierColor: Colors.black12,
        motion: .bouncy(),
        reverseMotion: .snappy(),
        alignment: Alignment.bottomCenter,
        triggerBuilder: (context, showModal) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: SizedBox.square(
            dimension: 35,
            child: IconButton(
              onPressed: () => _toggle(showModal),
              style: IconButton.styleFrom(
                backgroundColor: Colors.transparent,
                shape: const CircleBorder(),
              ),
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.all(0),
              icon: _isOpen
                  ? const Icon(Icons.keyboard_arrow_down)
                  : Column(
                      spacing: 2,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (var i = 0; i < 3; i++)
                          CircleAvatar(
                            radius: 2.5,
                            backgroundColor: colors.onSurface,
                          ),
                      ],
                    ),
            ),
          ),
        ),
        builder: (context, rect) {
          return SizedBox(
            width: rect.width,
            child: Stack(
              alignment: Alignment.bottomCenter,
              fit: StackFit.loose,
              children: [
                Actor(
                  acts: [
                    .scale(from: 0, to: 1, motion: .bouncy()),
                    .translateY(from: -rect.height / 3, to: -rect.height - 4),
                  ],
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var i = 0; i < widget.actions.length; i++) ...[
                        RoundActionButton(
                          icon: widget.actions[i].icon,
                          label: widget.actions[i].label,
                          size: 36,
                          onTap: () {
                            Navigator.of(context).pop();
                            widget.actions[i].onTap();
                          },
                        ),
                        if (i < widget.actions.length - 1)
                          const SizedBox(height: 8),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
