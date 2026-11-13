import 'package:flutter_test/flutter_test.dart';

import 'package:cx_dompetqiu/features/gen_ai/adapters/models/ai_settings_profile_model.dart';
import 'package:cx_dompetqiu/features/gen_ai/domain/models/ai_settings.dart';
import 'package:cx_dompetqiu/features/gen_ai/domain/models/ai_settings_profile.dart';
import 'package:cx_dompetqiu/features/gen_ai/domain/models/skill_store_entry.dart';

void main() {
  group('Skenario serialisasi pengaturan AI', () {
    test('nilai dipecah dengan pipe dan urutan tetap', () {
      const settings = AiSettings(
        provider: AiModelProvider.anthropic,
        apiKey: 'sk-ant',
        model: 'claude-sonnet-4-5',
        baseUrl: 'https://api.anthropic.com',
        showAiBubble: false,
        includeCustomHeaders: true,
        customHeaders: {'B': '2', 'A': '1'},
        useCustomModel: true,
      );

      final parts = settings.toPipeDelimitedString().split('|');

      expect(parts, hasLength(8));
      expect(parts[0], 'anthropic');
      expect(parts[1], 'sk-ant');
      expect(parts[2], 'claude-sonnet-4-5');
      expect(parts[3], 'https://api.anthropic.com');
      expect(parts[4], 'false');
      expect(parts[5], 'true');
      // Header diurutkan berdasarkan key agar hasil deterministik.
      expect(parts[6], '{"A":"1","B":"2"}');
      expect(parts[7], 'true');
    });

    test('default pengaturan memakai Google AI', () {
      const settings = AiSettings();

      expect(settings.provider, AiModelProvider.googleAi);
      expect(settings.model, kDefaultAiModel);
      expect(settings.showAiBubble, isTrue);
      expect(settings.customHeaders, isEmpty);
      expect(settings.useCustomModel, isFalse);
    });
  });

  group('Skenario metadata provider', () {
    test('label setiap provider terbaca', () {
      expect(AiModelProvider.googleAi.label, 'Google AI');
      expect(AiModelProvider.anthropic.label, 'Anthropic');
      expect(AiModelProvider.openAi.label, 'OpenAI');
      expect(AiModelProvider.ollama.label, 'Ollama');
      expect(AiModelProvider.openRouter.label, isNotEmpty);
    });

    test('default model sesuai provider', () {
      expect(AiModelProvider.googleAi.defaultModel, kDefaultAiModel);
      expect(AiModelProvider.anthropic.defaultModel, 'claude-sonnet-4-5');
      expect(AiModelProvider.openAi.defaultModel, 'gpt-5-mini');
      expect(AiModelProvider.ollama.defaultModel, 'llama3.2');
      expect(AiModelProvider.openRouter.defaultModel, isNotEmpty);
    });

    test('storage key unik dan stabil', () {
      final keys = AiModelProvider.values
          .map((p) => p.storageKey)
          .toList(growable: false);

      expect(keys, containsAll(['google_ai', 'anthropic', 'open_ai', 'ollama']));
      expect(keys.toSet(), hasLength(keys.length));
    });

    test('base URL default tiap provider', () {
      expect(
        AiModelProvider.googleAi.defaultBaseUrl,
        'https://generativelanguage.googleapis.com',
      );
      expect(
        AiModelProvider.ollama.defaultBaseUrl,
        'http://localhost:11434/v1',
      );
    });
  });

  group('Skenario profil AI', () {
    test('fromSettings menyalin field yang relevan (tanpa showAiBubble)', () {
      const settings = AiSettings(
        provider: AiModelProvider.openAi,
        apiKey: 'sk',
        model: 'gpt-5-mini',
        baseUrl: 'https://api.openai.com/v1',
        showAiBubble: false,
        customHeaders: {'X-A': '1'},
        includeCustomHeaders: true,
      );

      final profile = AiSettingsProfile.fromSettings(
        id: 'p1',
        name: 'Kerja',
        settings: settings,
      );

      expect(profile.id, 'p1');
      expect(profile.name, 'Kerja');
      expect(profile.provider, AiModelProvider.openAi);
      expect(profile.apiKey, 'sk');
      expect(profile.customHeaders, {'X-A': '1'});
      expect(profile.includeCustomHeaders, isTrue);
    });

    test('toSettings memakai showAiBubble dari pemanggil', () {
      const profile = AiSettingsProfile(
        id: 'p1',
        name: 'Kerja',
        provider: AiModelProvider.ollama,
        apiKey: '',
        model: 'llama3.2',
        baseUrl: 'http://localhost:11434/v1',
        includeCustomHeaders: false,
        customHeaders: {},
        useCustomModel: false,
      );

      final settings = profile.toSettings(showAiBubble: true);

      expect(settings.showAiBubble, isTrue);
      expect(settings.provider, AiModelProvider.ollama);
      expect(settings.model, 'llama3.2');
    });

    test('withSettings mempertahankan id & nama profil', () {
      const profile = AiSettingsProfile(
        id: 'p1',
        name: 'Lama',
        provider: AiModelProvider.googleAi,
        apiKey: '',
        model: kDefaultAiModel,
        baseUrl: 'https://generativelanguage.googleapis.com',
        includeCustomHeaders: false,
        customHeaders: {},
        useCustomModel: false,
      );

      final updated = profile.withSettings(
        const AiSettings(model: 'gemini-2.5-pro', apiKey: 'key'),
      );

      expect(updated.id, 'p1');
      expect(updated.name, 'Lama');
      expect(updated.model, 'gemini-2.5-pro');
      expect(updated.apiKey, 'key');
    });
  });

  group('Skenario model profil AI (JSON)', () {
    Map<String, dynamic> validJson() => {
      'id': 'p1',
      'name': 'Kerja',
      'provider': 'openAi',
      'apiKey': 'sk',
      'model': 'gpt-5-mini',
      'baseUrl': 'https://api.openai.com/v1',
      'includeCustomHeaders': true,
      'customHeaders': {'X-A': '1'},
      'useCustomModel': false,
    };

    test('JSON valid diparse dan roundtrip stabil', () {
      final model = AiSettingsProfileModel.fromJson(validJson());

      expect(model.id, 'p1');
      expect(model.provider, AiModelProvider.openAi);
      expect(model.customHeaders, {'X-A': '1'});

      final json = model.toJson();
      final again = AiSettingsProfileModel.fromJson(json);

      expect(again.toJson(), json);
    });

    test('fromEntity & toEntity bolak-balik setara', () {
      final model = AiSettingsProfileModel.fromJson(validJson());
      final entity = model.toEntity();
      final back = AiSettingsProfileModel.fromEntity(entity);

      expect(back.toJson(), model.toJson());
      expect(entity.name, 'Kerja');
      expect(entity.includeCustomHeaders, isTrue);
    });

    test('provider tidak dikenal ditolak', () {
      final json = validJson()..['provider'] = 'mistral';

      expect(
        () => AiSettingsProfileModel.fromJson(json),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            contains('Provider'),
          ),
        ),
      );
    });

    test('customHeaders bukan map ditolak', () {
      final json = validJson()..['customHeaders'] = ['X-A'];

      expect(
        () => AiSettingsProfileModel.fromJson(json),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            contains('headers'),
          ),
        ),
      );
    });

    test('header dengan key kosong ditolak', () {
      final json = validJson()..['customHeaders'] = {'  ': '1'};

      expect(
        () => AiSettingsProfileModel.fromJson(json),
        throwsA(isA<FormatException>()),
      );
    });

    test('header dengan value bukan String ditolak', () {
      final json = validJson()..['customHeaders'] = {'X-A': 1};

      expect(
        () => AiSettingsProfileModel.fromJson(json),
        throwsA(isA<FormatException>()),
      );
    });

    test('field wajib hilang/kosong ditolak', () {
      final missingId = validJson()..remove('id');
      final emptyName = validJson()..['name'] = '   ';
      final nonBool = validJson()..['useCustomModel'] = 'false';

      for (final json in [missingId, emptyName, nonBool]) {
        expect(
          () => AiSettingsProfileModel.fromJson(json),
          throwsA(
            isA<FormatException>().having(
              (e) => e.message,
              'message',
              contains('Data profil'),
            ),
          ),
        );
      }
    });
  });

  group('Skenario katalog skill', () {
    test('perintah instalasi memakai source dan slug', () {
      const entry = SkillStoreEntry(
        id: 'vercel-labs/skills/find-skills',
        slug: 'find-skills',
        name: 'Find Skills',
        source: 'vercel-labs/skills',
        installs: 3900000,
      );

      expect(
        entry.installCommand,
        'npx skills add vercel-labs/skills --skill find-skills',
      );
    });

    test('pilihan view katalog memiliki label/query/path', () {
      expect(
        SkillStoreView.values.map((v) => v.label),
        ['All-time', 'Trending', 'Hot'],
      );
      expect(SkillStoreView.trending.query, 'trending');
      expect(SkillStoreView.hot.path, '/hot');
    });
  });
}
