// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../payments_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI port payment — memakai generator agar nama provider konsisten dengan
/// fitur lain. `keepAlive` dipertahankan seperti provider manual sebelumnya:
/// repository hanya membungkus `paymentsRemoteSourceProvider` (juga keepAlive)
/// dan tidak menyimpan state, jadi tidak perlu dibangun ulang tiap layar.

@ProviderFor(paymentsRepository)
final paymentsRepositoryProvider = PaymentsRepositoryProvider._();

/// DI port payment — memakai generator agar nama provider konsisten dengan
/// fitur lain. `keepAlive` dipertahankan seperti provider manual sebelumnya:
/// repository hanya membungkus `paymentsRemoteSourceProvider` (juga keepAlive)
/// dan tidak menyimpan state, jadi tidak perlu dibangun ulang tiap layar.

final class PaymentsRepositoryProvider
    extends
        $FunctionalProvider<
          PaymentsRepository,
          PaymentsRepository,
          PaymentsRepository
        >
    with $Provider<PaymentsRepository> {
  /// DI port payment — memakai generator agar nama provider konsisten dengan
  /// fitur lain. `keepAlive` dipertahankan seperti provider manual sebelumnya:
  /// repository hanya membungkus `paymentsRemoteSourceProvider` (juga keepAlive)
  /// dan tidak menyimpan state, jadi tidak perlu dibangun ulang tiap layar.
  PaymentsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'paymentsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$paymentsRepositoryHash();

  @$internal
  @override
  $ProviderElement<PaymentsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PaymentsRepository create(Ref ref) {
    return paymentsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PaymentsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PaymentsRepository>(value),
    );
  }
}

String _$paymentsRepositoryHash() =>
    r'35e1d5222821f0d5be64d57f23cefd2ffd4dce14';
