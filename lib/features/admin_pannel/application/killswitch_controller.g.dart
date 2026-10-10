// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'killswitch_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Kontrol kill switch: memuat daftar, mematikan, dan menghidupkan operation
/// GraphQL melalui endpoint REST `{baseUrl}/admin/killswitch`.

@ProviderFor(KillswitchController)
final killswitchControllerProvider = KillswitchControllerProvider._();

/// Kontrol kill switch: memuat daftar, mematikan, dan menghidupkan operation
/// GraphQL melalui endpoint REST `{baseUrl}/admin/killswitch`.
final class KillswitchControllerProvider
    extends $NotifierProvider<KillswitchController, KillswitchState> {
  /// Kontrol kill switch: memuat daftar, mematikan, dan menghidupkan operation
  /// GraphQL melalui endpoint REST `{baseUrl}/admin/killswitch`.
  KillswitchControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'killswitchControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$killswitchControllerHash();

  @$internal
  @override
  KillswitchController create() => KillswitchController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(KillswitchState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<KillswitchState>(value),
    );
  }
}

String _$killswitchControllerHash() =>
    r'bbf3842d5a49749fdc6d876f6037be2fb222a887';

/// Kontrol kill switch: memuat daftar, mematikan, dan menghidupkan operation
/// GraphQL melalui endpoint REST `{baseUrl}/admin/killswitch`.

abstract class _$KillswitchController extends $Notifier<KillswitchState> {
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
