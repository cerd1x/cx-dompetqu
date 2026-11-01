// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../failed_payments_store.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Payment berstatus `failed` pada [month] — query langsung ke backend
/// (`paymentsByStatus(status: failed)`), bukan filter transaksi lokal.
///
/// Read-only di tingkat daftar: retry dan report dilakukan dari layar detail
/// (`DetailPaymentFailedView`). Provider auto-dispose, jadi daftar diambil
/// ulang setiap tab Failed dibuka atau bulan diganti.

@ProviderFor(failedPayments)
final failedPaymentsProvider = FailedPaymentsFamily._();

/// Payment berstatus `failed` pada [month] — query langsung ke backend
/// (`paymentsByStatus(status: failed)`), bukan filter transaksi lokal.
///
/// Read-only di tingkat daftar: retry dan report dilakukan dari layar detail
/// (`DetailPaymentFailedView`). Provider auto-dispose, jadi daftar diambil
/// ulang setiap tab Failed dibuka atau bulan diganti.

final class FailedPaymentsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Payment>>,
          List<Payment>,
          FutureOr<List<Payment>>
        >
    with $FutureModifier<List<Payment>>, $FutureProvider<List<Payment>> {
  /// Payment berstatus `failed` pada [month] — query langsung ke backend
  /// (`paymentsByStatus(status: failed)`), bukan filter transaksi lokal.
  ///
  /// Read-only di tingkat daftar: retry dan report dilakukan dari layar detail
  /// (`DetailPaymentFailedView`). Provider auto-dispose, jadi daftar diambil
  /// ulang setiap tab Failed dibuka atau bulan diganti.
  FailedPaymentsProvider._({
    required FailedPaymentsFamily super.from,
    required DateTime super.argument,
  }) : super(
         retry: null,
         name: r'failedPaymentsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$failedPaymentsHash();

  @override
  String toString() {
    return r'failedPaymentsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Payment>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Payment>> create(Ref ref) {
    final argument = this.argument as DateTime;
    return failedPayments(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FailedPaymentsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$failedPaymentsHash() => r'f98492b9bb2b415954996edad71c6cd12f879499';

/// Payment berstatus `failed` pada [month] — query langsung ke backend
/// (`paymentsByStatus(status: failed)`), bukan filter transaksi lokal.
///
/// Read-only di tingkat daftar: retry dan report dilakukan dari layar detail
/// (`DetailPaymentFailedView`). Provider auto-dispose, jadi daftar diambil
/// ulang setiap tab Failed dibuka atau bulan diganti.

final class FailedPaymentsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Payment>>, DateTime> {
  FailedPaymentsFamily._()
    : super(
        retry: null,
        name: r'failedPaymentsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Payment berstatus `failed` pada [month] — query langsung ke backend
  /// (`paymentsByStatus(status: failed)`), bukan filter transaksi lokal.
  ///
  /// Read-only di tingkat daftar: retry dan report dilakukan dari layar detail
  /// (`DetailPaymentFailedView`). Provider auto-dispose, jadi daftar diambil
  /// ulang setiap tab Failed dibuka atau bulan diganti.

  FailedPaymentsProvider call(DateTime month) =>
      FailedPaymentsProvider._(argument: month, from: this);

  @override
  String toString() => r'failedPaymentsProvider';
}
