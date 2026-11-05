// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../bookkeeping_store.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Store tab Bookkeeping — bulan/filter aktif + data turunan buku besar.
///
/// Sumber data tetap `transactionsStoreProvider`; store ini menontonnya supaya
/// ringkasan ikut segar setelah transaksi ditambah/diubah. Pagination dimatikan
/// lewat `ensureAllLoaded()` karena ringkasan bulanan butuh transaksi di luar
/// halaman yang tampil.

@ProviderFor(BookkeepingStore)
final bookkeepingStoreProvider = BookkeepingStoreProvider._();

/// Store tab Bookkeeping — bulan/filter aktif + data turunan buku besar.
///
/// Sumber data tetap `transactionsStoreProvider`; store ini menontonnya supaya
/// ringkasan ikut segar setelah transaksi ditambah/diubah. Pagination dimatikan
/// lewat `ensureAllLoaded()` karena ringkasan bulanan butuh transaksi di luar
/// halaman yang tampil.
final class BookkeepingStoreProvider
    extends $NotifierProvider<BookkeepingStore, BookkeepingState> {
  /// Store tab Bookkeeping — bulan/filter aktif + data turunan buku besar.
  ///
  /// Sumber data tetap `transactionsStoreProvider`; store ini menontonnya supaya
  /// ringkasan ikut segar setelah transaksi ditambah/diubah. Pagination dimatikan
  /// lewat `ensureAllLoaded()` karena ringkasan bulanan butuh transaksi di luar
  /// halaman yang tampil.
  BookkeepingStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookkeepingStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookkeepingStoreHash();

  @$internal
  @override
  BookkeepingStore create() => BookkeepingStore();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BookkeepingState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BookkeepingState>(value),
    );
  }
}

String _$bookkeepingStoreHash() => r'9763f5dd7f14974cc7e65ce03924be25a6c361bb';

/// Store tab Bookkeeping — bulan/filter aktif + data turunan buku besar.
///
/// Sumber data tetap `transactionsStoreProvider`; store ini menontonnya supaya
/// ringkasan ikut segar setelah transaksi ditambah/diubah. Pagination dimatikan
/// lewat `ensureAllLoaded()` karena ringkasan bulanan butuh transaksi di luar
/// halaman yang tampil.

abstract class _$BookkeepingStore extends $Notifier<BookkeepingState> {
  BookkeepingState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<BookkeepingState, BookkeepingState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BookkeepingState, BookkeepingState>,
              BookkeepingState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
