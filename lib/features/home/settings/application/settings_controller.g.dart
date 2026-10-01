// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Pengaturan lokal (dark mode, mata uang, AI) yang dipersist ke
/// `SharedPreferences`. Default dark mode `true` — app saat ini dark-first.

@ProviderFor(SettingsController)
final settingsControllerProvider = SettingsControllerProvider._();

/// Pengaturan lokal (dark mode, mata uang, AI) yang dipersist ke
/// `SharedPreferences`. Default dark mode `true` — app saat ini dark-first.
final class SettingsControllerProvider
    extends $AsyncNotifierProvider<SettingsController, AppSettings> {
  /// Pengaturan lokal (dark mode, mata uang, AI) yang dipersist ke
  /// `SharedPreferences`. Default dark mode `true` — app saat ini dark-first.
  SettingsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsControllerHash();

  @$internal
  @override
  SettingsController create() => SettingsController();
}

String _$settingsControllerHash() =>
    r'49bd7dacf92b91c1168beccd22bf4ee325b9a02a';

/// Pengaturan lokal (dark mode, mata uang, AI) yang dipersist ke
/// `SharedPreferences`. Default dark mode `true` — app saat ini dark-first.

abstract class _$SettingsController extends $AsyncNotifier<AppSettings> {
  FutureOr<AppSettings> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AppSettings>, AppSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AppSettings>, AppSettings>,
              AsyncValue<AppSettings>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
