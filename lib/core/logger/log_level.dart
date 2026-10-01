/// Tingkat level log aplikasi (padanan `LogLevel` di backend services).
enum LogLevel {
  debug('DBG'),
  info('INF'),
  success('SUC'),
  warn('WRN'),
  error('ERR');

  const LogLevel(this.label);

  final String label;
}
