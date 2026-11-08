import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:dompetqu/core/logger/app_logger.dart';
import 'package:dompetqu/features/portfolio/adapters/datasources/exchange_rate_source.dart';
import 'package:dompetqu/features/portfolio/domain/models/exchange_rate.dart';
import 'package:dompetqu/features/portfolio/domain/models/exchange_rate_error.dart';

/// Adapter sumber nilai tukar dari API Frankfurter (ECB reference rates).
///
/// API: https://api.frankfurter.app
/// - Free, tanpa API key
/// - Data harian dari European Central Bank
/// - Mendukung ~30 mata uang utama dunia
class FrankfurterExchangeRateSource implements ExchangeRateSource {
  FrankfurterExchangeRateSource({http.Client? client})
    : _client = client ?? http.Client();

  final http.Client _client;
  AppLogger get _log => AppLogger.instance;

  static const String _baseUrl = 'https://api.frankfurter.app';

  @override
  String get name => 'frankfurter';

  @override
  Future<ExchangeRate> fetchRates(String baseCurrency) async {
    final upper = baseCurrency.toUpperCase();
    final uri = Uri.parse('$_baseUrl/latest?from=$upper');
    _log.debug('Fetch rates: $uri', tag: name);
    try {
      final response = await _client.get(
        uri,
        headers: {'accept': 'application/json'},
      );
      if (response.statusCode != 200) {
        throw ExchangeRateException(
          'HTTP ${response.statusCode}',
          source: name,
        );
      }
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final base = json['base'] as String? ?? upper;
      final ratesRaw = json['rates'] as Map<String, dynamic>? ?? {};
      final dateStr = json['date'] as String?;
      final rates = ratesRaw.map((k, v) => MapEntry(k, (v as num).toDouble()));
      if (rates.isEmpty) {
        throw ExchangeRateException('Rates kosong', source: name);
      }
      return ExchangeRate(
        base: base,
        rates: rates,
        date: dateStr != null ? DateTime.parse(dateStr) : DateTime.now(),
      );
    } on ExchangeRateException {
      rethrow;
    } catch (e) {
      _log.error('Fetch rates gagal', tag: name, error: e);
      throw ExchangeRateException('Gagal fetch rates', source: name, cause: e);
    }
  }

  @override
  Future<List<String>> supportedCurrencies() async {
    final uri = Uri.parse('$_baseUrl/currencies');
    _log.debug('Fetch currencies: $uri', tag: name);
    try {
      final response = await _client.get(
        uri,
        headers: {'accept': 'application/json'},
      );
      if (response.statusCode != 200) {
        throw ExchangeRateException(
          'HTTP ${response.statusCode}',
          source: name,
        );
      }
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return json.keys.map((e) => e.toString()).toList()..sort();
    } on ExchangeRateException {
      rethrow;
    } catch (e) {
      _log.error('Fetch currencies gagal', tag: name, error: e);
      throw ExchangeRateException(
        'Gagal fetch currencies',
        source: name,
        cause: e,
      );
    }
  }
}
