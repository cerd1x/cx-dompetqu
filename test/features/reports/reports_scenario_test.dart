import 'package:flutter_test/flutter_test.dart';

import 'package:cx_dompetqiu/features/reports/adapters/datasources/reports_objectbox_datasource.dart';
import 'package:cx_dompetqiu/features/reports/adapters/repositories/reports_repository_impl.dart';

class _FakeReportsSource extends ReportsObjectboxDataSource {
  String? message;
  List<Map<String, dynamic>>? logs;
  String? appVersion;
  int submitCalls = 0;
  int clearCalls = 0;

  @override
  Future<void> submit({
    required String message,
    required List<Map<String, dynamic>> logs,
    required String appVersion,
  }) async {
    submitCalls++;
    this.message = message;
    this.logs = logs;
    this.appVersion = appVersion;
  }

  @override
  Future<void> clear() async => clearCalls++;
}

void main() {
  group('Skenario repository laporan', () {
    test('submit meneruskan pesan, log, dan versi aplikasi', () async {
      final source = _FakeReportsSource();
      final repository = ReportsRepositoryImpl(source);

      await repository.submit(
        message: 'Aplikasi crash saat buka order',
        logs: [
          {'level': 'error', 'message': 'boom'},
        ],
        appVersion: '1.2.3',
      );

      expect(source.submitCalls, 1);
      expect(source.message, 'Aplikasi crash saat buka order');
      expect(source.logs, [
        {'level': 'error', 'message': 'boom'},
      ]);
      expect(source.appVersion, '1.2.3');
    });

    test('clear didelegasikan ke data source', () async {
      final source = _FakeReportsSource();

      await ReportsRepositoryImpl(source).clear();

      expect(source.clearCalls, 1);
    });

    test('error dari data source diteruskan', () async {
      final repository = ReportsRepositoryImpl(_ThrowingReportsSource());

      await expectLater(
        repository.submit(message: 'x', logs: const [], appVersion: '1'),
        throwsA(isA<StateError>()),
      );
    });
  });
}

class _ThrowingReportsSource extends ReportsObjectboxDataSource {
  @override
  Future<void> submit({
    required String message,
    required List<Map<String, dynamic>> logs,
    required String appVersion,
  }) async {
    throw StateError('database penuh');
  }
}
