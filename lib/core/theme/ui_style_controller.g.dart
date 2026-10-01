// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ui_style_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Kontrol penampilan UI yang berubah saat runtime dan dipersist ke
/// `SharedPreferences`. Mengubah [UiStyle] langsung memicu rebuild tema
/// global (lihat `AppTheme.fromStyle` di `app_theme.dart`).
///
/// Karena slider opacity/blur bisa menembak berkali-kali, persistensi dibuat
/// debounce 50 ms — state in-memory selalu update seketika, hanya penulisan
/// ke disk yang digabung.

@ProviderFor(UiStyleController)
final uiStyleControllerProvider = UiStyleControllerProvider._();

/// Kontrol penampilan UI yang berubah saat runtime dan dipersist ke
/// `SharedPreferences`. Mengubah [UiStyle] langsung memicu rebuild tema
/// global (lihat `AppTheme.fromStyle` di `app_theme.dart`).
///
/// Karena slider opacity/blur bisa menembak berkali-kali, persistensi dibuat
/// debounce 50 ms — state in-memory selalu update seketika, hanya penulisan
/// ke disk yang digabung.
final class UiStyleControllerProvider
    extends $AsyncNotifierProvider<UiStyleController, UiStyle> {
  /// Kontrol penampilan UI yang berubah saat runtime dan dipersist ke
  /// `SharedPreferences`. Mengubah [UiStyle] langsung memicu rebuild tema
  /// global (lihat `AppTheme.fromStyle` di `app_theme.dart`).
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

String _$uiStyleControllerHash() => r'e97b374855d6373d0b64f89563f7e5fdb8f7c1a2';

/// Kontrol penampilan UI yang berubah saat runtime dan dipersist ke
/// `SharedPreferences`. Mengubah [UiStyle] langsung memicu rebuild tema
/// global (lihat `AppTheme.fromStyle` di `app_theme.dart`).
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
