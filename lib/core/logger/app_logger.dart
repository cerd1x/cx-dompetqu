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
///   dengan rotasi otomatis saat melebihi ukuran maksimal. Semua level masuk
///   ke `dompetqu.log`; khusus level error juga dicatat ke `errors.log`.
///   Di Android path-nya private app (`/data/user/0/<pkg>/app_flutter/logs/`),
///   bisa diakses via `adb shell run-as <pkg> cat app_flutter/logs/dompetqu.log`
///   (atau `.../errors.log`) atau Device File Explorer di Android Studio.
/// - Hasil bisa diekspor (teks/JSON) dan dikirim sebagai laporan beta via
///   [BetaReportRemote].
class AppLogger extends ChangeNotifier {
  AppLogger._() {
    _mainFile = _FileSink(
      fileName: logFileName,
      maxBytes: maxFileBytes,
      onError: _onSinkError,
    );
    _errorFile = _FileSink(
      fileName: errorLogFileName,
      maxBytes: maxFileBytes,
      onError: _onSinkError,
    );
  }

  static final AppLogger instance = AppLogger._();

  /// Kapasitas buffer; yang paling lama dibuang saat penuh.
  static const int maxBuffer = 300;

  /// Ukuran maksimal file log sebelum di-rotate ke `*.old`.
  static const int maxFileBytes = 256 * 1024;

  /// File log utama (semua level).
  static const String logFileName = 'dompetqu.log';

  /// File log khusus level error.
  static const String errorLogFileName = 'errors.log';

  final List<LogRecord> _buffer = [];

  late final _FileSink _mainFile;
  late final _FileSink _errorFile;

  bool _hooksInstalled = false;

  Object? _lastFileError;

  /// Error terakhir saat menulis ke file log, atau `null` bila tidak ada.
  /// Dipakai untuk mendiagnosis kegagalan target penulisan log.
  Object? get lastFileError => _lastFileError;

  /// Dipanggil `_FileSink` bila penulisan file gagal. Sengaja **tidak**
  /// memanggil `_add` agar tidak memicu rekursi tulis ke sink yang sama.
  void _onSinkError(Object error, StackTrace stackTrace) {
    _lastFileError = error;
    debugPrint('[AppLogger] Gagal menulis file log: $error');
  }

  /// Level minimum yang direkam. Log di bawah level ini dibuang.
  /// Default [LogLevel.debug] — semua log direkam.
  LogLevel _minLevel = LogLevel.debug;

  LogLevel get minLevel => _minLevel;

  set minLevel(LogLevel level) {
    if (_minLevel == level) return;
    _minLevel = level;
    notifyListeners();
  }

  List<LogRecord> get records => List.unmodifiable(_buffer);

  int get errorCount => _buffer.where((r) => r.level == LogLevel.error).length;

  /// Apakah logging ke file utama aktif (hanya di platform non-web).
  bool get fileLoggingEnabled => _mainFile.enabled;

  /// Apakah logging error ke file terpisah aktif.
  bool get errorFileLoggingEnabled => _errorFile.enabled;

  /// Path file log utama saat ini, atau `null` bila logging file nonaktif.
  String? get logFilePath => _mainFile.path;

  /// Path file log error saat ini, atau `null` bila logging error nonaktif.
  String? get errorLogFilePath => _errorFile.path;

  /// Environment variable untuk override direktori dasar log (desktop/Android).
  static const String logDirEnvKey = 'DOMPETQU_LOG_DIR';

  Directory? _logDirectory;

  /// Direktori dasar override untuk file log (folder `logs/` dibuat di
  /// dalamnya). Bila `null`, dipakai default platform via
  /// [defaultLogDirectory].
  Directory? get logDirectory => _logDirectory;

  /// Set direktori dasar log. Sebaiknya dipanggil **sebelum**
  /// [enableFileLogging]; sink yang sudah aktif tidak berpindah otomatis.
  set logDirectory(Directory? dir) {
    if (_logDirectory?.path == dir?.path) return;
    _logDirectory = dir;
    notifyListeners();
  }

  /// Versi [logDirectory] dari path string. `null`/kosong mengembalikan ke
  /// default platform.
  void setLogDirectoryPath(String? path) =>
      logDirectory = (path == null || path.isEmpty) ? null : Directory(path);

  /// Direktori dasar default untuk file log, per platform.
  ///
  /// Urutan resolusi:
  /// 1. Environment variable [logDirEnvKey] (`DOMPETQU_LOG_DIR`) — berguna di
  ///    Linux/desktop untuk mengarahkan log ke lokasi kustom.
  /// 2. `getApplicationDocumentsDirectory()` milik platform:
  ///    - Android: `/data/user/0/<pkg>/app_flutter`
  ///    - iOS: `<app sandbox>/Documents`
  ///    - Linux: XDG user dir (`$XDG_DOCUMENTS_DIR`, biasanya `~/Documents`)
  ///    - macOS/Windows: folder Documents user
  ///
  /// Web tidak didukung — melempar [UnsupportedError].
  static Future<Directory> defaultLogDirectory() async {
    if (kIsWeb) {
      throw UnsupportedError('File logging tidak tersedia di web');
    }
    final env = Platform.environment[logDirEnvKey];
    if (env != null && env.isNotEmpty) return Directory(env);
    return getApplicationDocumentsDirectory();
  }

