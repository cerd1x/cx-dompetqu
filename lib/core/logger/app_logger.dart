import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import 'log_level.dart';
import 'log_record.dart';

/// Logger aplikasi untuk fase beta.
///
/// - Menangkap log & error ke buffer memori (ring buffer).
/// - Menginstal global hooks (`FlutterError.onError` + platform error) agar
///   crash/exception yang tidak tertangkap ikut terekam.
/// - Selalu menulis ke console via `debugPrint` (muncul di `adb logcat`
///   Android termasuk build beta/release), tidak hanya saat debug.
/// - Dapat menulis ke file (`enableFileLogging`) di direktori dokumen app
///   dengan rotasi otomatis saat melebihi ukuran maksimal. Di Android path-nya
///   private app (`/data/user/0/<pkg>/app_flutter/logs/`), bisa diakses via
///   `adb shell run-as <pkg> cat app_flutter/logs/dompetqu.log` atau Device
///   File Explorer di Android Studio.
/// - Hasil bisa diekspor (teks/JSON) dan dikirim sebagai laporan beta via
///   [BetaReportRemote].
class AppLogger extends ChangeNotifier {
  AppLogger._();

  static final AppLogger instance = AppLogger._();

  /// Kapasitas buffer; yang paling lama dibuang saat penuh.
  static const int maxBuffer = 300;

  /// Ukuran maksimal file log sebelum di-rotate ke `*.old`.
  static const int maxFileBytes = 256 * 1024;

  static const String logFileName = 'dompetqu.log';

  final List<LogRecord> _buffer = [];
  final List<String> _pendingFileLines = [];

  bool _hooksInstalled = false;
  bool _fileEnabled = false;
  bool _fileWriting = false;
  bool _truncateRequested = false;
  File? _logFile;

  List<LogRecord> get records => List.unmodifiable(_buffer);

  int get errorCount => _buffer.where((r) => r.level == LogLevel.error).length;

  /// Apakah logging ke file aktif (hanya tersedia di platform non-web).
  bool get fileLoggingEnabled => _fileEnabled;

  /// Path file log saat ini, atau `null` bila logging file nonaktif.
  String? get logFilePath => _logFile?.path;

  void _add(
    LogLevel level,
    String message, {
    String? tag,
    StackTrace? stackTrace,
    Map<String, dynamic>? extras,
  }) {
    final record = LogRecord(
      level: level,
      message: message,
      tag: tag,
      stackTrace: stackTrace,
      extras: extras,
    );
    _buffer.add(record);
    if (_buffer.length > maxBuffer) _buffer.removeAt(0);
    // Selalu kirim ke console (logcat di Android) — bukan hanya kDebugMode —
    // supaya logger bisa di-debug dari build beta/release.
    debugPrint(record.line);
    _writeLineToFile(record.line);
    notifyListeners();
  }

  void debug(String message, {String? tag, Map<String, dynamic>? extras}) {
    _add(LogLevel.debug, message, tag: tag, extras: extras);
  }

  void info(String message, {String? tag, Map<String, dynamic>? extras}) {
    _add(LogLevel.info, message, tag: tag, extras: extras);
  }

  void success(String message, {String? tag, Map<String, dynamic>? extras}) {
    _add(LogLevel.success, message, tag: tag, extras: extras);
  }

  void warn(String message, {String? tag, Map<String, dynamic>? extras}) {
    _add(LogLevel.warn, message, tag: tag, extras: extras);
  }

  void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? extras,
  }) {
    final detail = error == null ? '' : '\n${error.runtimeType}: $error';
    _add(
      LogLevel.error,
      '$message$detail',
      tag: tag,
      stackTrace: stackTrace,
      extras: extras,
    );
  }

  /// Pasang global hooks untuk menangkap error Flutter & platform.
  ///
  /// Idempotent — aman dipanggil beberapa kali (misal hot restart).
  void installGlobalHooks() {
    if (_hooksInstalled) return;
    _hooksInstalled = true;

    final previousFlutterError = FlutterError.onError;
    FlutterError.onError = (details) {
      _add(
        LogLevel.error,
        details.exceptionAsString(),
        tag: 'FlutterError',
        stackTrace: details.stack,
      );
      previousFlutterError?.call(details);
    };

    final previousPlatformError = PlatformDispatcher.instance.onError;
    PlatformDispatcher.instance.onError = (error, stack) {
      _add(
        LogLevel.error,
        error.toString(),
        tag: 'Platform',
        stackTrace: stack,
      );
      return previousPlatformError?.call(error, stack) ?? true;
    };
  }

  /// Aktifkan penulisan log ke file di direktori dokumen app (`<dir>/logs/`).
  ///
  /// Aman dipanggil saat startup. Di web tidak didukung (dilewati diam-diam).
  /// Rotasi otomatis ke `<file>.old` saat melebihi [maxFileBytes].
  Future<void> enableFileLogging() async {
    if (_fileEnabled || kIsWeb) return;
    try {
      final docs = await getApplicationDocumentsDirectory();
      final logsDir = Directory('${docs.path}/logs');
      await logsDir.create(recursive: true);
      final file = File('${logsDir.path}/$logFileName');
      if (await file.exists() && await file.length() > maxFileBytes) {
        await _rotate(file);
      }
      _logFile = File(file.path);
      _fileEnabled = true;
      _writeLineToFile(
        '--- Sesi log dimulai ${DateTime.now().toIso8601String()} ---',
      );
      _add(LogLevel.info, 'File log aktif: ${file.path}', tag: 'AppLogger');
    } catch (e) {
      _fileEnabled = false;
      _logFile = null;
      _add(LogLevel.warn, 'File logging nonaktif: $e', tag: 'AppLogger');
    }
  }

  /// N baris log terbaru (terbaru di depan).
  List<LogRecord> latest(int count) => _buffer.reversed.take(count).toList();

  String exportText() => _buffer.map((r) => r.line).join('\n');

  List<Map<String, dynamic>> exportJson() =>
      _buffer.map((r) => r.toJson()).toList();

  void clear() {
    _buffer.clear();
    _pendingFileLines.clear();
    if (_fileEnabled) {
      _truncateRequested = true;
      _drainFile();
    }
    notifyListeners();
  }

  void _writeLineToFile(String line) {
    if (!_fileEnabled) return;
    _pendingFileLines.add(line);
    _drainFile();
  }

  void _drainFile() {
    if (_fileWriting) return;
    if (_pendingFileLines.isEmpty && !_truncateRequested) return;
    _fileWriting = true;
    Future(() async {
      try {
        final file = _logFile!;
        if (_truncateRequested) {
          _truncateRequested = false;
          _pendingFileLines.clear();
          await file.writeAsString('', flush: true);
        } else {
          while (_pendingFileLines.isNotEmpty) {
            final batch = List.of(_pendingFileLines);
            _pendingFileLines.clear();
            if (await file.length() > maxFileBytes) {
              await _rotate(file);
            }
            await file.writeAsString(
              '${batch.join('\n')}\n',
              mode: FileMode.append,
            );
          }
        }
      } catch (_) {
        // jangan crash app karena file logging
      } finally {
        _fileWriting = false;
        if (_pendingFileLines.isNotEmpty || _truncateRequested) {
          _drainFile();
        }
      }
    });
  }

  Future<void> _rotate(File file) async {
    final old = File('${file.path}.old');
    if (await old.exists()) await old.delete();
    await file.rename(old.path);
    _logFile = File(file.path);
  }
}
