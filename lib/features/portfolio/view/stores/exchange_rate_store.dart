import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:cx_dompetqiu/core/logger/app_logger.dart';
import 'package:cx_dompetqiu/features/portfolio/domain/models/exchange_rate.dart';
import 'package:cx_dompetqiu/features/portfolio/view/stores/exchange_rate_repository_provider.dart';

part 'generated/exchange_rate_store.g.dart';

/// Store nilai tukar aktif.
///
/// Rate di-fetch dari sumber global (Frankfurter) dan dipakai UI untuk
/// konversi tampilan nilai portofolio ke mata uang lain.
@Riverpod(keepAlive: true)
class ExchangeRateStore extends _$ExchangeRateStore {
  final AppLogger _log = AppLogger.instance;

  @override
  Future<ExchangeRate> build() async {
    final repo = ref.watch(exchangeRateRepositoryProvider);
    return repo.getRates('USD');
  }

  /// Refresh rate dari server (default base USD).
  Future<void> refresh({String baseCurrency = 'USD'}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(exchangeRateRepositoryProvider);
      return repo.getRates(baseCurrency);
    });
    if (state.hasError) {
      _log.error(
        'Refresh exchange rates gagal',
        tag: 'ExchangeRateStore',
        error: state.error,
        stackTrace: state.stackTrace,
      );
    }
  }

  /// Konversi [amount] dari [from] ke [to] memakai rate aktif.
  ///
  /// Bila rate belum termuat atau [to] tidak tersedia, mengembalikan
  /// [amount] apa adanya (fallback aman).
  double convert(double amount, String from, String to) {
    final rate = state.value;
    if (rate == null || from.toUpperCase() == to.toUpperCase()) return amount;
    final toRate = rate.rates[to.toUpperCase()];
    if (toRate == null) return amount;
    return amount * toRate;
  }
}
