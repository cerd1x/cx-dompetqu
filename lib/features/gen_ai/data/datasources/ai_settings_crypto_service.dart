import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/entities/ai_settings.dart';

abstract interface class AiSettingsSecretKeyStore {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
}

class FlutterSecureStorageAiSettingsKeyStore
    implements AiSettingsSecretKeyStore {
  const FlutterSecureStorageAiSettingsKeyStore({
    this._storage = const FlutterSecureStorage(),
  });

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);
}

class AiSettingsCryptoService {
  AiSettingsCryptoService({required this._keyStore});

  static const _keyStorageKey = 'ai_settings_encryption_key_v1';
  static const _algorithm = 'A256GCM';

  final AiSettingsSecretKeyStore _keyStore;
  final AesGcm _cipher = AesGcm.with256bits();
  Future<SecretKey>? _secretKeyFuture;

  Future<String> encryptSettings(AiSettings settings) =>
      encrypt(settings.toPipeDelimitedString());

  Future<String> encrypt(String plaintext) async {
    final secretBox = await _cipher.encrypt(
      utf8.encode(plaintext),
      secretKey: await _secretKey(),
      nonce: _cipher.newNonce(),
    );

    return jsonEncode({
      'version': 1,
      'algorithm': _algorithm,
      'nonce': base64UrlEncode(secretBox.nonce),
      'ciphertext': base64UrlEncode(secretBox.cipherText),
      'mac': base64UrlEncode(secretBox.mac.bytes),
    });
  }

  Future<String> decrypt(String encoded) async {
    final decoded = jsonDecode(encoded);
    if (decoded is! Map<String, dynamic> ||
        decoded['version'] != 1 ||
        decoded['algorithm'] != _algorithm ||
        decoded['nonce'] is! String ||
        decoded['ciphertext'] is! String ||
        decoded['mac'] is! String) {
      throw const FormatException(
        'Format data pengaturan AI terenkripsi tidak valid.',
      );
    }

    final secretBox = SecretBox(
      base64Url.decode(decoded['ciphertext'] as String),
      nonce: base64Url.decode(decoded['nonce'] as String),
      mac: Mac(base64Url.decode(decoded['mac'] as String)),
    );
    final plaintext = await _cipher.decrypt(
      secretBox,
      secretKey: await _secretKey(),
    );
    return utf8.decode(plaintext);
  }

  Future<SecretKey> _secretKey() {
    final existing = _secretKeyFuture;
    if (existing != null) return existing;

    final pending = _loadOrCreateSecretKey();
    _secretKeyFuture = pending;
    return pending.catchError((Object error, StackTrace stackTrace) {
      _secretKeyFuture = null;
      Error.throwWithStackTrace(error, stackTrace);
    });
  }

  Future<SecretKey> _loadOrCreateSecretKey() async {
    final storedKey = await _keyStore.read(_keyStorageKey);
    if (storedKey != null) {
      final bytes = base64Url.decode(storedKey);
      if (bytes.length != 32) {
        throw const FormatException(
          'Kunci enkripsi pengaturan AI tersimpan tidak valid.',
        );
      }
      return SecretKey(bytes);
    }

    final key = await _cipher.newSecretKey();
    await _keyStore.write(
      _keyStorageKey,
      base64UrlEncode(await key.extractBytes()),
    );
    return key;
  }
}
