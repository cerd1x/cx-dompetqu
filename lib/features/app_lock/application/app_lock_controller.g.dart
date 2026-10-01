// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_lock_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Controller untuk state & logika app lock.

@ProviderFor(AppLockController)
final appLockControllerProvider = AppLockControllerProvider._();

/// Controller untuk state & logika app lock.
final class AppLockControllerProvider
    extends $AsyncNotifierProvider<AppLockController, AppLockState> {
  /// Controller untuk state & logika app lock.
  AppLockControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLockControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLockControllerHash();

  @$internal
  @override
  AppLockController create() => AppLockController();
}

String _$appLockControllerHash() => r'87489d20f614507880c4dfbe6c5c2cb41e96bf82';

/// Controller untuk state & logika app lock.

abstract class _$AppLockController extends $AsyncNotifier<AppLockState> {
  FutureOr<AppLockState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AppLockState>, AppLockState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AppLockState>, AppLockState>,
              AsyncValue<AppLockState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
