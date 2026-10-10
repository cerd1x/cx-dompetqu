import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/logger/app_logger.dart';
import '../data/transactions_remote_source.dart';
import '../models/transaction.dart';
import '../models/transaction_page.dart';

part 'transactions_controller.freezed.dart';
part 'transactions_controller.g.dart';

/// Jumlah transaksi per halaman saat mode pagination aktif — cerminan
/// `DEFAULT_PAGE_SIZE` di `services/domain/transactions` (`transaction-page.model.ts`).
const int kTransactionsPageSize = 20;

/// State transaksi — padanan `transactionStore` di web.
@freezed
abstract class TransactionsState with _$TransactionsState {
  const factory TransactionsState({
    @Default([]) List<Transaction> items,
    @Default(true) bool loading,
    String? error,
    @Default(kTransactionsPageSize) int pageSize,
    String? nextCursor,
    @Default(false) bool hasMore,
    @Default(false) bool loadingMore,
  }) = _TransactionsState;
}

@Riverpod(keepAlive: true)
class TransactionsController extends _$TransactionsController {
  @override
  TransactionsState build() {
    // Defer ke microtask: membaca `state` di dalam `build()` (riverpod 3)
    // melempar "uninitialized provider" karena state belum di-commit.
    Future.microtask(load);
    return const TransactionsState();
  }

  Future<void>? _inFlight;

  /// Apakah [_inFlight] adalah load halaman (bukan daftar penuh).
  bool _inFlightPaged = false;

  /// Mode keyset aktif. Saat aktif, `load()` (bootstrap/retry) mewarisi mode
  /// ini dan daftar penuh yang masih in-flight dibuang, supaya tidak menimpa
  /// halaman yang sudah tampil.
  bool _paged = false;

  /// Apakah daftar sedang dimuat per halaman (bukan seluruhnya sekaligus).
  bool get isPaged => _paged;

  /// Muat transaksi dari server sesuai mode aktif.
  ///
  /// Mode penuh (default): ambil seluruh transaksi — dipakai layar yang butuh
  /// daftar lengkap.
  /// Mode pagination ([loadPage] aktif): muat ulang halaman pertama.
  ///
  /// Fire-and-forget — tidak memblokir frame. Panggilan beruntun saat startup
  /// (microtask dari `build()` + bootstrap) di-dedupe: jika sudah ada load
  /// berjalan, panggilan berikutnya menunggu load tersebut tanpa mengirim
  /// query ganda.
  Future<void> load() {
    if (_paged) return loadPage();
    return _deduped(_fetch, paged: false);
  }

  /// Muat **seluruh** transaksi sekali saja, matikan mode pagination, dan isi
  /// cache state dengan daftar lengkap — untuk konsumen yang butuh semua data.
  Future<void> loadAll() {
    _paged = false;
    if (_inFlight != null && _inFlightPaged) _inFlight = null;
    return _deduped(_fetch, paged: false);
  }

  /// Pastikan [TransactionsState.items] memuat **seluruh** transaksi; no-op bila
  /// daftar sudah dimuat penuh. Dipakai layar yang butuh data lengkap
  /// saat list utama memakai pagination keyset.
  Future<void> ensureAllLoaded() {
    if (!_paged) return Future.value();
    return loadAll();
  }

  Future<void> _deduped(Future<void> Function() task, {required bool paged}) {
    final pending = _inFlight;
    if (pending != null) return pending;
    state = state.copyWith(loading: true, error: null, loadingMore: false);
    final future = task();
    _inFlight = future;
    _inFlightPaged = paged;
    future.whenComplete(() {
      if (_inFlight == future) {
        _inFlight = null;
        _inFlightPaged = false;
      }
    });
    return future;
  }

  Future<void> _fetch() async {
    try {
      final items = await ref
          .read(transactionsRemoteSourceProvider)
          .transactions();
      if (!ref.mounted) return;
      // Sesi pagination yang dimulai selagi request ini berjalan lebih
      // baru — jangan ditimpa dengan daftar penuh.
      if (_paged) return;
      state = state.copyWith(
        items: items,
        loading: false,
        // Daftar dimuat penuh -> mode pagination nonaktif.
        nextCursor: null,
        hasMore: false,
        loadingMore: false,
      );
      AppLogger.instance.success(
        'transactions dimuat (${items.length})',
        tag: 'TransactionsController',
      );
    } catch (e) {
      if (!ref.mounted || _paged) return;
      AppLogger.instance.error(
        'Gagal load transaksi',
        tag: 'TransactionsController',
        error: e,
      );
      state = state.copyWith(loading: false, error: _msg(e));
    }
  }

