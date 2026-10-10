// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'killswitch_remote_source.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_KillswitchEntry _$KillswitchEntryFromJson(Map<String, dynamic> json) =>
    _KillswitchEntry(
      operation: json['operation'] as String,
      reason: json['reason'] as String?,
      disabledAt: _parseDate(json['disabledAt']),
    );

Map<String, dynamic> _$KillswitchEntryToJson(_KillswitchEntry instance) =>
    <String, dynamic>{
      'operation': instance.operation,
      'reason': instance.reason,
      'disabledAt': instance.disabledAt?.toIso8601String(),
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Penyimpanan token admin yang diisi user (sementara, in-memory, tidak
/// di-persist). Dipakai sebagai nilai header `x-admin-token`.
///
/// Nanti bisa diganti dengan penyimpanan aman (mis. `flutter_secure_storage`).

@ProviderFor(KillswitchAdminTokenNotifier)
final killswitchAdminTokenProvider = KillswitchAdminTokenNotifierProvider._();

/// Penyimpanan token admin yang diisi user (sementara, in-memory, tidak
/// di-persist). Dipakai sebagai nilai header `x-admin-token`.
///
/// Nanti bisa diganti dengan penyimpanan aman (mis. `flutter_secure_storage`).
final class KillswitchAdminTokenNotifierProvider
    extends $NotifierProvider<KillswitchAdminTokenNotifier, String> {
  /// Penyimpanan token admin yang diisi user (sementara, in-memory, tidak
  /// di-persist). Dipakai sebagai nilai header `x-admin-token`.
  ///
  /// Nanti bisa diganti dengan penyimpanan aman (mis. `flutter_secure_storage`).
  KillswitchAdminTokenNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'killswitchAdminTokenProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$killswitchAdminTokenNotifierHash();

  @$internal
  @override
  KillswitchAdminTokenNotifier create() => KillswitchAdminTokenNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$killswitchAdminTokenNotifierHash() =>
    r'76c27624b0e4912910ed4a856b709392c237783d';

/// Penyimpanan token admin yang diisi user (sementara, in-memory, tidak
/// di-persist). Dipakai sebagai nilai header `x-admin-token`.
///
/// Nanti bisa diganti dengan penyimpanan aman (mis. `flutter_secure_storage`).

abstract class _$KillswitchAdminTokenNotifier extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Provider remote source kill switch.
///
/// Dibuat ulang setiap token berubah supaya request berikutnya langsung
/// memakai token terbaru. Client di-dispose saat provider dibuang.

@ProviderFor(killswitchRemoteSource)
final killswitchRemoteSourceProvider = KillswitchRemoteSourceProvider._();

/// Provider remote source kill switch.
///
/// Dibuat ulang setiap token berubah supaya request berikutnya langsung
/// memakai token terbaru. Client di-dispose saat provider dibuang.

final class KillswitchRemoteSourceProvider
    extends
        $FunctionalProvider<
          KillswitchRemoteSource,
          KillswitchRemoteSource,
          KillswitchRemoteSource
        >
    with $Provider<KillswitchRemoteSource> {
  /// Provider remote source kill switch.
  ///
  /// Dibuat ulang setiap token berubah supaya request berikutnya langsung
  /// memakai token terbaru. Client di-dispose saat provider dibuang.
  KillswitchRemoteSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'killswitchRemoteSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$killswitchRemoteSourceHash();

  @$internal
  @override
  $ProviderElement<KillswitchRemoteSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  KillswitchRemoteSource create(Ref ref) {
    return killswitchRemoteSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(KillswitchRemoteSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<KillswitchRemoteSource>(value),
    );
  }
}

String _$killswitchRemoteSourceHash() =>
    r'283ed4932272d19c28b49a1ae2bc43d9619fe7ca';
