// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../app_lock_store.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Store untuk state & logika app lock.

@ProviderFor(AppLockStore)
final appLockStoreProvider = AppLockStoreProvider._();

/// Store untuk state & logika app lock.
final class AppLockStoreProvider
    extends $AsyncNotifierProvider<AppLockStore, AppLockState> {
  /// Store untuk state & logika app lock.
  AppLockStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLockStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLockStoreHash();

  @$internal
  @override
  AppLockStore create() => AppLockStore();
}

String _$appLockStoreHash() => r'5648c2c6735f76214dadc3a506b57ecf0470f88e';

/// Store untuk state & logika app lock.

abstract class _$AppLockStore extends $AsyncNotifier<AppLockState> {
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
