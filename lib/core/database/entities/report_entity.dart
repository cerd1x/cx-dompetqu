import 'package:objectbox/objectbox.dart';

/// Snapshot laporan yang dihasilkan dari log [AppLogger].
///
/// Menyimpan payload laporan (pesan pengguna + snapshot log) ke ObjectBox
/// agar riwayat laporan bisa ditinjau ulang atau diunggah ke backend.
@Entity()
class ReportEntity {
  ReportEntity({
    this.id = 0,
    required this.timestamp,
    this.message = '',
    required this.logsJson,
    this.appVersion = '',
  });

  int id = 0;

  /// Waktu laporan dibuat (ISO 8601).
  DateTime timestamp;

  /// Pesan/deskripsi opsional dari pengguna.
  String message;

  /// Snapshot log dalam format JSON (hasil `AppLogger.exportJson()`).
  String logsJson;

  /// Versi aplikasi saat laporan dibuat.
  String appVersion;
}
