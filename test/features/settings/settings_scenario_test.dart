import 'package:flutter_test/flutter_test.dart';

import 'package:cx_dompetqiu/features/settings/adapters/datasources/settings_local_datasource.dart';
import 'package:cx_dompetqiu/features/settings/adapters/repositories/settings_repository_impl.dart';

class _FakeLocal implements SettingsLocalDataSource {
  _FakeLocal([Map<String, String>? initial]) : values = {...?initial};

  final Map<String, String> values;

  @override
  Future<String?> readString(String key) async => values[key];

  @override
  Future<void> writeString(String key, String value) async =>
      values[key] = value;
}

void main() {
  group('Skenario default pengaturan', () {
    test('tanpa data tersimpan: dark mode, IDR, FPS tampil', () async {
      final repository = SettingsRepositoryImpl(_FakeLocal());

      expect(await repository.loadDarkMode(), isTrue);
      expect(await repository.loadCurrency(), 'IDR');
      expect(await repository.loadShowFps(), isTrue);
    });

    test('tema terang tersimpan dibaca sebagai false', () async {
      final repository = SettingsRepositoryImpl(
        _FakeLocal({kThemePrefsKey: 'light'}),
      );

      expect(await repository.loadDarkMode(), isFalse);
    });

    test('nilai tema tak dikenal dianggap bukan dark', () async {
      final repository = SettingsRepositoryImpl(
        _FakeLocal({kThemePrefsKey: 'sepia'}),
      );

      expect(await repository.loadDarkMode(), isFalse);
    });

    test('FPS dimatikan hanya bila nilai "off"', () async {
      expect(
        await SettingsRepositoryImpl(
          _FakeLocal({kShowFpsPrefsKey: 'off'}),
        ).loadShowFps(),
        isFalse,
      );
      expect(
        await SettingsRepositoryImpl(
          _FakeLocal({kShowFpsPrefsKey: 'on'}),
        ).loadShowFps(),
        isTrue,
      );
    });

    test('mata uang tersimpan dipakai', () async {
      final repository = SettingsRepositoryImpl(
        _FakeLocal({kCurrencyPrefsKey: 'USD'}),
      );

      expect(await repository.loadCurrency(), 'USD');
    });
  });

  group('Skenario penyimpanan pengaturan', () {
    test('setiap save menulis key yang benar', () async {
      final local = _FakeLocal();
      final repository = SettingsRepositoryImpl(local);

      await repository.saveDarkMode(false);
      await repository.saveCurrency('EUR');
      await repository.saveShowFps(false);

      expect(local.values[kThemePrefsKey], 'light');
      expect(local.values[kCurrencyPrefsKey], 'EUR');
      expect(local.values[kShowFpsPrefsKey], 'off');
    });

    test('dark mode & FPS aktif menulis nilai on/dark', () async {
      final local = _FakeLocal();
      final repository = SettingsRepositoryImpl(local);

      await repository.saveDarkMode(true);
      await repository.saveShowFps(true);

      expect(local.values[kThemePrefsKey], 'dark');
      expect(local.values[kShowFpsPrefsKey], 'on');
    });

    test('save lalu load mengembalikan nilai terbaru', () async {
      final repository = SettingsRepositoryImpl(_FakeLocal());

      await repository.saveDarkMode(false);
      await repository.saveCurrency('JPY');

      expect(await repository.loadDarkMode(), isFalse);
      expect(await repository.loadCurrency(), 'JPY');
    });
  });
}
