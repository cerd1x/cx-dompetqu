import 'package:dompetqu/core/logger/app_logger.dart';
import 'package:dompetqu/features/portfolio/adapters/datasources/exchange_rate_source.dart';
import 'package:dompetqu/features/portfolio/domain/models/exchange_rate.dart';
import 'package:dompetqu/features/portfolio/domain/models/exchange_rate_error.dart';
import 'package:dompetqu/features/portfolio/domain/repositories/exchange_rate_repository.dart';

/// Implementasi [ExchangeRateRepository] yang mendelegasikan ke [ExchangeRateSource].
///
/// Lapisan ini menyederhanakan konversi dan caching di masa depan.
class ExchangeRateRepositoryImpl implements ExchangeRateRepository {
  const ExchangeRateRepositoryImpl(this._source);

  final ExchangeRateSource _source;
  final AppLogger _log = AppLogger.instance;

  @override
  Future<ExchangeRate> getRates(String baseCurrency) async {
    _log.debug(
      'getRates($baseCurrency) via ${_source.name}',
      tag: 'ExchangeRateRepo',
    );
    return _source.fetchRates(baseCurrency);
  }

  @override
  Future<double> convert(
    double amount, {
    required String from,
    required String to,
  }) async {
    if (from.toUpperCase() == to.toUpperCase()) return amount;

    final rate = await _source.fetchRates(from.toUpperCase());
    final toRate = rate.rates[to.toUpperCase()];
    if (toRate == null) {
      _log.warn(
        'Rate $to tidak tersedia untuk base $from',
        tag: 'ExchangeRateRepo',
      );
      throw ExchangeRateException(
        'Rate $to tidak tersedia',
        source: _source.name,
      );
    }
    return amount * toRate;
  }
}
