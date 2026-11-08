import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/exchange_rate.freezed.dart';

/// Model nilai tukar mata uang (exchange rate).
///
/// Berisi rate dari [base] ke semua [rates] yang di-fetch dari sumber eksternal.
/// Digunakan untuk konversi nilai portofolio antar mata uang.
@freezed
abstract class ExchangeRate with _$ExchangeRate {
  const factory ExchangeRate({
    required String base,
    required Map<String, double> rates,
    required DateTime date,
  }) = _ExchangeRate;
}
