import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/logger/app_logger.dart';
import '../data/inventory_remote_source.dart';
import '../models/product.dart';

part 'inventory_controller.g.dart';

/// State inventory — padanan `inventoryStore` di web.
class InventoryState {
  const InventoryState({
    this.items = const [],
    this.loading = true,
    this.error,
    this.searchQuery = '',
  });

  final List<Product> items;
  final bool loading;
  final String? error;
  final String searchQuery;

  List<Product> get filtered {
    final q = searchQuery.trim().toLowerCase();
    if (q.isEmpty) return items;
    return items.where((p) => p.name.toLowerCase().contains(q)).toList();
  }

  int get totalItems => items.length;

  /// Total nilai harga jual (padanan `totalValue` di web).
  num get totalValue => items.fold<num>(0, (sum, p) => sum + p.price);

  /// Estimasi pendapatan (harga jual - modal).
  num get estimateRevenue =>
      items.fold<num>(0, (sum, p) => sum + (p.price - (p.capital ?? 0)));

  InventoryState copyWith({
    List<Product>? items,
    bool? loading,
    String? error,
    String? searchQuery,
  }) => InventoryState(
    items: items ?? this.items,
    loading: loading ?? this.loading,
    error: error ?? this.error,
    searchQuery: searchQuery ?? this.searchQuery,
  );
}

@Riverpod(keepAlive: true)
class InventoryController extends _$InventoryController {
  @override
  InventoryState build() {
    // Defer ke microtask: membaca `state` di dalam `build()` (riverpod 3)
    // melempar "uninitialized provider" karena state belum di-commit.
    Future.microtask(load);
    return const InventoryState();
  }

  Future<void>? _inFlight;

  /// Load produk dari server. Fire-and-forget — tidak memblokir frame.
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
      final items = await ref.read(inventoryRemoteSourceProvider).products();
      if (!ref.mounted) return;
      state = state.copyWith(items: items, loading: false);
      AppLogger.instance.success(
        'products dimuat (${items.length})',
        tag: 'InventoryController',
      );
    } catch (e) {
      if (!ref.mounted) return;
      AppLogger.instance.error(
        'Gagal load inventory',
        tag: 'InventoryController',
        error: e,
      );
      state = state.copyWith(loading: false, error: _msg(e));
    }
  }

  void setSearch(String query) => state = state.copyWith(searchQuery: query);

  Future<bool> create({
    required String name,
    String? description,
    required num price,
    num? capital,
    int stock = 0,
    bool trackStock = false,
  }) async {
    try {
      final created = await ref
          .read(inventoryRemoteSourceProvider)
          .create(
            name: name,
            description: description,
            price: price,
            capital: capital,
            stock: stock,
            trackStock: trackStock,
          );
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
    String? description,
    num? price,
    num? capital,
    int? stock,
    bool? trackStock,
  }) async {
    try {
      final updated = await ref
          .read(inventoryRemoteSourceProvider)
          .update(
            id,
            name: name,
            description: description,
            price: price,
            capital: capital,
            stock: stock,
            trackStock: trackStock,
          );
      if (!ref.mounted) return true;
      state = state.copyWith(
        items: state.items.map((p) => p.id == id ? updated : p).toList(),
      );
      return true;
    } catch (e) {
      if (ref.mounted) state = state.copyWith(error: _msg(e));
      return false;
    }
  }

  Future<bool> remove(String id) async {
    try {
      final ok = await ref.read(inventoryRemoteSourceProvider).delete(id);
      if (ok && ref.mounted) {
        state = state.copyWith(
          items: state.items.where((p) => p.id != id).toList(),
        );
      }
      return ok;
    } catch (e) {
      if (ref.mounted) state = state.copyWith(error: _msg(e));
      return false;
    }
  }

  static String _msg(Object e) => e is Exception ? e.toString() : '$e';
}
