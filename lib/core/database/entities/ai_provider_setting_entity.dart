import 'package:objectbox/objectbox.dart';

/// Setting per provider AI (api_key, model, base_url, custom_headers, dll).
@Entity()
class AiProviderSettingEntity {
  AiProviderSettingEntity({
    this.id = 0,
    this.provider = '',
    this.apiKey = '',
    this.model = '',
    this.baseUrl = '',
    this.customHeadersJson = '{}',
    this.includeCustomHeaders = false,
    this.useCustomModel = false,
  });

  int id = 0;

  @Index()
  @Unique()
  /// Nama provider: 'googleAi', 'openai', 'anthropic', 'ollama', 'openrouter'.
  String provider = '';
  String apiKey = '';
  String model = '';
  String baseUrl = '';

  /// JSON-encoded Map<String, String>.
  String customHeadersJson = '{}';
  bool includeCustomHeaders = false;
  bool useCustomModel = false;
}
