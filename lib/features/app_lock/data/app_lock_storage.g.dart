// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_lock_storage.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Persistensi lokal untuk pengaturan app lock.
/// PIN dan pola disimpan sebagai salted SHA-256 hash.

@ProviderFor(appLockStorage)
final appLockStorageProvider = AppLockStorageProvider._();

/// Persistensi lokal untuk pengaturan app lock.
/// PIN dan pola disimpan sebagai salted SHA-256 hash.

final class AppLockStorageProvider
    extends $FunctionalProvider<AppLockStorage, AppLockStorage, AppLockStorage>
    with $Provider<AppLockStorage> {
  /// Persistensi lokal untuk pengaturan app lock.
  /// PIN dan pola disimpan sebagai salted SHA-256 hash.
  AppLockStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLockStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLockStorageHash();

  @$internal
  @override
  $ProviderElement<AppLockStorage> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppLockStorage create(Ref ref) {
    return appLockStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppLockStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppLockStorage>(value),
    );
  }
}

String _$appLockStorageHash() => r'ea3b8728b5b32cfb0c9382507cef28b9d417b322';
