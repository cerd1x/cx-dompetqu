/// Error yang dilempar adapter sumber nilai tukar.
class ExchangeRateException implements Exception {
  const ExchangeRateException(this.message, {this.source, this.cause});

  final String message;

  /// Nama adapter sumber yang gagal (mis. `frankfurter`).
  final String? source;

  /// Error asli (transport/parse).
  final Object? cause;

  @override
  String toString() =>
      'ExchangeRateException(${source ?? '-'}): $message${cause != null ? ' — $cause' : ''}';
}
