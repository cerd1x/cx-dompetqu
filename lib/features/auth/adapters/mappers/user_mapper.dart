import 'package:cx_dompetqiu/features/auth/domain/models/auth_user.dart';
import 'package:cx_dompetqiu/features/auth/adapters/models/user.dart' as data;

extension AuthUserMapper on data.User {
  AuthUser toEntity() =>
      AuthUser(id: id, name: name, username: username, avatarUrl: avatarUrl);
}
