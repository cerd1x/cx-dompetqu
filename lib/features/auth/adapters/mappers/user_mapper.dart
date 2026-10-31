import 'package:dompetqu/features/auth/domain/models/auth_user.dart';
import 'package:dompetqu/features/auth/models/user.dart' as data;

extension AuthUserMapper on data.User {
  AuthUser toEntity() =>
      AuthUser(id: id, name: name, username: username, avatarUrl: avatarUrl);
}
