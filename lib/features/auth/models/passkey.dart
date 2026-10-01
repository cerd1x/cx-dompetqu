import 'package:freezed_annotation/freezed_annotation.dart';

part 'passkey.freezed.dart';
part 'passkey.g.dart';

/// JSON string (W3C WebAuthn Level 3) untuk diteruskan ke platform authenticator.
@freezed
abstract class PasskeyOptions with _$PasskeyOptions {
  const factory PasskeyOptions({
    required String options,
    required String challenge,
  }) = _PasskeyOptions;

  factory PasskeyOptions.fromJson(Map<String, dynamic> json) =>
      _$PasskeyOptionsFromJson(json);
}

@freezed
abstract class PasskeyCredential with _$PasskeyCredential {
  const factory PasskeyCredential({
    required String id,
    String? deviceName,
    DateTime? createdAt,
  }) = _PasskeyCredential;

  factory PasskeyCredential.fromJson(Map<String, dynamic> json) =>
      _$PasskeyCredentialFromJson(json);
}
