import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/logger/app_logger.dart';
import '../data/assets_remote_source.dart';
import '../models/asset.dart';
import 'transactions_controller.dart';

part 'assets_controller.g.dart';

/// State aset — padanan `assetStore` di web.
class AssetsState {
  const AssetsState({
    this.items = const [],
    this.loading = true,
    this.error,
    this.searchQuery = '',
  });

  final List<Asset> items;
  final bool loading;
  final String? error;
  final String searchQuery;

  List<Asset> get filtered {
    final q = searchQuery.trim().toLowerCase();
    if (q.isEmpty) return items;
    return items.where((a) {
      return a.name.toLowerCase().contains(q) ||
          a.type.toLowerCase().contains(q);
    }).toList();
  }

  AssetsState copyWith({
    List<Asset>? items,
    bool? loading,
    String? error,
    String? searchQuery,
  }) => AssetsState(
    items: items ?? this.items,
    loading: loading ?? this.loading,
    error: error ?? this.error,
    searchQuery: searchQuery ?? this.searchQuery,
  );
}

@Riverpod(keepAlive: true)
class AssetsController extends _$AssetsController {
  @override
  AssetsState build() {
    // Defer ke microtask: membaca `state` di dalam `build()` (riverpod 3)
    // melempar "uninitialized provider" karena state belum di-commit.
    Future.microtask(load);
    return const AssetsState();
  }

  Future<void>? _inFlight;

  /// Load aset dari server. Fire-and-forget — tidak memblokir frame.
  ///
  /// Panggilan beruntun saat startup (microtask dari `build()` + bootstrap)
  /// di-dedupe: jika sudah ada load berjalan, panggilan berikut menunggu
  /// load tersebut tanpa mengirim query ganda.
  Future<void> load() {
    final pending = _inFlight;
    if (pending != null) return pending;
    state = state.copyWith(loading: true, error: null);
    final future = _fetch();
    _inFlight = future;
    future.whenComplete(() {
      if (_inFlight == future) _inFlight = null;
    });
    return future;
  }

  Future<void> _fetch() async {
    try {
      final items = await ref.read(assetsRemoteSourceProvider).assets();
      if (!ref.mounted) return;
      state = state.copyWith(items: items, loading: false);
      AppLogger.instance.success(
        'assets dimuat (${items.length})',
        tag: 'AssetsController',
      );
    } catch (e) {
      if (!ref.mounted) return;
      AppLogger.instance.error(
        'Gagal load aset',
        tag: 'AssetsController',
        error: e,
      );
      state = state.copyWith(loading: false, error: _msg(e));
    }
  }

  void setSearch(String query) => state = state.copyWith(searchQuery: query);

  Future<bool> create({
    required String name,
    required String type,
    required String balance,
  }) async {
    try {
      final created = await ref
          .read(assetsRemoteSourceProvider)
          .create(name: name, type: type, balance: balance);
      if (!ref.mounted) return true;
      state = state.copyWith(items: [created, ...state.items]);
      return true;
    } catch (e) {
      if (ref.mounted) state = state.copyWith(error: _msg(e));
      return false;
    }
  }

  Future<bool> update(
    String id, {
    String? name,
    String? type,
    String? balance,
  }) async {
    try {
      final updated = await ref
          .read(assetsRemoteSourceProvider)
          .update(id, name: name, type: type, balance: balance);
      if (!ref.mounted) return true;
      state = state.copyWith(
        items: state.items.map((a) => a.id == id ? updated : a).toList(),
      );
      return true;
    } catch (e) {
      if (ref.mounted) state = state.copyWith(error: _msg(e));
      return false;
    }
  }

  Future<bool> remove(String name) async {
    try {
      final ok = await ref.read(assetsRemoteSourceProvider).delete(name);
      if (ok && ref.mounted) {
        state = state.copyWith(
          items: state.items.where((a) => a.name != name).toList(),
        );
      }
      return ok;
    } catch (e) {
      if (ref.mounted) state = state.copyWith(error: _msg(e));
      return false;
    }
  }

  Future<bool> addBalance(String assetId, String amount) async {
    try {
      final updated = await ref
          .read(assetsRemoteSourceProvider)
          .addBalance(assetId, amount);
      if (!ref.mounted) return true;
      state = state.copyWith(
        items: state.items.map((a) => a.id == assetId ? updated : a).toList(),
      );
      return true;
    } catch (e) {
      if (ref.mounted) state = state.copyWith(error: _msg(e));
      return false;
    }
  }

  static String _msg(Object e) => e is Exception ? e.toString() : '$e';

  Future<bool> swapBalance(
    String fromAssetId,
    String toAssetId,
    String amount,
  ) async {
    try {
      final result = await ref
          .read(assetsRemoteSourceProvider)
          .swapBalance(fromAssetId, toAssetId, amount);
      if (!ref.mounted) return true;
      state = state.copyWith(
        items: state.items.map((a) {
          if (a.id == result.from.id) return result.from;
          if (a.id == result.to.id) return result.to;
          return a;
        }).toList(),
      );
      ref.invalidate(transactionsControllerProvider);
      return true;
    } catch (e) {
      if (ref.mounted) state = state.copyWith(error: _msg(e));
      return false;
    }
  }
}
