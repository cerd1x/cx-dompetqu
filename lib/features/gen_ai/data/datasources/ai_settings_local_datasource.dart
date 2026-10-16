import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/ai_settings.dart';
import '../models/ai_settings_profile_model.dart';

abstract interface class AiSettingsLocalDataSource {
  Future<AiModelProvider> loadProvider();
  Future<AiProviderSettingsData> loadProviderSettings(AiModelProvider provider);
  Future<List<AiSettingsProfileModel>> loadProfiles();
  Future<void> saveProfile(AiSettingsProfileModel profile);
  Future<void> deleteProfile(String profileId);
  Future<String?> loadActiveProfileId();
  Future<void> saveActiveProfileId(String? profileId);
  Future<void> saveProvider(AiModelProvider provider);
  Future<void> saveApiKey(AiModelProvider provider, String value);
  Future<void> saveModel(AiModelProvider provider, String value);
  Future<void> saveBaseUrl(AiModelProvider provider, String value);
  Future<void> saveCustomHeaders(
    AiModelProvider provider,
    Map<String, String> headers,
  );
  Future<void> saveIncludeCustomHeaders(AiModelProvider provider, bool include);
  Future<void> saveUseCustomModel(AiModelProvider provider, bool useCustom);
  Future<void> saveAiBubbleVisibility(bool visible);
}

class AiProviderSettingsData {
  const AiProviderSettingsData({
    required this.apiKey,
    required this.model,
    required this.baseUrl,
    required this.showAiBubble,
    required this.includeCustomHeaders,
    required this.customHeaders,
    required this.useCustomModel,
  });

  final String apiKey;
  final String model;
  final String baseUrl;
  final bool showAiBubble;
  final bool includeCustomHeaders;
  final Map<String, String> customHeaders;
  final bool useCustomModel;
}

