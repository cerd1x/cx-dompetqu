// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../killswitch_store.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Kontrol kill switch: memuat daftar, mematikan, dan menghidupkan operation
/// GraphQL melalui endpoint REST `{baseUrl}/admin/killswitch`.

@ProviderFor(KillswitchStore)
final killswitchStoreProvider = KillswitchStoreProvider._();

/// Kontrol kill switch: memuat daftar, mematikan, dan menghidupkan operation
/// GraphQL melalui endpoint REST `{baseUrl}/admin/killswitch`.
final class KillswitchStoreProvider
    extends $NotifierProvider<KillswitchStore, KillswitchState> {
  /// Kontrol kill switch: memuat daftar, mematikan, dan menghidupkan operation
  /// GraphQL melalui endpoint REST `{baseUrl}/admin/killswitch`.
  KillswitchStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'killswitchStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$killswitchStoreHash();

  @$internal
  @override
  KillswitchStore create() => KillswitchStore();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(KillswitchState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<KillswitchState>(value),
    );
  }
}

String _$killswitchStoreHash() => r'02a944c9f9ee26ac63fc1fbc189c58da2a6e8e04';

/// Kontrol kill switch: memuat daftar, mematikan, dan menghidupkan operation
/// GraphQL melalui endpoint REST `{baseUrl}/admin/killswitch`.

abstract class _$KillswitchStore extends $Notifier<KillswitchState> {
  KillswitchState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<KillswitchState, KillswitchState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<KillswitchState, KillswitchState>,
              KillswitchState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