  /// Muat **halaman pertama** dan aktifkan mode pagination keyset —
  /// padanan `transactionsPage()` di `transactions.composition.ts`.
  ///
  /// Bedanya dengan [loadAll]: [loadAll] mengambil seluruh transaksi sekaligus,
  /// sedangkan [loadPage] hanya mengambil [pageSize] data terbaru dan menyimpan
  /// cursor untuk [loadMore]. Konsumen yang butuh transaksi di luar halaman
  /// yang tampil harus memanggil [loadAll] lebih dulu.
  ///
  /// Aman dipanggil di `initState`: request daftar penuh yang sudah berjalan
  /// (microtask dari `build()`/bootstrap) tidak akan menimpa halaman ini.
  Future<void> loadPage({int pageSize = kTransactionsPageSize}) {
    _paged = true;
    // Buang hanya request daftar penuh yang sedang berjalan; load halaman
    // yang sedang berjalan dipakai bersama (dedupe).
    if (_inFlight != null && !_inFlightPaged) _inFlight = null;
    return _deduped(() => _fetchPage(pageSize), paged: true);
  }

  Future<void> _fetchPage(int pageSize) async {
    try {
      final page = await ref
          .read(transactionsRemoteSourceProvider)
          .transactionsPage(first: pageSize);
      if (!ref.mounted) return;
      state = state.copyWith(
        items: page.items,
        loading: false,
        pageSize: pageSize,
        nextCursor: page.hasNextPage ? page.nextCursor : null,
        hasMore: page.hasNextPage,
      );
      AppLogger.instance.success(
        'halaman transaksi dimuat (${page.items.length})',
        tag: 'TransactionsController',
      );
    } catch (e) {
      if (!ref.mounted) return;
      AppLogger.instance.error(
        'Gagal load halaman transaksi',
        tag: 'TransactionsController',
        error: e,
      );
      state = state.copyWith(
        loading: false,
        nextCursor: null,
        hasMore: false,
        error: _msg(e),
      );
    }
  }

  /// Ambil halaman berikutnya dan append ke [TransactionsState.items].
  ///
  /// No-op (return `false`) bila sedang loading, belum ada sesi pagination
  /// ([TransactionsState.hasMore] false / [TransactionsState.nextCursor] null), atau
  /// cursor habis dipakai — jadi aman dipanggil dari `build`/`onScroll`.
  ///
  /// Kegagalan tidak mereset daftar yang sudah tampil: error hanya log dan
  /// [TransactionsState.error] diisi kalau belum ada satu pun transaksi, agar layar
  /// tidak berubah jadi ErrorState karena gagal load halaman berikutnya.
  Future<bool> loadMore() {
    if (state.loading || state.loadingMore || !state.hasMore) {
      return Future.value(false);
    }
    final cursor = state.nextCursor;
    if (cursor == null || cursor.isEmpty) return Future.value(false);
    state = state.copyWith(loadingMore: true);
    return _loadMore(cursor);
  }

  Future<bool> _loadMore(String cursor) async {
    try {
      final page = await ref
          .read(transactionsRemoteSourceProvider)
          .transactionsPage(first: state.pageSize, after: cursor);
      if (!ref.mounted) return false;
      final seen = state.items.map((c) => c.id).toSet();
      state = state.copyWith(
        loadingMore: false,
        items: [
          ...state.items,
          ...page.items.where((c) => !seen.contains(c.id)),
        ],
        nextCursor: page.hasNextPage ? page.nextCursor : null,
        hasMore: page.hasNextPage,
      );
      AppLogger.instance.success(
        'halaman transaksi berikutnya dimuat (${page.items.length})',
        tag: 'TransactionsController',
      );
      return true;
    } catch (e) {
      if (!ref.mounted) return false;
      AppLogger.instance.error(
        'Gagal load halaman transaksi berikutnya',
        tag: 'TransactionsController',
        error: e,
      );
      state = state.copyWith(
        loadingMore: false,
        error: state.items.isEmpty ? _msg(e) : null,
      );
      return false;
    }
  }

  static String _msg(Object e) => e is Exception ? e.toString() : '$e';
}
