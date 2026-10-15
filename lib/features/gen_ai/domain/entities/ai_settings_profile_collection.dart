import 'ai_settings_profile.dart';

class AiSettingsProfileCollection {
  const AiSettingsProfileCollection({
    required this.profiles,
    required this.activeProfileId,
  });

  final List<AiSettingsProfile> profiles;
  final String? activeProfileId;
}
