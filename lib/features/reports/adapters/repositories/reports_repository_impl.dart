import 'package:cx_dompetqiu/features/reports/adapters/datasources/reports_objectbox_datasource.dart';
import 'package:cx_dompetqiu/features/reports/domain/repositories/reports_repository.dart';

/// Implementasi [ReportsRepository] yang memakai [ReportsObjectboxDataSource]
/// untuk menyimpan snapshot laporan ke ObjectBox.
///
/// Saat backend siap, bisa ditambah data source remote (mis. via HTTP/GraphQL)
/// di sini — kontrak domain ([ReportsRepository]) tidak berubah.
class ReportsRepositoryImpl implements ReportsRepository {
  ReportsRepositoryImpl(this._source);

  final ReportsObjectboxDataSource _source;

  @override
  Future<void> submit({
    required String message,
    required List<Map<String, dynamic>> logs,
    required String appVersion,
  }) {
    return _source.submit(message: message, logs: logs, appVersion: appVersion);
  }

  @override
  Future<void> clear() => _source.clear();
}
