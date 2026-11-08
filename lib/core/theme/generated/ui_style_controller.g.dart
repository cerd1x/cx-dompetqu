// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../ui_style_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Kontrol penampilan UI yang berubah saat runtime dan dipersist ke
/// ObjectBox. Mengubah [UiStyle] langsung memicu rebuild tema global (lihat
/// `AppTheme.fromStyle` di `app_theme.dart`).
///
/// Karena slider opacity/blur bisa menembak berkali-kali, persistensi dibuat
/// debounce 50 ms — state in-memory selalu update seketika, hanya penulisan
/// ke disk yang digabung.

@ProviderFor(UiStyleController)
final uiStyleControllerProvider = UiStyleControllerProvider._();

/// Kontrol penampilan UI yang berubah saat runtime dan dipersist ke
/// ObjectBox. Mengubah [UiStyle] langsung memicu rebuild tema global (lihat
/// `AppTheme.fromStyle` di `app_theme.dart`).
///
/// Karena slider opacity/blur bisa menembak berkali-kali, persistensi dibuat
/// debounce 50 ms — state in-memory selalu update seketika, hanya penulisan
/// ke disk yang digabung.
final class UiStyleControllerProvider
    extends $AsyncNotifierProvider<UiStyleController, UiStyle> {
  /// Kontrol penampilan UI yang berubah saat runtime dan dipersist ke
  /// ObjectBox. Mengubah [UiStyle] langsung memicu rebuild tema global (lihat
  /// `AppTheme.fromStyle` di `app_theme.dart`).
  ///
  /// Karena slider opacity/blur bisa menembak berkali-kali, persistensi dibuat
  /// debounce 50 ms — state in-memory selalu update seketika, hanya penulisan
  /// ke disk yang digabung.
  UiStyleControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'uiStyleControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$uiStyleControllerHash();

  @$internal
  @override
  UiStyleController create() => UiStyleController();
}

String _$uiStyleControllerHash() => r'4970339336c1504b5b9575fee1703feaed1b1ab1';

/// Kontrol penampilan UI yang berubah saat runtime dan dipersist ke
/// ObjectBox. Mengubah [UiStyle] langsung memicu rebuild tema global (lihat
/// `AppTheme.fromStyle` di `app_theme.dart`).
///
/// Karena slider opacity/blur bisa menembak berkali-kali, persistensi dibuat
/// debounce 50 ms — state in-memory selalu update seketika, hanya penulisan
/// ke disk yang digabung.

abstract class _$UiStyleController extends $AsyncNotifier<UiStyle> {
  FutureOr<UiStyle> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<UiStyle>, UiStyle>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<UiStyle>, UiStyle>,
              AsyncValue<UiStyle>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
