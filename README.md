# cx-dompetqu

Aplikasi dompet (finansial) — port dari modul `/dompet` SvelteKit ke Flutter.
Desktop (Linux/Windows/macOS) memakai Riverpod + go_router, mobile memakai
Riverpod yang sama.

Project berdiri sendiri: talk ke backend `cx-services` lewat HTTP/GraphQL.

```
cx-dompetqu ──HTTP/GraphQL──▶ cx-web (/api/*) ──▶ cx-services
                     atau langsung ───────────────▶ cx-services
```

Endpoint diatur lewat `--dart-define` (`lib/core/config/api_config.dart`):

```bash
flutter run -d linux --dart-define=API_BASE_URL=http://localhost:8787
```

## Command

- `flutter run -d linux` — dev desktop
- `flutter build linux --release` — bundle desktop (`build/linux/x64/release/bundle`)
- `flutter test` — test (`bun`/`flutter test`, LLM-friendly)
- `flutter analyze` — type check + lint

## WebView chart

Chart TradingView dirender lewat [`flutter_inappwebview`](https://pub.dev/packages/flutter_inappwebview).
Pemetaan platformnya ada di `chartEngineFor()` (`lib/features/charts/charts_trading.dart`):
Android/iOS memakai webview native, sedangkan desktop (Linux/Windows/macOS) dan web
menampilkan pesan fallback karena tidak ada engine webview yang bisa di-drop-in.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