class SharedPreferencesAiSettingsDataSource
    implements AiSettingsLocalDataSource {
  static const _profilesKey = 'ai_settings_profiles';
  static const _activeProfileIdKey = 'ai_settings_active_profile_id';

  @override
  Future<AiProviderSettingsData> loadProviderSettings(
    AiModelProvider provider,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    return AiProviderSettingsData(
      apiKey:
          prefs.getString(_apiKeyKey(provider)) ??
          (provider == AiModelProvider.googleAi
              ? prefs.getString('ai_api_key')
              : null) ??
          '',
      model:
          prefs.getString(_modelKey(provider)) ??
          (provider == AiModelProvider.googleAi
              ? prefs.getString('ai_model')
              : null) ??
          provider.defaultModel,
      baseUrl:
          prefs.getString(_baseUrlKey(provider)) ?? provider.defaultBaseUrl,
      showAiBubble: prefs.getBool('ai_bubble_enabled') ?? true,
      includeCustomHeaders:
          prefs.getBool(_includeCustomHeadersKey(provider)) ?? false,
      customHeaders: _decodeHeaders(
        prefs.getString(_customHeadersKey(provider)),
      ),
      useCustomModel:
          prefs.getBool(_useCustomModelKey(provider)) ??
          provider == AiModelProvider.ollama,
    );
  }

  @override
  Future<List<AiSettingsProfileModel>> loadProfiles() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = prefs.getString(_profilesKey);
    // Wajib list yang bisa dimutasi: pemanggil (save/delete profil) menambah
    // atau menghapus item dari hasil ini.
    if (encoded == null) return <AiSettingsProfileModel>[];

    final decoded = jsonDecode(encoded);
    if (decoded is! List) {
      throw const FormatException('Daftar profil AI tersimpan tidak valid.');
    }
    final profiles = [
      for (final value in decoded)
        AiSettingsProfileModel.fromJson(_normalizeMap(value)),
    ];
    final profileIds = <String>{};
    for (final profile in profiles) {
      if (!profileIds.add(profile.id)) {
        throw const FormatException('ID profil AI tersimpan duplikat.');
      }
    }
    return profiles;
  }

  @override
  Future<void> saveProfile(AiSettingsProfileModel profile) async {
    final profiles = await loadProfiles();
    final index = profiles.indexWhere((item) => item.id == profile.id);
    if (index == -1) {
      profiles.add(profile);
    } else {
      profiles[index] = profile;
    }
    final saved = await (await SharedPreferences.getInstance()).setString(
      _profilesKey,
      jsonEncode(profiles.map((item) => item.toJson()).toList()),
    );
    if (!saved) {
      throw StateError(
        'Gagal menyimpan daftar profil AI ke penyimpanan lokal.',
      );
    }
  }

  @override
  Future<void> deleteProfile(String profileId) async {
    final profiles = await loadProfiles();
    profiles.removeWhere((profile) => profile.id == profileId);
    await (await SharedPreferences.getInstance()).setString(
      _profilesKey,
      jsonEncode(profiles.map((item) => item.toJson()).toList()),
    );
  }

  @override
  Future<String?> loadActiveProfileId() async =>
      (await SharedPreferences.getInstance()).getString(_activeProfileIdKey);

  @override
  Future<void> saveActiveProfileId(String? profileId) async {
    final prefs = await SharedPreferences.getInstance();
    if (profileId == null) {
      await prefs.remove(_activeProfileIdKey);
      return;
    }
    final saved = await prefs.setString(_activeProfileIdKey, profileId);
    if (!saved) {
      throw StateError('Gagal menyimpan profil AI aktif ke penyimpanan lokal.');
    }
  }

  @override
  Future<void> saveProvider(AiModelProvider provider) async {
    await (await SharedPreferences.getInstance()).setString(
      'ai_model_provider',
      provider.name,
    );
  }

  @override
  Future<void> saveApiKey(AiModelProvider provider, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiKeyKey(provider), value);
    if (provider == AiModelProvider.googleAi) {
      await prefs.setString('ai_api_key', value);
    }
  }

  @override
  Future<void> saveModel(AiModelProvider provider, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_modelKey(provider), value);
    if (provider == AiModelProvider.googleAi) {
      await prefs.setString('ai_model', value);
    }
  }

  @override
  Future<void> saveBaseUrl(AiModelProvider provider, String value) async {
    await (await SharedPreferences.getInstance()).setString(
      _baseUrlKey(provider),
      value,
    );
  }

  @override
  Future<void> saveCustomHeaders(
    AiModelProvider provider,
    Map<String, String> headers,
  ) async {
    await (await SharedPreferences.getInstance()).setString(
      _customHeadersKey(provider),
      jsonEncode(headers),
    );
  }

  @override
  Future<void> saveIncludeCustomHeaders(
    AiModelProvider provider,
    bool include,
  ) async {
    await (await SharedPreferences.getInstance()).setBool(
      _includeCustomHeadersKey(provider),
      include,
    );
  }

  @override
  Future<void> saveUseCustomModel(
    AiModelProvider provider,
    bool useCustom,
  ) async {
    await (await SharedPreferences.getInstance()).setBool(
      _useCustomModelKey(provider),
      useCustom,
    );
  }

  @override
  Future<void> saveAiBubbleVisibility(bool visible) async {
    await (await SharedPreferences.getInstance()).setBool(
      'ai_bubble_enabled',
      visible,
    );
  }

  static String _apiKeyKey(AiModelProvider provider) =>
      'ai_${provider.storageKey}_api_key';
  static String _modelKey(AiModelProvider provider) =>
      'ai_${provider.storageKey}_model';
  static String _baseUrlKey(AiModelProvider provider) =>
      'ai_${provider.storageKey}_base_url';
  static String _customHeadersKey(AiModelProvider provider) =>
      'ai_${provider.storageKey}_custom_headers';
  static String _includeCustomHeadersKey(AiModelProvider provider) =>
      'ai_${provider.storageKey}_include_custom_headers';
  static String _useCustomModelKey(AiModelProvider provider) =>
      'ai_${provider.storageKey}_use_custom_model';

  static Map<String, String> _decodeHeaders(String? encoded) {
    if (encoded == null) return const {};
    final decoded = jsonDecode(encoded);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Custom headers AI harus berupa objek JSON.');
    }
    final headers = <String, String>{};
    for (final entry in decoded.entries) {
      if (entry.key.trim().isEmpty || entry.value is! String) {
        throw const FormatException('Format custom headers AI tidak valid.');
      }
      headers[entry.key] = entry.value as String;
    }
    return headers;
  }

  Map<String, dynamic> _normalizeMap(Object? value) {
    if (value is! Map) {
      throw const FormatException('Data profil AI tersimpan tidak valid.');
    }
    final normalized = <String, dynamic>{};
    for (final entry in value.entries) {
      if (entry.key is! String) {
        throw const FormatException('Data profil AI tersimpan tidak valid.');
      }
      normalized[entry.key as String] = entry.value;
    }
    return normalized;
  }

  @override
  Future<AiModelProvider> loadProvider() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('ai_model_provider');
    if (name == null) return AiModelProvider.googleAi;
    for (final provider in AiModelProvider.values) {
      if (provider.name == name) return provider;
    }
    throw FormatException('Provider AI tersimpan tidak dikenal: $name');
  }
}
