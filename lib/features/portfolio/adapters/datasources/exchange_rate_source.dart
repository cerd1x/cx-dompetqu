import 'package:cx_dompetqiu/features/portfolio/domain/models/exchange_rate.dart';
import 'package:cx_dompetqiu/features/portfolio/domain/models/exchange_rate_error.dart';

/// Kontrak adapter sumber nilai tukar mata uang global.
///
/// Setiap penyedia data kurs diimplementasikan sebagai adapter yang
/// mengimplementasikan interface ini, sehingga sumber dapat diganti
/// tanpa mengubah lapisan domain / UI.
abstract interface class ExchangeRateSource {
  /// Identitas adapter (untuk logging & diagnosa), mis. `frankfurter`.
  String get name;

  /// Mengambil rate dari [baseCurrency] ke semua mata uang yang didukung
  /// sumber ini.
  ///
  /// Throws [ExchangeRateException] bila request gagal atau respons invalid.
  Future<ExchangeRate> fetchRates(String baseCurrency);

  /// Daftar kode mata uang yang didukung sumber ini.
  ///
  /// Kosong berarti sumber tidak membatasi (mengikuti respons server).
  Future<List<String>> supportedCurrencies();
}
