/// Konfigurasi endpoint backend.
///
/// Default menunjuk ke origin web (`cx-web`), yang me-*forward* `/api/*` ke
/// `cx-services`. Arahkan langsung ke `cx-services` bila CORS-nya sudah
/// dikonfigurasi (butuh `ORIGIN` di backend).
///
/// Override saat run/build:
///   flutter run --dart-define=API_BASE_URL=http://localhost:8787
class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    // defaultValue: 'https://cxs.cerdix.workers.dev',
    defaultValue: "http://localhost:8787"
  );

  /// Path `/api/graphql` pada web → diteruskan sebagai `/graphql` ke cx-services.
  static String get graphqlEndpoint => '$baseUrl/graphql';
}
