import 'package:freezed_annotation/freezed_annotation.dart';

import 'ai_settings_profile.dart';

part 'generated/ai_settings_profile_collection.freezed.dart';

/// Kumpulan profil AI plus penanda profil yang sedang aktif.
@freezed
abstract class AiSettingsProfileCollection with _$AiSettingsProfileCollection {
  const factory AiSettingsProfileCollection({
    required List<AiSettingsProfile> profiles,
    required String? activeProfileId,
  }) = _AiSettingsProfileCollection;

  const AiSettingsProfileCollection._();
}
