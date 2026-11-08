/// Port penyimpanan laporan (backend/database). Adalah kontrak,
/// implementasi konkret berada di `adapters/`.
abstract interface class ReportsRepository {
  /// Kirim/simpan snapshot laporan (isi log) ke backend/database.
  Future<void> submit({
    required String message,
    required List<Map<String, dynamic>> logs,
    required String appVersion,
  });

  /// Bersihkan/hapus laporan tersimpan (no-op di mock).
  Future<void> clear();
}
