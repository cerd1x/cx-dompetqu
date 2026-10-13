import '../../models/passkey.dart';
import '../../models/user.dart';

abstract interface class PasskeyDataSource {
  Future<bool> get isSupported;
  Future<({User user, String session, String refreshToken})>
  signInWithPasskey();
  Future<void> registerPasskey({String? deviceName});
  Future<List<PasskeyCredential>> passkeys();
  Future<bool> deletePasskey(String credentialId);
}
