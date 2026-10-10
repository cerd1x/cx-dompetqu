import 'package:flutter/foundation.dart';
import 'package:passkeys/authenticator.dart';
import 'package:passkeys/types.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/logger/app_logger.dart';
import '../models/passkey.dart';
import '../models/user.dart';
import 'auth_remote_source.dart';

part 'passkey_service.g.dart';

/// Klien passkey — padanan `@simplewebauthn/browser` di web.
///
/// Menggunakan paket `passkeys` (corbado) yang mengabstraksi WebAuthn native
/// (Android Credential Manager, iOS/Web AuthenticationServices).
class PasskeyService {
  PasskeyService(this._source);

  final AuthRemoteSource _source;
  final PasskeyAuthenticator _authenticator = PasskeyAuthenticator();
  final AppLogger _log = AppLogger.instance;

  Future<bool> get isSupported async {
    try {
      if (kIsWeb) {
        return (await _authenticator.getAvailability().web()).hasPasskeySupport;
      }
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          return (await _authenticator.getAvailability().android())
              .hasPasskeySupport;
        case TargetPlatform.iOS:
        case TargetPlatform.macOS:
          return (await _authenticator.getAvailability().iOS())
              .hasPasskeySupport;
        case TargetPlatform.windows:
          return (await _authenticator.getAvailability().windows())
              .hasPasskeySupport;
        default:
          return false;
      }
    } catch (e) {
      _log.error('Cek dukungan passkey gagal', tag: 'Passkey', error: e);
      return false;
    }
  }

  /// Alur: minta challenge dari server → platform authenticator meminta
  /// biometrik → kirim assertion JSON ke `signInWithPassKey`.
  Future<({User user, String session, String refreshToken})>
  signInWithPasskey() async {
    _log.debug('Passkey sign-in dimulai', tag: 'Passkey');
    try {
      final options = await _source.passkeyAuthenticationOptions();
      final request = AuthenticateRequestType.fromJsonString(options.options);
      final result = await _authenticator.authenticate(request);
      final auth = await _source.signInWithPassKey(
        challenge: options.challenge,
        credentialId: result.id,
        assertionResponse: result.toJsonString(),
      );
      _log.success('Passkey sign-in berhasil', tag: 'Passkey');
      return auth;
    } catch (e) {
      _log.error('Passkey sign-in gagal', tag: 'Passkey', error: e);
      rethrow;
    }
  }

  /// Alur: minta creation options dari server → daftarkan kredensial baru.
  Future<void> registerPasskey({String? deviceName}) async {
    _log.debug('Registrasi passkey dimulai', tag: 'Passkey');
    try {
      final options = await _source.passkeyRegistrationOptions();
      final request = RegisterRequestType.fromJsonString(options.options);
      final result = await _authenticator.register(request);
      await _source.registerPasskey(
        challenge: options.challenge,
        attestationResponse: result.toJsonString(),
        deviceName: deviceName,
      );
      _log.success('Registrasi passkey berhasil', tag: 'Passkey');
    } catch (e) {
      _log.error('Registrasi passkey gagal', tag: 'Passkey', error: e);
      rethrow;
    }
  }

  Future<List<PasskeyCredential>> passkeys() => _source.passkeys();

  Future<bool> deletePasskey(String credentialId) =>
      _source.deletePasskey(credentialId);
}

@Riverpod(keepAlive: true)
PasskeyService passkeyService(Ref ref) =>
    PasskeyService(ref.watch(authRemoteSourceProvider));
