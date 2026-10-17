import '../../domain/entities/ai_settings.dart' as domain;
import '../../domain/entities/ai_settings_profile.dart';
import '../../domain/entities/ai_settings_profile_collection.dart';
import '../../domain/repositories/ai_settings_repository.dart';
import '../datasources/ai_settings_crypto_service.dart';
import '../datasources/ai_settings_local_datasource.dart';
import '../models/ai_settings_profile_model.dart';

class AiSettingsRepositoryImpl implements AiSettingsRepository {
  const AiSettingsRepositoryImpl(this._local, this._crypto);

  final AiSettingsLocalDataSource _local;
  final AiSettingsCryptoService _crypto;

  @override
  Future<String> encryptSettings(domain.AiSettings settings) =>
      _crypto.encryptSettings(settings);

  @override
  Future<domain.AiSettings> load() async {
    final activeProfileId = await _local.loadActiveProfileId();
    if (activeProfileId != null) {
      final profile = await _findProfile(activeProfileId);
      final providerSettings = await _local.loadProviderSettings(
        profile.provider,
      );
      return profile.toSettings(showAiBubble: providerSettings.showAiBubble);
    }

    final provider = await _local.loadProvider();
    final settings = await _local.loadProviderSettings(provider);
    return domain.AiSettings(
      provider: provider,
      apiKey: settings.apiKey,
      model: settings.model,
      baseUrl: settings.baseUrl,
      showAiBubble: settings.showAiBubble,
      includeCustomHeaders: settings.includeCustomHeaders,
      customHeaders: settings.customHeaders,
      useCustomModel: settings.useCustomModel,
    );
  }

  @override
  Future<domain.AiSettings> changeProvider(
    domain.AiModelProvider provider,
  ) async {
    await _local.saveProvider(provider);
    final settings = await _local.loadProviderSettings(provider);
    final updated = domain.AiSettings(
      provider: provider,
      apiKey: settings.apiKey,
      model: settings.model,
      baseUrl: settings.baseUrl,
      showAiBubble: settings.showAiBubble,
      includeCustomHeaders: settings.includeCustomHeaders,
      customHeaders: settings.customHeaders,
      useCustomModel: settings.useCustomModel,
    );
    await syncActiveProfile(updated);
    return updated;
  }

  @override
  Future<AiSettingsProfileCollection> loadProfiles() async {
    final models = await _local.loadProfiles();
    final savedActiveProfileId = await _local.loadActiveProfileId();
    if (models.isEmpty &&
        savedActiveProfileId == null &&
        !await _local.hasInitializedProfiles()) {
      final provider = await _local.loadProvider();
      final settings = await _local.loadProviderSettings(provider);
      final hasCustomHeaders = settings.customHeaders.entries.any(
        (entry) => entry.key.trim().isNotEmpty && entry.value.trim().isNotEmpty,
      );
      if (settings.apiKey.trim().isNotEmpty || hasCustomHeaders) {
        final profile = AiSettingsProfile.fromSettings(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          name: 'Default',
          settings: domain.AiSettings(
            provider: provider,
            apiKey: settings.apiKey,
            model: settings.model,
            baseUrl: settings.baseUrl,
            showAiBubble: settings.showAiBubble,
            includeCustomHeaders: settings.includeCustomHeaders,
            customHeaders: settings.customHeaders,
            useCustomModel: settings.useCustomModel,
          ),
        );
        await _local.saveProfile(AiSettingsProfileModel.fromEntity(profile));
        await _local.saveActiveProfileId(profile.id);
        await _local.markProfilesInitialized();
      }
    }

    final profiles = (await _local.loadProfiles())
        .map((model) => model.toEntity())
        .toList();
    final activeProfileId = await _local.loadActiveProfileId();
    if (activeProfileId != null &&
        !profiles.any((profile) => profile.id == activeProfileId)) {
      throw const FormatException(
        'Profil AI aktif tidak ditemukan di penyimpanan.',
      );
    }
    return AiSettingsProfileCollection(
      profiles: profiles,
      activeProfileId: activeProfileId,
    );
  }

