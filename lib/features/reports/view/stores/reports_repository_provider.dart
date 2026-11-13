import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:cx_dompetqiu/features/reports/adapters/datasources/reports_objectbox_datasource.dart';
import 'package:cx_dompetqiu/features/reports/adapters/repositories/reports_repository_impl.dart';
import 'package:cx_dompetqiu/features/reports/domain/repositories/reports_repository.dart';

part 'generated/reports_repository_provider.g.dart';

/// Provider untuk data source laporan berbasis ObjectBox.
@Riverpod(keepAlive: true)
ReportsObjectboxDataSource reportsObjectboxDataSource(Ref ref) {
  return ReportsObjectboxDataSource();
}

/// Provider untuk repository laporan (port).
@Riverpod(keepAlive: true)
ReportsRepository reportsRepository(Ref ref) {
  return ReportsRepositoryImpl(ref.watch(reportsObjectboxDataSourceProvider));
}
