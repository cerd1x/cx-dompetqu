import 'log_level.dart';

/// Satu baris log yang ditangkap `AppLogger`.
class LogRecord {
  LogRecord({
    required this.level,
    required this.message,
    this.tag,
    this.stackTrace,
    this.extras,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  final LogLevel level;
  final String message;
  final String? tag;
  final StackTrace? stackTrace;
  final Map<String, dynamic>? extras;
  final DateTime timestamp;

  /// Representasi satu baris teks, cocok untuk clipboard/export.
  String get line {
    final ts = timestamp.toIso8601String();
    final t = tag == null ? '' : '[$tag] ';
    return '[$ts] [${level.label}] $t$message';
  }

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'level': level.label,
    if (tag != null) 'tag': tag,
    'message': message,
    if (stackTrace != null) 'stackTrace': stackTrace.toString(),
    if (extras != null) 'extras': extras,
  };
}
