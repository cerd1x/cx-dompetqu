import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

/// Lembar notifikasi — padanan popover `PopupNotification.svelte`.
class NotificationsSheet extends StatelessWidget {
  const NotificationsSheet({super.key});

  static const _items = [
    (
      Icons.check_circle,
      Color(0xFF22C55E),
      'Transfer Succesfuly',
      'Transfer Dana TO BNI 1234567890',
    ),
    (
      Icons.check_circle,
      Color(0xFF22C55E),
      'Transfer Succesfuly',
      'Transfer Dana TO BNI 1234567890',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // title section
            Text(
              'Notifications',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            // notification items section
            for (final (icon, color, message, desc) in _items)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Box(
                  style: BoxStyler()
                      .padding(
                        EdgeInsetsGeometryMix.value(const EdgeInsets.all(12)),
                      )
                      .decoration(
                        DecorationMix.value(
                          BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                          ),
                        ),
                      ),
                  child: Row(
                    children: [
                      Icon(icon, size: 22, color: color),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              desc,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Tutup'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
