import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:cx_dompetqiu/features/portfolio/adapters/datasources/exchange_rate_source.dart';
import 'package:cx_dompetqiu/features/portfolio/adapters/datasources/frankfurter_source.dart';
import 'package:cx_dompetqiu/features/portfolio/adapters/repositories/exchange_rate_repository_impl.dart';
import 'package:cx_dompetqiu/features/portfolio/domain/models/exchange_rate.dart';
import 'package:cx_dompetqiu/features/portfolio/domain/models/exchange_rate_error.dart';

class _FakeSource implements ExchangeRateSource {
  _FakeSource({Map<String, double>? rates, this.fail = false})
    : rates = rates ?? {'IDR': 16000, 'EUR': 0.9};

  final Map<String, double> rates;
  final bool fail;
  int fetchCalls = 0;

  @override
  String get name => 'fake';

  @override
  Future<ExchangeRate> fetchRates(String baseCurrency) async {
    fetchCalls++;
    if (fail) throw const ExchangeRateException('gagal', source: 'fake');
    return ExchangeRate(
      base: baseCurrency.toUpperCase(),
      rates: rates,
      date: DateTime.utc(2026, 1, 1),
    );
  }

  @override
  Future<List<String>> supportedCurrencies() async => rates.keys.toList();
}

void main() {
  group('Skenario konversi nilai tukar', () {
    test('mata uang sama langsung dikembalikan tanpa fetch', () async {
      final source = _FakeSource();
      final repository = ExchangeRateRepositoryImpl(source);

      final result = await repository.convert(100, from: 'usd', to: 'USD');

      expect(result, 100);
      expect(source.fetchCalls, 0);
    });

    test('konversi memakai rate tujuan', () async {
      final source = _FakeSource(rates: {'IDR': 16000});
      final repository = ExchangeRateRepositoryImpl(source);

      final result = await repository.convert(2, from: 'usd', to: 'idr');

      expect(result, 32000);
      expect(source.fetchCalls, 1);
    });

    test('rate tujuan tidak tersedia melempar ExchangeRateException', () async {
      final repository = ExchangeRateRepositoryImpl(
        _FakeSource(rates: {'EUR': 0.9}),
      );

      await expectLater(
        repository.convert(1, from: 'USD', to: 'JPY'),
        throwsA(
          isA<ExchangeRateException>()
              .having((e) => e.source, 'source', 'fake')
              .having((e) => e.message, 'message', contains('JPY')),
        ),
      );
    });

    test('getRates mendelegasikan ke sumber', () async {
      final source = _FakeSource(rates: {'IDR': 16000});

      final rate = await ExchangeRateRepositoryImpl(source).getRates('usd');

      expect(rate.base, 'USD');
      expect(rate.rates['IDR'], 16000);
      expect(rate.date, DateTime.utc(2026, 1, 1));
    });

    test('error sumber diteruskan apa adanya', () async {
      final repository = ExchangeRateRepositoryImpl(_FakeSource(fail: true));

      await expectLater(
        repository.getRates('USD'),
        throwsA(isA<ExchangeRateException>()),
      );
    });
  });

  group('Skenario adapter Frankfurter', () {
    test('fetchRates memparse base, rates, dan tanggal', () async {
      late Uri captured;
      final source = FrankfurterExchangeRateSource(
        client: MockClient((request) async {
          captured = request.url;
          return http.Response(
            jsonEncode({
              'base': 'USD',
              'date': '2026-03-04',
              'rates': {'IDR': 16000, 'EUR': 0.9},
            }),
            200,
          );
        }),
      );

      final rate = await source.fetchRates('usd');

      expect(captured.host, 'api.frankfurter.app');
      expect(captured.queryParameters['from'], 'USD');
      expect(rate.base, 'USD');
      expect(rate.rates['IDR'], 16000);
      expect(rate.rates['EUR'], 0.9);
      expect(rate.date, DateTime(2026, 3, 4));
    });

    test('rates kosong dianggap error', () async {
      final source = FrankfurterExchangeRateSource(
        client: MockClient(
          (_) async => http.Response(
            jsonEncode({'base': 'USD', 'rates': {}}),
            200,
          ),
        ),
      );

      await expectLater(
        source.fetchRates('USD'),
        throwsA(
          isA<ExchangeRateException>().having(
            (e) => e.message,
            'message',
            contains('kosong'),
          ),
        ),
      );
    });

    test('HTTP non-200 dilempar sebagai ExchangeRateException', () async {
      final source = FrankfurterExchangeRateSource(
        client: MockClient((_) async => http.Response('nope', 503)),
      );

      await expectLater(
        source.fetchRates('USD'),
        throwsA(
          isA<ExchangeRateException>()
              .having((e) => e.source, 'source', 'frankfurter')
              .having((e) => e.message, 'message', contains('503')),
        ),
      );
    });

    test('body rusak dibungkus menjadi ExchangeRateException', () async {
      final source = FrankfurterExchangeRateSource(
        client: MockClient((_) async => http.Response('bukan-json', 200)),
      );

      await expectLater(
        source.fetchRates('USD'),
        throwsA(
          isA<ExchangeRateException>().having(
            (e) => e.message,
            'message',
            contains('Gagal fetch'),
          ),
        ),
      );
    });

    test('supportedCurrencies mengembalikan kode terurut', () async {
      final source = FrankfurterExchangeRateSource(
        client: MockClient(
          (_) async => http.Response(
            jsonEncode({'USD': 'US Dollar', 'EUR': 'Euro', 'IDR': 'Rupiah'}),
            200,
          ),
        ),
      );

      expect(await source.supportedCurrencies(), ['EUR', 'IDR', 'USD']);
    });
  });
}
