import '../../domain/entities/ai_settings.dart';
import '../../domain/entities/ai_settings_profile.dart';

class AiSettingsProfileModel {
  const AiSettingsProfileModel({
    required this.id,
    required this.name,
    required this.provider,
    required this.apiKey,
    required this.model,
    required this.baseUrl,
    required this.includeCustomHeaders,
    required this.customHeaders,
    required this.useCustomModel,
  });

  final String id;
  final String name;
  final AiModelProvider provider;
  final String apiKey;
  final String model;
  final String baseUrl;
  final bool includeCustomHeaders;
  final Map<String, String> customHeaders;
  final bool useCustomModel;

  factory AiSettingsProfileModel.fromEntity(AiSettingsProfile profile) {
    return AiSettingsProfileModel(
      id: profile.id,
      name: profile.name,
      provider: profile.provider,
      apiKey: profile.apiKey,
      model: profile.model,
      baseUrl: profile.baseUrl,
      includeCustomHeaders: profile.includeCustomHeaders,
      customHeaders: profile.customHeaders,
      useCustomModel: profile.useCustomModel,
    );
  }

  factory AiSettingsProfileModel.fromJson(Map<String, dynamic> json) {
    final providerName = json['provider'];
    final provider = AiModelProvider.values.where(
      (value) => value.name == providerName,
    );
    if (providerName is! String || provider.isEmpty) {
      throw const FormatException('Provider profil AI tidak valid.');
    }

    final headers = json['customHeaders'];
    if (headers is! Map<String, dynamic>) {
      throw const FormatException('Custom headers profil AI tidak valid.');
    }
    final normalizedHeaders = <String, String>{};
    for (final entry in headers.entries) {
      if (entry.key.trim().isEmpty || entry.value is! String) {
        throw const FormatException('Custom headers profil AI tidak valid.');
      }
      normalizedHeaders[entry.key] = entry.value as String;
    }

    final id = json['id'];
    final name = json['name'];
    final apiKey = json['apiKey'];
    final model = json['model'];
    final baseUrl = json['baseUrl'];
    final includeCustomHeaders = json['includeCustomHeaders'];
    final useCustomModel = json['useCustomModel'];
    if (id is! String ||
        id.trim().isEmpty ||
        name is! String ||
        name.trim().isEmpty ||
        apiKey is! String ||
        model is! String ||
        baseUrl is! String ||
        includeCustomHeaders is! bool ||
        useCustomModel is! bool) {
      throw const FormatException('Data profil AI tidak valid.');
    }

    return AiSettingsProfileModel(
      id: id,
      name: name,
      provider: provider.first,
      apiKey: apiKey,
      model: model,
      baseUrl: baseUrl,
      includeCustomHeaders: includeCustomHeaders,
      customHeaders: normalizedHeaders,
      useCustomModel: useCustomModel,
    );
  }

  AiSettingsProfile toEntity() => AiSettingsProfile(
    id: id,
    name: name,
    provider: provider,
    apiKey: apiKey,
    model: model,
    baseUrl: baseUrl,
    includeCustomHeaders: includeCustomHeaders,
    customHeaders: customHeaders,
    useCustomModel: useCustomModel,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'provider': provider.name,
    'apiKey': apiKey,
    'model': model,
    'baseUrl': baseUrl,
    'includeCustomHeaders': includeCustomHeaders,
    'customHeaders': customHeaders,
    'useCustomModel': useCustomModel,
  };
}
