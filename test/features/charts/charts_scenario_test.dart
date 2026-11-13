import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cx_dompetqiu/features/charts/view/screens/charts_trading.dart';

void main() {
  group('Skenario routing engine chart', () {
    test('Android & iOS memakai WebView native', () {
      expect(
        chartEngineFor(isWeb: false, platform: TargetPlatform.android),
        ChartEngine.inAppWebView,
      );
      expect(
        chartEngineFor(isWeb: false, platform: TargetPlatform.iOS),
        ChartEngine.inAppWebView,
      );
    });

    test('desktop tidak punya engine webview', () {
      for (final platform in [
        TargetPlatform.linux,
        TargetPlatform.macOS,
        TargetPlatform.windows,
      ]) {
        expect(
          chartEngineFor(isWeb: false, platform: platform),
          ChartEngine.unsupported,
          reason: '$platform seharusnya unsupported',
        );
      }
    });

    test('platform lain (fuchsia) juga unsupported', () {
      expect(
        chartEngineFor(isWeb: false, platform: TargetPlatform.fuchsia),
        ChartEngine.unsupported,
      );
    });

    test('web selalu unsupported, termasuk di Android', () {
      expect(
        chartEngineFor(isWeb: true, platform: TargetPlatform.android),
        ChartEngine.unsupported,
      );
      expect(
        chartEngineFor(isWeb: true, platform: TargetPlatform.iOS),
        ChartEngine.unsupported,
      );
      expect(
        chartEngineFor(isWeb: true, platform: TargetPlatform.linux),
        ChartEngine.unsupported,
      );
    });
  });
}
