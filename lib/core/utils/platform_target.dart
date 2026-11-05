import 'package:flutter/material.dart';

/// Kategori platform untuk menentukan perilaku gesture/UX per perangkat.
///
/// `Theme.of(context).platform` dipakai — bukan `defaultTargetPlatform`
/// langsung — supaya override tema (mis. di widget test) tetap dihormati.
///
/// Contoh pemakaian: baris ledger memakai double-tap di desktop dan long-press
/// di mobile karena mouse tidak punya long-press yang natural.
class PlatformTarget {
  const PlatformTarget(this.platform);

  /// Ambil platform efektif dari [Theme] di [context].
  factory PlatformTarget.of(BuildContext context) =>
      PlatformTarget(Theme.of(context).platform);

  /// Platform efektif yang sedang dipakai.
  final TargetPlatform platform;

  /// Desktop (Linux/Windows/macOS) — termasuk web yang dibuka di desktop.
  bool get isDesktop => switch (platform) {
    TargetPlatform.linux ||
    TargetPlatform.macOS ||
    TargetPlatform.windows => true,
    TargetPlatform.android ||
    TargetPlatform.iOS ||
    TargetPlatform.fuchsia => false,
  };

  /// Mobile (Android/iOS) — kebalikan dari [isDesktop].
  bool get isMobile => !isDesktop;
}
