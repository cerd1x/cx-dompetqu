import '../../models/passkey.dart';
import '../../models/user.dart';

abstract interface class AuthRemoteDataSource {
  Future<({User user, String session, String refreshToken})> signUp({
    required String name,
    required String username,
    required String password,
  });

  Future<({User user, String session, String refreshToken})> signIn({
    required String username,
    required String password,
  });

  Future<void> signOut();
  Future<bool> checkAuthorized();
  Future<User?> me();
  Future<PasskeyOptions> passkeyAuthenticationOptions();
  Future<PasskeyOptions> passkeyRegistrationOptions();
  Future<({User user, String session, String refreshToken})> signInWithPassKey({
    required String challenge,
    required String credentialId,
    required String assertionResponse,
  });
  Future<bool> registerPasskey({
    required String challenge,
    required String attestationResponse,
    String? deviceName,
  });
  Future<List<PasskeyCredential>> passkeys();
  Future<bool> deletePasskey(String credentialId);
}
