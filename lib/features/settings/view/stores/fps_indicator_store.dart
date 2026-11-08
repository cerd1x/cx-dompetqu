import 'package:get_it/get_it.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:dompetqu/core/database/entities/app_setting_entity.dart';
import 'package:dompetqu/core/database/objectbox_database.dart';

part 'generated/fps_indicator_store.g.dart';

/// Status tampil/sembunyi indikator FPS.
///
/// Dipersist ke ObjectBox lewat [SettingsRepository] (key
/// `show_fps`), bukan lagi ke SharedPreferences.
@Riverpod(keepAlive: true)
class FpsIndicatorStore extends _$FpsIndicatorStore {
  ObjectBoxDatabase get _db => GetIt.instance.get<ObjectBoxDatabase>();

  @override
  Future<bool> build() async {
    final key = 'show_fps';
    for (final e in _db.appSettingBox.getAll()) {
      if (e.key == key) {
        return e.value == 'true';
      }
    }
    return true;
  }

  /// Alias agar pemanggil lama (`setVisible`) tetap berfungsi.
  Future<void> setVisible(bool value) => toggle(value);

  Future<void> toggle(bool value) async {
    final key = 'show_fps';
    AppSettingEntity? existing;
    for (final e in _db.appSettingBox.getAll()) {
      if (e.key == key) {
        existing = e;
        break;
      }
    }
    if (existing == null) {
      _db.appSettingBox.put(
        AppSettingEntity(key: key, value: value.toString()),
      );
    } else {
      existing.value = value.toString();
      _db.appSettingBox.put(existing);
    }
    state = AsyncData(value);
  }
}
