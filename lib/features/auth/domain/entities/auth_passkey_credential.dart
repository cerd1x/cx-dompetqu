import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/auth_passkey_credential.freezed.dart';

/// Satu kredensial passkey yang terdaftar pada user.
@freezed
abstract class AuthPasskeyCredential with _$AuthPasskeyCredential {
  const factory AuthPasskeyCredential({
    required String id,
    String? deviceName,
    DateTime? createdAt,
  }) = _AuthPasskeyCredential;

  const AuthPasskeyCredential._();
}
