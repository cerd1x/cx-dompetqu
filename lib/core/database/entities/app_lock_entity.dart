import 'package:objectbox/objectbox.dart';

/// Persistensi pengaturan app lock di ObjectBox.
/// Single-row entity (id = 1).
@Entity()
class AppLockEntity {
  AppLockEntity({
    this.id = 1,
    this.enabled = false,
    this.credential = 'pin',
    this.biometric = false,
    this.pinHash,
    this.patternHash,
    this.salt,
  });

  int id = 1;

  bool enabled = false;
  String credential = 'pin'; // 'pin' or 'pattern'
  bool biometric = false;
  String? pinHash;
  String? patternHash;
  String? salt;
}
