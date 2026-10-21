import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/logger/app_logger.dart';
import '../domain/entities/statistics.dart';
import '../../dashboard/stores/home_repository_provider.dart';

part 'generated/statistics_store.g.dart';

/// State statistik dashboard — padanan bagian `assetStore.queryStatistics` di web.
class StatisticsState {
  const StatisticsState({
    this.statistics = const Statistics(),
    this.loading = true,
    this.error,
  });

  final Statistics statistics;
  final bool loading;
  final String? error;

  StatisticsState copyWith({
    Statistics? statistics,
    bool? loading,
    String? error,
  }) => StatisticsState(
    statistics: statistics ?? this.statistics,
    loading: loading ?? this.loading,
    error: error ?? this.error,
  );
}

@Riverpod(keepAlive: true)
class StatisticsStore extends _$StatisticsStore {
  @override
  StatisticsState build() {
    // Defer ke microtask: membaca `state` di dalam `build()` (riverpod 3)
    // melempar "uninitialized provider" karena state belum di-commit.
    Future.microtask(load);
    return const StatisticsState();
  }

  Future<void>? _inFlight;

  /// Load statistik dari server. Fire-and-forget — tidak memblokir frame.
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
      final statistics = await ref.read(homeRepositoryProvider).statistics();
      if (!ref.mounted) return;
      state = state.copyWith(statistics: statistics, loading: false);
      AppLogger.instance.success(
        'statistics dimuat',
        tag: 'StatisticsStore',
      );
    } catch (e) {
      if (!ref.mounted) return;
      AppLogger.instance.error(
        'Gagal load statistik',
        tag: 'StatisticsStore',
        error: e,
      );
      state = state.copyWith(loading: false, error: _msg(e));
    }
  }

  static String _msg(Object e) => e is Exception ? e.toString() : '$e';
}
