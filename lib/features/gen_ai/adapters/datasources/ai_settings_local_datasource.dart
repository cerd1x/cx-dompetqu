import 'dart:convert';

import 'package:get_it/get_it.dart';

import 'package:dompetqu/core/database/entities/ai_profile_entity.dart';
import 'package:dompetqu/core/database/entities/ai_provider_setting_entity.dart';
import 'package:dompetqu/core/database/entities/ai_settings_meta_entity.dart';
import 'package:dompetqu/core/database/objectbox_database.dart';
import 'package:dompetqu/features/gen_ai/domain/models/ai_settings.dart';
import 'package:dompetqu/features/gen_ai/adapters/models/ai_settings_profile_model.dart';

abstract interface class AiSettingsLocalDataSource {
  Future<AiModelProvider> loadProvider();
  Future<AiProviderSettingsData> loadProviderSettings(AiModelProvider provider);
  Future<List<AiSettingsProfileModel>> loadProfiles();
  Future<void> saveProfile(AiSettingsProfileModel profile);
  Future<void> deleteProfile(String profileId);
  Future<bool> hasInitializedProfiles();
  Future<void> markProfilesInitialized();
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

class ObjectBoxAiSettingsDataSource implements AiSettingsLocalDataSource {
  const ObjectBoxAiSettingsDataSource();

  ObjectBoxDatabase get _db => GetIt.instance.get<ObjectBoxDatabase>();

  AiSettingsMetaEntity _getMeta() {
    return _db.aiSettingsMetaBox.get(1) ?? AiSettingsMetaEntity(id: 1);
  }

  void _saveMeta(AiSettingsMetaEntity meta) {
    _db.aiSettingsMetaBox.put(meta);
  }

  @override
  Future<AiModelProvider> loadProvider() async {
    final meta = _getMeta();
    final name = meta.provider;
    for (final provider in AiModelProvider.values) {
      if (provider.name == name) return provider;
    }
    return AiModelProvider.googleAi;
  }

  AiProviderSettingEntity? _findProviderSetting(AiModelProvider provider) {
    for (final e in _db.aiProviderSettingBox.getAll()) {
      if (e.provider == provider.name) return e;
    }
    return null;
  }

  AiProfileEntity? _findProfile(String profileId) {
    for (final e in _db.aiProfileBox.getAll()) {
      if (e.profileId == profileId) return e;
    }
    return null;
  }

  @override
  Future<AiProviderSettingsData> loadProviderSettings(
    AiModelProvider provider,
  ) async {
    final entity = _findProviderSetting(provider);

    if (entity == null) {
      return AiProviderSettingsData(
        apiKey: '',
        model: provider.defaultModel,
        baseUrl: provider.defaultBaseUrl,
        showAiBubble: _getMeta().showAiBubble,
        includeCustomHeaders: false,
        customHeaders: const {},
        useCustomModel: provider == AiModelProvider.ollama,
      );
    }

    Map<String, String> headers = const {};
    try {
      final decoded = jsonDecode(entity.customHeadersJson);
      if (decoded is Map) {
        headers = decoded.map((k, v) => MapEntry(k.toString(), v.toString()));
      }
    } catch (_) {}

    return AiProviderSettingsData(
      apiKey: entity.apiKey,
      model: entity.model.isNotEmpty ? entity.model : provider.defaultModel,
      baseUrl: entity.baseUrl.isNotEmpty
          ? entity.baseUrl
          : provider.defaultBaseUrl,
      showAiBubble: _getMeta().showAiBubble,
      includeCustomHeaders: entity.includeCustomHeaders,
      customHeaders: headers,
      useCustomModel: entity.useCustomModel,
    );
  }

  @override
  Future<List<AiSettingsProfileModel>> loadProfiles() async {
    final entities = _db.aiProfileBox.getAll();
    final profiles = <AiSettingsProfileModel>[];
    for (final entity in entities) {
      try {
        final decoded = jsonDecode(entity.dataJson);
        if (decoded is Map<String, dynamic>) {
          profiles.add(AiSettingsProfileModel.fromJson(decoded));
        }
      } catch (_) {}
    }
    return profiles;
  }

  @override
  Future<void> saveProfile(AiSettingsProfileModel profile) async {
    final existing =
        _findProfile(profile.id) ?? AiProfileEntity(profileId: profile.id);

    existing.name = profile.name;
    existing.dataJson = jsonEncode(profile.toJson());
    _db.aiProfileBox.put(existing);
  }

  @override
  Future<void> deleteProfile(String profileId) async {
    final entities = _db.aiProfileBox.getAll();
    for (final entity in entities) {
      if (entity.profileId == profileId) {
        _db.aiProfileBox.remove(entity.id);
      }
    }
  }

  @override
  Future<bool> hasInitializedProfiles() async {
    return _getMeta().profilesInitialized;
  }

  @override
  Future<void> markProfilesInitialized() async {
    final meta = _getMeta();
    meta.profilesInitialized = true;
    _saveMeta(meta);
  }

  @override
  Future<String?> loadActiveProfileId() async {
    return _getMeta().activeProfileId;
  }

  @override
  Future<void> saveActiveProfileId(String? profileId) async {
    final meta = _getMeta();
    meta.activeProfileId = profileId;
    _saveMeta(meta);
  }

  @override
  Future<void> saveProvider(AiModelProvider provider) async {
    final meta = _getMeta();
    meta.provider = provider.name;
    _saveMeta(meta);
  }

  AiProviderSettingEntity _getOrCreateProviderSetting(
    AiModelProvider provider,
  ) {
    return _findProviderSetting(provider) ??
        AiProviderSettingEntity(
          provider: provider.name,
          model: provider.defaultModel,
          baseUrl: provider.defaultBaseUrl,
        );
  }

  @override
  Future<void> saveApiKey(AiModelProvider provider, String value) async {
    final setting = _getOrCreateProviderSetting(provider);
    setting.apiKey = value;
    _db.aiProviderSettingBox.put(setting);
  }

  @override
  Future<void> saveModel(AiModelProvider provider, String value) async {
    final setting = _getOrCreateProviderSetting(provider);
    setting.model = value;
    _db.aiProviderSettingBox.put(setting);
  }

  @override
  Future<void> saveBaseUrl(AiModelProvider provider, String value) async {
    final setting = _getOrCreateProviderSetting(provider);
    setting.baseUrl = value;
    _db.aiProviderSettingBox.put(setting);
  }

  @override
  Future<void> saveCustomHeaders(
    AiModelProvider provider,
    Map<String, String> headers,
  ) async {
    final setting = _getOrCreateProviderSetting(provider);
    setting.customHeadersJson = jsonEncode(headers);
    _db.aiProviderSettingBox.put(setting);
  }

  @override
  Future<void> saveIncludeCustomHeaders(
    AiModelProvider provider,
    bool include,
  ) async {
    final setting = _getOrCreateProviderSetting(provider);
    setting.includeCustomHeaders = include;
    _db.aiProviderSettingBox.put(setting);
  }

  @override
  Future<void> saveUseCustomModel(
    AiModelProvider provider,
    bool useCustom,
  ) async {
    final setting = _getOrCreateProviderSetting(provider);
    setting.useCustomModel = useCustom;
    _db.aiProviderSettingBox.put(setting);
  }

  @override
  Future<void> saveAiBubbleVisibility(bool visible) async {
    final meta = _getMeta();
    meta.showAiBubble = visible;
    _saveMeta(meta);
  }
}
