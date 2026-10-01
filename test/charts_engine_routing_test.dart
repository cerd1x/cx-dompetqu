import 'package:dompetqu/features/charts/charts_trading.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('chartEngineFor', () {
    test('desktop tidak punya engine webview', () {
      for (final platform in [
        TargetPlatform.linux,
        TargetPlatform.windows,
        TargetPlatform.macOS,
      ]) {
        expect(
          chartEngineFor(isWeb: false, platform: platform),
          ChartEngine.unsupported,
          reason: '$platform tidak punya engine webview',
        );
      }
    });

    test('mobile memakai flutter_inappwebview', () {
      expect(
        chartEngineFor(isWeb: false, platform: TargetPlatform.android),
        ChartEngine.inAppWebView,
      );
      expect(
        chartEngineFor(isWeb: false, platform: TargetPlatform.iOS),
        ChartEngine.inAppWebView,
      );
    });

    test('web dan fuchsia tidak punya engine webview', () {
      expect(
        chartEngineFor(isWeb: true, platform: TargetPlatform.android),
        ChartEngine.unsupported,
      );
      expect(
        chartEngineFor(isWeb: false, platform: TargetPlatform.fuchsia),
        ChartEngine.unsupported,
      );
    });
  });

  group('TradingViewChart pada platform tanpa webview', () {
    for (final platform in [
      TargetPlatform.linux,
      TargetPlatform.fuchsia,
    ]) {
      testWidgets('$platform menampilkan pesan fallback, bukan webview', (
        tester,
      ) async {
        debugDefaultTargetPlatformOverride = platform;
        addTearDown(() => debugDefaultTargetPlatformOverride = null);

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: TradingViewChart(symbol: 'BTCUSDT', height: 200),
            ),
          ),
        );

        expect(
          find.text('WebView tidak didukung pada platform ini.'),
          findsOneWidget,
        );
        expect(find.byType(InAppWebView), findsNothing);
        // Spinner tidak boleh menutupi pesan fallback.
        expect(find.byType(CircularProgressIndicator), findsNothing);

        // Harus dikembalikan sebelum flutter_test memverifikasi invariant
        // debug variable, jadi reset di dalam body (addTearDown hanya cadangan).
        debugDefaultTargetPlatformOverride = null;
      });
    }
  });
}
