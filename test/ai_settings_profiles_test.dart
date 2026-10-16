import 'package:dompetqu/features/gen_ai/data/datasources/ai_settings_crypto_service.dart';
import 'package:dompetqu/features/gen_ai/data/datasources/ai_settings_local_datasource.dart';
import 'package:dompetqu/features/gen_ai/data/repositories/ai_settings_repository_impl.dart';
import 'package:dompetqu/features/gen_ai/domain/entities/ai_settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _MemoryKeyStore implements AiSettingsSecretKeyStore {
  final Map<String, String> _values = {};

  @override
  Future<String?> read(String key) async => _values[key];

  @override
  Future<void> write(String key, String value) async {
    _values[key] = value;
  }
}

/// Membuat repository di atas SharedPreferences kosong — meniru kondisi nyata
/// saat pengguna menyimpan profil pertama kali.
AiSettingsRepositoryImpl _repository() => AiSettingsRepositoryImpl(
  SharedPreferencesAiSettingsDataSource(),
  AiSettingsCryptoService(keyStore: _MemoryKeyStore()),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AiSettingsRepository profil', () {
    setUp(() => SharedPreferences.setMockInitialValues({}));

    test('createProfile menyimpan profil pertama pada penyimpanan kosong',
        () async {
      final repository = _repository();

      final collection = await repository.createProfile(
        'OpenRouter pribadi',
        const AiSettings(
          provider: AiModelProvider.openAi,
          apiKey: 'test-key',
          model: 'gpt-5-mini',
          baseUrl: 'https://api.openai.com/v1',
        ),
      );

      expect(collection.profiles, hasLength(1));
      expect(collection.profiles.single.name, 'OpenRouter pribadi');
      expect(collection.activeProfileId, collection.profiles.single.id);
    });

    test('profil bertahan setelah dibaca ulang dan bisa dihapus', () async {
      final repository = _repository();
      await repository.createProfile(
        'Profil A',
        const AiSettings(provider: AiModelProvider.ollama, model: 'llama3.2'),
      );
      await repository.createProfile(
        'Profil B',
        const AiSettings(provider: AiModelProvider.anthropic),
      );

      final loaded = await repository.loadProfiles();
      expect(loaded.profiles.map((profile) => profile.name), [
        'Profil A',
        'Profil B',
      ]);

      final deleted = await repository.deleteProfile(loaded.profiles.first.id);
      expect(deleted.profiles.map((profile) => profile.name), ['Profil B']);
      expect(deleted.activeProfileId, loaded.profiles.last.id);
    });

    test('menghapus semua profil lalu menyimpan lagi tetap berhasil', () async {
      final repository = _repository();
      final created = await repository.createProfile(
        'Sementara',
        const AiSettings(provider: AiModelProvider.googleAi),
      );

      final emptied = await repository.deleteProfile(created.profiles.single.id);
      expect(emptied.profiles, isEmpty);
      expect(emptied.activeProfileId, isNull);

      final again = await repository.createProfile(
        'Setelah kosong',
        const AiSettings(provider: AiModelProvider.googleAi),
      );
      expect(again.profiles.single.name, 'Setelah kosong');
    });

    test('activateProfile mengembalikan pengaturan profil terpilih', () async {
      final repository = _repository();
      await repository.createProfile(
        'Profil A',
        const AiSettings(
          provider: AiModelProvider.openAi,
          model: 'gpt-5',
          apiKey: 'key-a',
        ),
      );
      final second = await repository.createProfile(
        'Profil B',
        const AiSettings(
          provider: AiModelProvider.ollama,
          model: 'qwen2.5',
          baseUrl: 'http://localhost:11434/v1',
        ),
      );

      final target = second.profiles.first;
      await repository.activateProfile(target.id);
      final settings = await repository.load();

      expect(settings.provider, AiModelProvider.openAi);
      expect(settings.model, 'gpt-5');
      expect(settings.apiKey, 'key-a');
    });
  });
}
