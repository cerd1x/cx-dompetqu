// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Router utama. Redirect ke `/auth` saat sesi tidak terautentikasi.
///
/// Tidak memakai `ref.watch` di dalam `redirect` karena perubahan state saat
/// navigasi berlangsung memicu re-run redirect di zona guard go_router dan
/// melempar `GoException: Bad state: Future already completed`. Dipakai
/// `ref.read` + `ref.listen` yang memanggil `router.refresh()` saat status
/// sesi berubah (pola resmi dari go_router + Riverpod).

@ProviderFor(appRouter)
final appRouterProvider = AppRouterProvider._();

/// Router utama. Redirect ke `/auth` saat sesi tidak terautentikasi.
///
/// Tidak memakai `ref.watch` di dalam `redirect` karena perubahan state saat
/// navigasi berlangsung memicu re-run redirect di zona guard go_router dan
/// melempar `GoException: Bad state: Future already completed`. Dipakai
/// `ref.read` + `ref.listen` yang memanggil `router.refresh()` saat status
/// sesi berubah (pola resmi dari go_router + Riverpod).

final class AppRouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  /// Router utama. Redirect ke `/auth` saat sesi tidak terautentikasi.
  ///
  /// Tidak memakai `ref.watch` di dalam `redirect` karena perubahan state saat
  /// navigasi berlangsung memicu re-run redirect di zona guard go_router dan
  /// melempar `GoException: Bad state: Future already completed`. Dipakai
  /// `ref.read` + `ref.listen` yang memanggil `router.refresh()` saat status
  /// sesi berubah (pola resmi dari go_router + Riverpod).
  AppRouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appRouterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appRouterHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return appRouter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$appRouterHash() => r'50a237642a6be1da610b07839f5323b36fe1bbf0';
