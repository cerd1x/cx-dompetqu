import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';

import 'entities/app_lock_entity.dart';
import 'entities/app_setting_entity.dart';
import 'entities/debt_settlement_entity.dart';
import 'entities/ai_profile_entity.dart';
import 'entities/ai_provider_setting_entity.dart';
import 'entities/ai_settings_meta_entity.dart';
import 'entities/ai_skill_entity.dart';
import 'entities/mcp_server_entity.dart';
import 'entities/report_entity.dart';
import 'generated/objectbox.g.dart';

/// ObjectBox database untuk persistensi lokal.
/// Menggantikan SharedPreferences untuk semua data non-secure.
class ObjectBoxDatabase {
  ObjectBoxDatabase._(this._store);

  final Store _store;

  /// Box accessors — satu box per entity type.
  late final Box<AppLockEntity> appLockBox = Box(_store);
  late final Box<AppSettingEntity> appSettingBox = Box(_store);
  late final Box<DebtSettlementEntity> debtSettlementBox = Box(_store);
  late final Box<AiProfileEntity> aiProfileBox = Box(_store);
  late final Box<AiProviderSettingEntity> aiProviderSettingBox = Box(_store);
  late final Box<AiSettingsMetaEntity> aiSettingsMetaBox = Box(_store);
  late final Box<AiSkillEntity> aiSkillBox = Box(_store);
  late final Box<McpServerEntity> mcpServerBox = Box(_store);
  late final Box<ReportEntity> reportBox = Box(_store);

  /// Initialize ObjectBox dan register ke GetIt.
  static Future<ObjectBoxDatabase> create() async {
    final dir = await getApplicationDocumentsDirectory();
    final store = Store(
      getObjectBoxModel(),
      directory: '${dir.path}/objectbox-dompetqu',
    );
    final db = ObjectBoxDatabase._(store);
    GetIt.I.registerSingleton<ObjectBoxDatabase>(db);
    return db;
  }

  /// Membuat database in-memory untuk testing.
  ///
  /// Dipakai di test agar tidak bergantung pada filesystem.
  /// Panggil di `setUpAll` dan `tearDownAll`.
  static Future<ObjectBoxDatabase> createInMemory() async {
    final store = Store(getObjectBoxModel(), directory: 'memory:dompetqu-test');
    final db = ObjectBoxDatabase._(store);
    GetIt.I.registerSingleton<ObjectBoxDatabase>(db);
    return db;
  }

  /// Tutup store saat app di-dispose.
  void close() {
    _store.close();
  }
}
