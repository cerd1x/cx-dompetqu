import 'package:cx_dompetqiu/features/portfolio/domain/models/exchange_rate.dart';

/// Kontrak repository untuk nilai tukar mata uang.
abstract interface class ExchangeRateRepository {
  /// Mengambil seluruh rate dari [baseCurrency].
  Future<ExchangeRate> getRates(String baseCurrency);

  /// Mengkonversi [amount] dari [from] ke [to].
  ///
  /// Bila rate untuk [to] tidak tersedia, mengembalikan [amount] apa adanya.
  Future<double> convert(
    double amount, {
    required String from,
    required String to,
  });
}
