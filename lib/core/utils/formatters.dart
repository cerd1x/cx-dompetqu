import 'package:intl/intl.dart';

/// Padanan `src/lib/utils/format_money.ts` di web.
const Map<String, String> currencyLocaleMap = {
  'IDR': 'id_ID',
  'USD': 'en_US',
  'GBP': 'en_GB',
  'JPY': 'ja_JP',
  'CNY': 'zh_CN',
  'SGD': 'en_SG',
  'MYR': 'ms_MY',
  'EUR': 'de_DE',
};

const Map<String, String> _currencySymbols = {
  'IDR': 'Rp ',
  'USD': r'$',
  'GBP': '£',
  'JPY': '¥',
  'CNY': '¥',
  'SGD': r'S$',
  'MYR': 'RM ',
  'EUR': '€',
};

/// Mata uang tanpa angka desimal (mirip ICU di browser).
const Set<String> _zeroDecimalCurrencies = {'IDR', 'JPY'};

/// Format angka sebagai mata uang, mis. `Rp 1.250.000` untuk IDR.
String formatMoney(num amount, String currencyCode) {
  final code = currencyCode.toUpperCase();
  final locale = currencyLocaleMap[code];
  final symbol = _currencySymbols[code] ?? r'$';
  final pattern = _zeroDecimalCurrencies.contains(code) ? '#,##0' : '#,##0.00';
  final number = NumberFormat(pattern, locale ?? 'en_US').format(amount);
  return '$symbol$number';
}

/// Format angka biasa tanpa simbol, mis. `1.250.000`.
String formatNumber(num amount, {String? locale}) {
  return NumberFormat.decimalPattern(locale).format(amount);
}
