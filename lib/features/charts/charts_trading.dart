import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;

/// Engine webview yang dipakai untuk merender chart.
enum ChartEngine {
  /// Mobile (Android/iOS) → WebView native.
  inAppWebView,

  /// Tidak ada engine yang mendukung (desktop dan web).
  unsupported,
}

/// Memetakan platform ke engine chart.
///
/// Hanya Android/iOS yang punya engine webview, lewat `flutter_inappwebview`.
/// Desktop tidak punya engine webview yang bisa di-drop-in (CEF dihapus),
/// begitu juga platform lain (mis. Fuchsia) dan web.
ChartEngine chartEngineFor({
  required bool isWeb,
  required TargetPlatform platform,
}) {
  if (isWeb) return ChartEngine.unsupported;
  switch (platform) {
    case TargetPlatform.android:
    case TargetPlatform.iOS:
      return ChartEngine.inAppWebView;
    case TargetPlatform.linux:
    case TargetPlatform.macOS:
    case TargetPlatform.windows:
    case TargetPlatform.fuchsia:
      return ChartEngine.unsupported;
  }
}

/// Widget chart TradingView yang mengambil data real-time dari Binance.
///
/// Gratis untuk penggunaan pribadi — TradingView widget embed (tanpa lisensi)
/// + Binance public API (tanpa API key, rate limit 1200 req/menit).
///
/// Engine webview dipilih otomatis per platform (lihat [chartEngineFor]):
/// - Android/iOS → `flutter_inappwebview`
/// - Desktop dan web → pesan fallback, chart tidak dirender
///
/// Penggunaan:
/// ```dart
/// TradingViewChart(symbol: 'BTCUSDT', interval: '60')
/// ```
class TradingViewChart extends StatefulWidget {
  const TradingViewChart({
    super.key,
    required this.symbol,
    this.interval = '60',
    this.height = 360,
    this.theme = ChartTheme.dark,
  });

  final String symbol;
  final String interval;
  final double height;
  final ChartTheme theme;

  @override
  State<TradingViewChart> createState() => _TradingViewChartState();
}

enum ChartTheme { dark, light }

class _TradingViewChartState extends State<TradingViewChart> {
  /// Timeout sebelum indikator "memuat" dilepas, supaya halaman yang gagal
  /// load tidak terkunci selamanya di spinner.
  static const _loadTimeout = Duration(seconds: 20);

  Timer? _loadTimer;
  bool _loading = true;
  String? _error;

  /// Generasi HTML untuk `InAppWebView`: `initialData` hanya dipakai saat
  /// widget dibuat, jadi naiknya nilai ini memaksa webview dimuat ulang.
  int _htmlGeneration = 0;

  ChartEngine get _engine =>
      chartEngineFor(isWeb: kIsWeb, platform: defaultTargetPlatform);

  @override
  void initState() {
    super.initState();
    // Tanpa engine webview tidak ada yang perlu dimuat, jadi jangan tampilkan
    // spinner di atas pesan fallback.
    if (_engine != ChartEngine.inAppWebView) _loading = false;
  }

  @override
  void didUpdateWidget(covariant TradingViewChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    final htmlChanged =
        oldWidget.symbol != widget.symbol ||
        oldWidget.interval != widget.interval ||
        oldWidget.theme != widget.theme;
    if (!htmlChanged) return;
    if (_engine != ChartEngine.inAppWebView) return;

    _htmlGeneration++;
    _setLoading(true);
    _startLoadTimeout();
  }

  @override
  void dispose() {
    _loadTimer?.cancel();
    super.dispose();
  }

  void _startLoadTimeout() {
    _loadTimer?.cancel();
    _loadTimer = Timer(_loadTimeout, () {
      if (!mounted || !_loading) return;
      debugPrint('[TradingView] load timeout, indikator dimatikan paksa');
      _setLoading(false);
    });
  }

  void _setLoading(bool value) {
    _loadTimer?.cancel();
    _loadTimer = null;
    if (!mounted) return;
    setState(() {
      _loading = value;
      if (!value) _error = null;
    });
  }

  void _fail(String message) {
    if (!mounted) return;
    setState(() {
      _loading = false;
      _error = message;
    });
  }

