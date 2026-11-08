import 'package:objectbox/objectbox.dart';

/// Key-value setting generik (theme, currency, show_fps, dll).
@Entity()
class AppSettingEntity {
  AppSettingEntity({this.id = 0, this.key = '', this.value = ''});

  int id = 0;

  @Index()
  String key = '';
  String value = '';
}