  @override
  Future<AiSettingsProfileCollection> createProfile(
    String name,
    domain.AiSettings settings,
  ) async {
    final normalizedName = name.trim();
    if (normalizedName.isEmpty) {
      throw const FormatException('Nama profil AI tidak boleh kosong.');
    }
    final existingIds = (await _local.loadProfiles())
        .map((profile) => profile.id)
        .toSet();
    var id = DateTime.now().microsecondsSinceEpoch.toString();
    while (existingIds.contains(id)) {
      id = '$id-1';
    }
    final profile = AiSettingsProfile.fromSettings(
      id: id,
      name: normalizedName,
      settings: settings,
    );
    await _local.saveProfile(AiSettingsProfileModel.fromEntity(profile));
    await _local.saveActiveProfileId(profile.id);
    await _local.markProfilesInitialized();
    return loadProfiles();
  }

  @override
  Future<AiSettingsProfileCollection> updateProfile(
    String profileId,
    domain.AiSettings settings,
  ) async {
    final profile = await _findProfile(profileId);
    await _local.saveProfile(
      AiSettingsProfileModel.fromEntity(profile.withSettings(settings)),
    );
    return loadProfiles();
  }

  @override
  Future<AiSettingsProfileCollection> activateProfile(String profileId) async {
    final profile = await _findProfile(profileId);
    await _local.saveProvider(profile.provider);
    await _local.saveApiKey(profile.provider, profile.apiKey);
    await _local.saveModel(profile.provider, profile.model);
    await _local.saveBaseUrl(profile.provider, profile.baseUrl);
    await _local.saveCustomHeaders(profile.provider, profile.customHeaders);
    await _local.saveIncludeCustomHeaders(
      profile.provider,
      profile.includeCustomHeaders,
    );
    await _local.saveUseCustomModel(profile.provider, profile.useCustomModel);
    await _local.saveActiveProfileId(profile.id);
    return loadProfiles();
  }

  @override
  Future<AiSettingsProfileCollection> deleteProfile(String profileId) async {
    if (await _local.loadActiveProfileId() == profileId) {
      await _local.saveActiveProfileId(null);
    }
    await _local.deleteProfile(profileId);
    await _local.markProfilesInitialized();
    return loadProfiles();
  }

  @override
  Future<void> syncActiveProfile(domain.AiSettings settings) async {
    final profileId = await _local.loadActiveProfileId();
    if (profileId == null) return;
    final profile = await _findProfile(profileId);
    await _local.saveProfile(
      AiSettingsProfileModel.fromEntity(profile.withSettings(settings)),
    );
  }

  Future<AiSettingsProfile> _findProfile(String profileId) async {
    final profiles = await _local.loadProfiles();
    for (final profile in profiles) {
      if (profile.id == profileId) return profile.toEntity();
    }
    throw const FormatException('Profil AI tersimpan tidak ditemukan.');
  }

  @override
  Future<void> saveApiKey(domain.AiModelProvider provider, String value) =>
      _local.saveApiKey(provider, value);

  @override
  Future<void> saveModel(domain.AiModelProvider provider, String value) =>
      _local.saveModel(provider, value);

  @override
  Future<void> saveBaseUrl(domain.AiModelProvider provider, String value) =>
      _local.saveBaseUrl(provider, value);

  @override
  Future<void> saveCustomHeaders(
    domain.AiModelProvider provider,
    Map<String, String> headers,
  ) => _local.saveCustomHeaders(provider, headers);

  @override
  Future<void> saveIncludeCustomHeaders(
    domain.AiModelProvider provider,
    bool include,
  ) => _local.saveIncludeCustomHeaders(provider, include);

  @override
  Future<void> saveUseCustomModel(
    domain.AiModelProvider provider,
    bool useCustom,
  ) => _local.saveUseCustomModel(provider, useCustom);

  @override
  Future<void> saveAiBubbleVisibility(bool visible) =>
      _local.saveAiBubbleVisibility(visible);
}
