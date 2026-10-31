import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/auth_user.freezed.dart';

/// Data user yang sedang login — padanan hasil query `CheckAuthorized`
/// di backend.
@freezed
abstract class AuthUser with _$AuthUser {
  const factory AuthUser({
    required String id,
    required String name,
    required String username,
    String? avatarUrl,
  }) = _AuthUser;

  const AuthUser._();
}
