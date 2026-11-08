import 'package:objectbox/objectbox.dart';

/// Meta settings AI — single-row entity (id = 1).
///
/// Menyimpan state global AI: profil aktif, provider aktif,
/// visibilitas bubble, dan flag inisialisasi.
@Entity()
class AiSettingsMetaEntity {
  AiSettingsMetaEntity({
    this.id = 1,
    this.activeProfileId,
    this.profilesInitialized = false,
    this.showAiBubble = true,
    this.provider = 'googleAi',
  });

  int id = 1;

  String? activeProfileId;
  bool profilesInitialized = false;
  bool showAiBubble = true;

  /// Nama [AiModelProvider] yang sedang aktif.
  String provider = 'googleAi';
}
