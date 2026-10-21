import 'package:dompetqu/core/logger/app_log_feature.dart';
import 'package:dompetqu/core/logger/log_level.dart';
import 'package:dompetqu/core/logger/log_record.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppLogFeature', () {
    test('maps known logger tags to their registered features', () {
      expect(AppLogFeature.fromTag('AiStore'), AppLogFeature.genAi);
      expect(
        AppLogFeature.fromTag('TransactionsStore'),
        AppLogFeature.transactions,
      );
      expect(AppLogFeature.fromTag('Session'), AppLogFeature.auth);
      expect(AppLogFeature.fromTag('GraphQL'), AppLogFeature.graphql);
      expect(AppLogFeature.fromTag('unknown'), AppLogFeature.core);
    });

    test('includes the feature in the log line and JSON record', () {
      final record = LogRecord(
        level: LogLevel.info,
        message: 'Pengaturan AI dimuat.',
        feature: AppLogFeature.genAi,
        tag: 'AiSettingsStore',
      );

      expect(record.line, contains('[genAi]'));
      expect(record.toJson()['feature'], 'genAi');
    });
  });
}
