import 'package:get_it/get_it.dart';

import 'package:cx_dompetqiu/core/database/entities/app_setting_entity.dart';
import 'package:cx_dompetqiu/core/database/objectbox_database.dart';

const String kThemePrefsKey = 'theme';
const String kCurrencyPrefsKey = 'currency';
const String kShowFpsPrefsKey = 'show_fps';

abstract interface class SettingsLocalDataSource {
  Future<String?> readString(String key);
  Future<void> writeString(String key, String value);
}

class ObjectBoxSettingsDataSource implements SettingsLocalDataSource {
  const ObjectBoxSettingsDataSource();

  ObjectBoxDatabase get _db => GetIt.instance.get<ObjectBoxDatabase>();

  AppSettingEntity? _findByKey(String key) {
    for (final e in _db.appSettingBox.getAll()) {
      if (e.key == key) return e;
    }
    return null;
  }

  @override
  Future<String?> readString(String key) async {
    return _findByKey(key)?.value;
  }

  @override
  Future<void> writeString(String key, String value) async {
    final entity = _findByKey(key) ?? AppSettingEntity(key: key);
    entity.value = value;
    _db.appSettingBox.put(entity);
  }
}
