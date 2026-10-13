import '../../domain/entities/auth_user.dart';
import '../../models/user.dart' as data;

extension AuthUserMapper on data.User {
  AuthUser toEntity() =>
      AuthUser(id: id, name: name, username: username, avatarUrl: avatarUrl);
}
