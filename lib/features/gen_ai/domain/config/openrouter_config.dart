/// Konfigurasi khusus OpenRouter untuk fitur `gen_ai`.
///
/// OpenRouter diakses lewat API kompatibel OpenAI (`/api/v1/chat/completions`
/// dan `/api/v1/models`), jadi semua literal host/endpoint didefinisikan di
/// sini sebagai satu-satunya sumber kebenaran. `AiModelProvider`, datasource
/// katalog model, dan sheet pengaturan membaca konstanta dari kelas ini
/// alih-alih menuliskan `openrouter.ai` secara terpisah di tiap file.
class OpenRouterConfig {
  const OpenRouterConfig._();

  /// Label provider pada UI (dipakai `AiModelProvider.label`).
  static const String label = 'OpenRouter';

  /// Key persistensi provider (dipakai `AiModelProvider.storageKey`).
  /// Format `snake_case` mengikuti provider lain agar kunci SharedPreferences
  /// tetap konsisten (`ai_open_router_*`).
  static const String storageKey = 'open_router';

  /// Host resmi OpenRouter — satu-satunya tempat literal host ditulis.
  static const String host = 'openrouter.ai';

  /// Base URL API chat completion kompatibel OpenAI (default provider).
  static const String baseUrl = 'https://$host/api/v1';

  /// Endpoint katalog model (`GET /api/v1/models`).
  static const String modelsPath = '$baseUrl/models';

  /// Suffix chat completion yang dipotong saat membentuk URI katalog,
  /// sehingga base URL pengguna yang menempel `/chat/completions` tetap sah.
  static const String chatCompletionsSuffix = '/chat/completions';

  /// Model default provider; ID OpenRouter memakai prefix vendor (`vendor/model`).
  static const String defaultModel = 'google/gemini-2.5-flash';

  /// Apakah `value` menunjuk ke OpenRouter (skema https + host resmi).
  /// Dipakai UI untuk memutuskan tampil katalog model, dan datasource untuk
  /// memvalidasi base URL buatan pengguna.
  static bool isBaseUrl(String value) {
    final uri = Uri.tryParse(value.trim());
    return uri != null &&
        uri.scheme == 'https' &&
        uri.host.toLowerCase() == host;
  }
}
