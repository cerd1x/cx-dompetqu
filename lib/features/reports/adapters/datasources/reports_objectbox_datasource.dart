import 'dart:convert';

import 'package:get_it/get_it.dart';

import 'package:dompetqu/core/database/entities/report_entity.dart';
import 'package:dompetqu/core/database/objectbox_database.dart';

/// Data source laporan berbasis ObjectBox — menyimpan snapshot log ke DB lokal.
///
/// Implementasi konkret dari kontrak penyimpanan laporan. Saat backend siap,
/// bisa ditambah data source remote (mis. `reports_remote_datasource.dart`)
/// tanpa mengubah kontrak domain.
class ReportsObjectboxDataSource {
  ObjectBoxDatabase get _db => GetIt.instance.get<ObjectBoxDatabase>();

  /// Simpan snapshot laporan ke ObjectBox.
  Future<void> submit({
    required String message,
    required List<Map<String, dynamic>> logs,
    required String appVersion,
  }) async {
    final entity = ReportEntity(
      timestamp: DateTime.now(),
      message: message,
      logsJson: jsonEncode(logs),
      appVersion: appVersion,
    );
    _db.reportBox.put(entity);
  }

  /// Ambil semua laporan tersimpan (terbaru dulu).
  Future<List<ReportEntity>> loadAll() async {
    final entities = _db.reportBox.getAll();
    // Urutkan terbaru dulu berdasarkan timestamp.
    entities.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return entities;
  }

  /// Hapus semua laporan tersimpan.
  Future<void> clear() async {
    _db.reportBox.removeAll();
  }

  /// Hapus laporan berdasarkan ID.
  Future<void> remove(int id) async {
    _db.reportBox.remove(id);
  }
}
