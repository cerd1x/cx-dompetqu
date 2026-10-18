import 'dart:convert';

import 'package:dompetqu/features/gen_ai/data/datasources/ai_settings_crypto_service.dart';
import 'package:dompetqu/features/gen_ai/domain/entities/ai_settings.dart';
import 'package:flutter_test/flutter_test.dart';

class _MemoryKeyStore implements AiSettingsSecretKeyStore {
  final Map<String, String> _values = {};

  @override
  Future<String?> read(String key) async => _values[key];

  @override
  Future<void> write(String key, String value) async {
    _values[key] = value;
  }
}

void main() {
  group('AiSettings serialization and encryption', () {
    test('serializes properties in declaration order', () {
      final settings = AiSettings(
        provider: AiModelProvider.openAi,
        apiKey: 'test-key',
        model: 'gpt-5-mini',
        baseUrl: 'https://api.openai.com/v1',
        showAiBubble: false,
        includeCustomHeaders: true,
        customHeaders: const {'X-Z': 'last', 'X-A': 'first'},
        useCustomModel: true,
      );

      expect(
        settings.toPipeDelimitedString(),
        'openAi|test-key|gpt-5-mini|https://api.openai.com/v1|false|true|'
        '{"X-A":"first","X-Z":"last"}|true',
      );
    });

    test('encrypts and decrypts the serialized settings', () async {
      final settings = AiSettings(
        provider: AiModelProvider.openAi,
        apiKey: 'test-key',
        model: 'gpt-5-mini',
        baseUrl: 'https://api.openai.com/v1',
        showAiBubble: false,
        includeCustomHeaders: true,
        customHeaders: const {'X-App': 'DompetQu'},
        useCustomModel: true,
      );
      final crypto = AiSettingsCryptoService(keyStore: _MemoryKeyStore());

      final encrypted = await crypto.encryptSettings(settings);
      final payload = jsonDecode(encrypted) as Map<String, dynamic>;

      expect(payload['version'], 1);
      expect(payload['algorithm'], 'A256GCM');
      expect(payload['ciphertext'], isNot(contains('test-key')));
      expect(await crypto.decrypt(encrypted), settings.toPipeDelimitedString());
    });

    test('uses a new nonce for each encryption', () async {
      final crypto = AiSettingsCryptoService(keyStore: _MemoryKeyStore());

      final first = jsonDecode(await crypto.encrypt('same value'));
      final second = jsonDecode(await crypto.encrypt('same value'));

      expect(first['nonce'], isNot(second['nonce']));
      expect(first['ciphertext'], isNot(second['ciphertext']));
    });
  });
}
