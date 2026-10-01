import 'package:flutter_test/flutter_test.dart';

import 'package:dompetqu/core/utils/formatters.dart';

void main() {
  group('formatMoney', () {
    test('formats IDR with no decimals', () {
      expect(formatMoney(1250000, 'IDR'), 'Rp 1.250.000');
    });

    test('rounds zero-decimal currency', () {
      expect(formatMoney(1250.5, 'IDR'), 'Rp 1.251');
    });

    test('formats decimal currency', () {
      expect(formatMoney(1250.5, 'USD'), r'$1,250.50');
    });

    test('falls back to USD for unknown currency', () {
      expect(formatMoney(100, 'XXX'), contains(r'$'));
    });
  });
}