  void _add(
    LogLevel level,
    String message, {
    String? tag,
    StackTrace? stackTrace,
    Map<String, dynamic>? extras,
  }) {
    if (level.index < _minLevel.index) return;
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
    _mainFile.writeLine(record.line);
    // Error juga dicatat ke `errors.log` agar mudah diperiksa terpisah.
    if (level == LogLevel.error) _errorFile.writeLine(record.line);
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
  /// Menyalakan dua file sekaligus: [logFileName] (semua level) dan
  /// [errorLogFileName] (khusus level error). Aman dipanggil saat startup. Di
  /// web tidak didukung (dilewati diam-diam). Rotasi otomatis ke `<file>.old`
  /// saat melebihi [maxFileBytes].
  ///
  /// Lokasi dasar ditentukan berurutan: parameter [directory] → [logDirectory]
  /// → [defaultLogDirectory] (env `DOMPETQU_LOG_DIR` lalu default platform).
  Future<void> enableFileLogging({Directory? directory}) async {
    if (kIsWeb) return;

    Directory baseDir;
    try {
      baseDir = directory ?? _logDirectory ?? await defaultLogDirectory();
    } catch (e) {
      _add(LogLevel.warn, 'Direktori log tidak tersedia: $e', tag: 'AppLogger');
      return;
    }

    if (!_mainFile.enabled) {
      try {
        await _mainFile.enable(baseDir);
        _add(
          LogLevel.info,
          'File log aktif: ${_mainFile.path}',
          tag: 'AppLogger',
        );
      } catch (e) {
        _add(LogLevel.warn, 'File logging nonaktif: $e', tag: 'AppLogger');
      }
    }
    if (!_errorFile.enabled) {
      try {
        await _errorFile.enable(baseDir);
        _add(
          LogLevel.info,
          'File log error aktif: ${_errorFile.path}',
          tag: 'AppLogger',
        );
      } catch (e) {
        _add(
          LogLevel.warn,
          'File logging error nonaktif: $e',
          tag: 'AppLogger',
        );
      }
    }
  }

  /// N baris log terbaru (terbaru di depan).
  List<LogRecord> latest(int count) => _buffer.reversed.take(count).toList();

  String exportText() => _buffer.map((r) => r.line).join('\n');

  List<Map<String, dynamic>> exportJson() =>
      _buffer.map((r) => r.toJson()).toList();

  void clear() {
    _buffer.clear();
    _mainFile.clear();
    _errorFile.clear();
    notifyListeners();
  }
}

/// Sink file tunggal dengan buffer tulis async dan rotasi otomatis.
///
/// Dipakai untuk file log utama dan file log error. Semua operasi I/O
/// dibungkus `try/catch` supaya kegagalan menulis log tidak pernah membuat
/// aplikasi crash.
class _FileSink {
  _FileSink({
    required this.fileName,
    required this.maxBytes,
    this.onError,
  });

  final String fileName;
  final int maxBytes;

  /// Callback saat penulisan/rotasi gagal. Baris yang gagal **tidak dibuang**;
  /// akan dicoba lagi pada penulisan berikutnya.
  final void Function(Object error, StackTrace stackTrace)? onError;

  final List<String> _pending = [];
  bool _enabled = false;
  bool _writing = false;
  bool _truncateRequested = false;
  bool _failed = false;
  File? _file;

  bool get enabled => _enabled;
  String? get path => _file?.path;

  Future<void> enable(Directory baseDir) async {
    if (_enabled || kIsWeb) return;
    final logsDir = Directory('${baseDir.path}/logs');
    await logsDir.create(recursive: true);
    final file = File('${logsDir.path}/$fileName');
    if (await file.exists() && await file.length() > maxBytes) {
      await _rotate(file);
    }
    _file = File(file.path);
    _enabled = true;
    writeLine('--- Sesi log dimulai ${DateTime.now().toIso8601String()} ---');
  }

  void writeLine(String line) {
    if (!_enabled) return;
    _pending.add(line);
    // Baris baru menandakan target mungkin sudah pulih — coba tulis lagi.
    _failed = false;
    _drain();
  }

  void clear() {
    _pending.clear();
    if (_enabled) {
      _truncateRequested = true;
      _failed = false;
      _drain();
    }
  }

  void _drain() {
    if (_writing || _failed) return;
    if (_pending.isEmpty && !_truncateRequested) return;
    _writing = true;
    Future(() async {
      try {
        final file = _file!;
        if (_truncateRequested) {
          _truncateRequested = false;
          _pending.clear();
          await file.writeAsString('', flush: true);
        } else {
          while (_pending.isNotEmpty) {
            final batch = List.of(_pending);
            if (await file.exists() && await file.length() > maxBytes) {
              await _rotate(file);
            }
            await file.writeAsString(
              '${batch.join('\n')}\n',
              mode: FileMode.append,
            );
            // Baru buang dari antrean setelah penulisan sukses, supaya baris
            // tidak hilang bila terjadi error di target tujuan.
            _pending.removeRange(0, batch.length);
          }
        }
      } catch (e, st) {
        // Tandai gagal agar tidak retry beruntun; sisa `_pending` dipertahankan.
        _failed = true;
        onError?.call(e, st);
      } finally {
        _writing = false;
        if (!_failed && (_pending.isNotEmpty || _truncateRequested)) {
          _drain();
        }
      }
    });
  }

  Future<void> _rotate(File file) async {
    final old = File('${file.path}.old');
    if (await old.exists()) await old.delete();
    await file.rename(old.path);
    _file = File(file.path);
  }
}
