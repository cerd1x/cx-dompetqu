/// Tingkat level log aplikasi (padanan `LogLevel` di backend services).
enum LogLevel {
  debug('DBG', '\x1B[90m'), // abu-abu
  info('INF', '\x1B[36m'), // cyan
  success('SUC', '\x1B[32m'), // hijau
  warn('WRN', '\x1B[33m'), // kuning
  error('ERR', '\x1B[31m'); // merah

  const LogLevel(this.label, this.ansi);

  final String label;

  /// Kode escape ANSI untuk mewarnai level di console.
  final String ansi;
}
