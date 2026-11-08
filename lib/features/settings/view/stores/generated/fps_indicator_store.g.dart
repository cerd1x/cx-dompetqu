// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../fps_indicator_store.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Status tampil/sembunyi indikator FPS.
///
/// Dipersist ke ObjectBox lewat [SettingsRepository] (key
/// `show_fps`), bukan lagi ke SharedPreferences.

@ProviderFor(FpsIndicatorStore)
final fpsIndicatorStoreProvider = FpsIndicatorStoreProvider._();

/// Status tampil/sembunyi indikator FPS.
///
/// Dipersist ke ObjectBox lewat [SettingsRepository] (key
/// `show_fps`), bukan lagi ke SharedPreferences.
final class FpsIndicatorStoreProvider
    extends $AsyncNotifierProvider<FpsIndicatorStore, bool> {
  /// Status tampil/sembunyi indikator FPS.
  ///
  /// Dipersist ke ObjectBox lewat [SettingsRepository] (key
  /// `show_fps`), bukan lagi ke SharedPreferences.
  FpsIndicatorStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fpsIndicatorStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fpsIndicatorStoreHash();

  @$internal
  @override
  FpsIndicatorStore create() => FpsIndicatorStore();
}

String _$fpsIndicatorStoreHash() => r'daf01ee492aaee4601782586e1117553e3fc896f';

/// Status tampil/sembunyi indikator FPS.
///
/// Dipersist ke ObjectBox lewat [SettingsRepository] (key
/// `show_fps`), bukan lagi ke SharedPreferences.

abstract class _$FpsIndicatorStore extends $AsyncNotifier<bool> {
  FutureOr<bool> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