  String _buildHtml() {
    final bgColor = widget.theme == ChartTheme.dark ? '0F0F0F' : 'FFFFFF';
    final gridColor = widget.theme == ChartTheme.dark ? '1F1F1F' : 'ECECEC';
    final symbolEsc = _escapeHtml(widget.symbol);
    final intervalEsc = _escapeHtml(widget.interval);
    final themeStr = widget.theme == ChartTheme.dark ? 'dark' : 'light';

    return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
  <style>
    html, body { margin: 0; padding: 0; height: 100%; background: #$bgColor; }
    #tv { height: 100%; width: 100%; }
  </style>
  <script src="https://s3.tradingview.com/tv.js"></script>
</head>
<body>
  <div id="tv"></div>
  <script>
    new TradingView.widget({
      autosize: true,
      symbol: "BINANCE:$symbolEsc",
      interval: "$intervalEsc",
      timezone: "Asia/Jakarta",
      theme: "$themeStr",
      style: "1",
      locale: "id",
      toolbar_bg: "#$bgColor",
      enable_publishing: false,
      allow_symbol_change: true,
      hide_top_toolbar: false,
      hide_legend: false,
      save_image: false,
      studies: ["MASimple@tv-basicstudies", "RSI@tv-basicstudies"],
      backgroundColor: "#$bgColor",
      gridColor: "#$gridColor",
    });
  </script>
</body>
</html>
''';
  }

  static String _escapeHtml(String input) {
    return input
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#39;');
  }

  @override
  Widget build(BuildContext context) {
    final dark = widget.theme == ChartTheme.dark;
    final bgColor = dark ? Colors.black : Colors.white;

    return SizedBox(
      height: widget.height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          switch (_engine) {
            ChartEngine.inAppWebView => InAppWebView(
              key: ValueKey(_htmlGeneration),
              initialData: InAppWebViewInitialData(data: _buildHtml()),
              initialSettings: InAppWebViewSettings(),
              onLoadStop: (controller, url) => _onPageLoaded(),
              onReceivedError: (controller, request, error) {
                debugPrint('TradingView error: ${error.description}');
                // Hanya tampilkan error kalau dokumen utama memang belum
                // selesai dimuat; error sub-resource (favicon, socket, dll)
                // tidak boleh menutupi chart yang sudah tampil.
                if (_loading) _fail('Gagal memuat chart: ${error.description}');
              },
            ),
            ChartEngine.unsupported => ColoredBox(
              color: bgColor,
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'WebView tidak didukung pada platform ini.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          },
          // Indikator tidak boleh memblokir input webview di bawahnya.
          if (_loading)
            IgnorePointer(
              child: ColoredBox(color: bgColor, child: _spinner()),
            ),
          if (_error != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: dark ? Colors.white70 : Colors.black54,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _onPageLoaded() => _setLoading(false);

  Widget _spinner() => const Center(child: CircularProgressIndicator());
}

/// Service untuk ambil data Binance gratis (public endpoint, tanpa API key).
class BinanceService {
  BinanceService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const _base = 'https://api.binance.com';

  /// Harga real-time satu simbol, contoh: `BTCUSDT`.
  Future<double> getPrice(String symbol) async {
    final r = await _client.get(
      Uri.parse('$_base/api/v3/ticker/price?symbol=$symbol'),
    );
    if (r.statusCode != 200) {
      throw Exception('Binance error ${r.statusCode}: ${r.body}');
    }
    final data = jsonDecode(r.body) as Map<String, dynamic>;
    return double.parse(data['price'] as String);
  }

  /// Candlestick historis.
  ///
  /// [interval] sesuai Binance: 1m, 5m, 15m, 1h, 4h, 1d, 1w.
  /// [limit] max 1000.
  Future<List<BinanceKline>> getKlines({
    required String symbol,
    String interval = '1h',
    int limit = 500,
  }) async {
    final uri = Uri.parse(
      '$_base/api/v3/klines?symbol=$symbol&interval=$interval&limit=$limit',
    );
    final r = await _client.get(uri);
    if (r.statusCode != 200) {
      throw Exception('Binance error ${r.statusCode}: ${r.body}');
    }
    final list = jsonDecode(r.body) as List<dynamic>;
    return list.map((e) => BinanceKline.fromArray(e as List<dynamic>)).toList();
  }

  void dispose() => _client.close();
}

class BinanceKline {
  BinanceKline({
    required this.openTime,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
    required this.closeTime,
  });

  final DateTime openTime;
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;
  final DateTime closeTime;

  factory BinanceKline.fromArray(List<dynamic> a) => BinanceKline(
    openTime: DateTime.fromMillisecondsSinceEpoch(a[0] as int),
    open: double.parse(a[1] as String),
    high: double.parse(a[2] as String),
    low: double.parse(a[3] as String),
    close: double.parse(a[4] as String),
    volume: double.parse(a[5] as String),
    closeTime: DateTime.fromMillisecondsSinceEpoch(a[6] as int),
  );
}

/// Halaman siap-pakai: TradingView chart + ticker Binance live.
class TradingChartScreen extends StatefulWidget {
  const TradingChartScreen({super.key, required this.symbol, this.symbolLabel});

  final String symbol;
  final String? symbolLabel;

  @override
  State<TradingChartScreen> createState() => _TradingChartScreenState();
}

class _TradingChartScreenState extends State<TradingChartScreen> {
  final _binance = BinanceService();
  double? _price;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchPrice();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _fetchPrice());
  }

  Future<void> _fetchPrice() async {
    try {
      final p = await _binance.getPrice(widget.symbol);
      if (mounted) setState(() => _price = p);
    } catch (_) {
      // silent retry
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _binance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.symbolLabel ?? widget.symbol),
        actions: [
          if (_price != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: Text(
                  '\$${_price!.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: TradingViewChart(symbol: widget.symbol),
    );
  }
}
