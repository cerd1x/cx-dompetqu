import 'log_level.dart';
import 'app_log_feature.dart';

/// Satu baris log yang ditangkap `AppLogger`.
class LogRecord {
  LogRecord({
    required this.level,
    required this.message,
    this.feature = AppLogFeature.core,
    this.tag,
    this.stackTrace,
    this.extras,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  final LogLevel level;
  final String message;
  final AppLogFeature feature;
  final String? tag;
  final StackTrace? stackTrace;
  final Map<String, dynamic>? extras;
  final DateTime timestamp;

  /// Representasi satu baris teks, cocok untuk clipboard/export.
  String get line {
    final ts = timestamp.toIso8601String();
    final t = tag == null ? '' : '[$tag] ';
    return '[$ts] [${level.label}] [${feature.name}] $t$message';
  }

  /// Baris berwarna untuk console: tanggal (biru), waktu (merah redup/dim),
  /// level (warna level), nama fitur (magenta), tag (kuning), dan pesan
  /// (warna level). File log/export tetap memakai [line] polos.
  String get consoleLine {
    const r = '\x1B[0m';
    const dim = '\x1B[90m';
    const cDate = '\x1B[34m';
    const cTime = '\x1B[2;31m';
    const cFeature = '\x1B[35m';
    const cTag = '\x1B[33m';

    final ts = timestamp.toIso8601String();
    final idxT = ts.indexOf('T');
    final date = idxT != -1 ? ts.substring(0, idxT) : ts;
    final time = idxT != -1 ? ts.substring(idxT + 1) : '';
    final timePart = time.isEmpty ? '' : ' $cTime$time$dim';
    final t = tag == null ? '' : '$dim[$cTag$tag$dim]$r ';

    return '$dim[$cDate$date$timePart]$r '
        '${level.ansi}[${level.label}]$r '
        '$dim[$cFeature${feature.name}$dim]$r '
        '$t${level.ansi}$message$r';
  }

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'level': level.label,
    'feature': feature.name,
    if (tag != null) 'tag': tag,
    'message': message,
    if (stackTrace != null) 'stackTrace': stackTrace.toString(),
    if (extras != null) 'extras': extras,
  };
}
