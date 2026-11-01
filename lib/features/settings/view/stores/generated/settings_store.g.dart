// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../settings_store.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Pengaturan lokal (dark mode dan mata uang) yang dipersist ke
/// `SharedPreferences`. Default dark mode `true` — app saat ini dark-first.

@ProviderFor(SettingsStore)
final settingsStoreProvider = SettingsStoreProvider._();

/// Pengaturan lokal (dark mode dan mata uang) yang dipersist ke
/// `SharedPreferences`. Default dark mode `true` — app saat ini dark-first.
final class SettingsStoreProvider
    extends $AsyncNotifierProvider<SettingsStore, AppSettings> {
  /// Pengaturan lokal (dark mode dan mata uang) yang dipersist ke
  /// `SharedPreferences`. Default dark mode `true` — app saat ini dark-first.
  SettingsStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsStoreHash();

  @$internal
  @override
  SettingsStore create() => SettingsStore();
}

String _$settingsStoreHash() => r'44bdb178413246caa135009bb958e40ed1a9e846';

/// Pengaturan lokal (dark mode dan mata uang) yang dipersist ke
/// `SharedPreferences`. Default dark mode `true` — app saat ini dark-first.

abstract class _$SettingsStore extends $AsyncNotifier<AppSettings> {
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
