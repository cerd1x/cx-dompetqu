import 'package:objectbox/objectbox.dart';

/// Profil AI tersimpan — serialisasi JSON dari AiSettingsProfileModel.
@Entity()
class AiProfileEntity {
  AiProfileEntity({
    this.id = 0,
    this.profileId = '',
    this.name = '',
    this.dataJson = '',
  });

  int id = 0;

  @Index()
  @Unique()
  String profileId = '';
  String name = '';

  /// Full [AiSettingsProfileModel.toJson()].
  String dataJson = '';
}
