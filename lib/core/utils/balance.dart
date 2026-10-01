import 'formatters.dart';

/// Padanan `src/lib/balance.ts` di web — parse & format string "ISO_CODE VALUE".
///
/// Contoh: "IDR 20.000", "USD 100", "EUR -500".
class Balance {
  const Balance({required this.code, required this.value});

  final String code;
  final num value;

  static Balance parse(String raw) {
    final match = RegExp(
      r'^([A-Z]{3})\s+(-?[\d,]+(?:\.\d+)?)$',
    ).firstMatch(raw.trim());
    if (match == null) {
      throw FormatException(
        'Invalid balance format: "$raw". Expected "ISO_CODE VALUE" (e.g. "USD 100")',
      );
    }
    final value = num.tryParse(match.group(2)!.replaceAll(',', '')) ?? 0;
    return Balance(code: match.group(1)!, value: value);
  }

  /// Format ke mata uang lokal, mis. "Rp 1.250.000".
  String toLocalStr() => formatMoney(value, code);

  @override
  String toString() => '$code $value';
}
