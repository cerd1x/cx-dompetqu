import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/lock_method.dart';

part 'app_lock_storage.g.dart';

const String _kLockEnabledKey = 'app_lock_enabled';
const String _kLockCredentialKey = 'app_lock_credential';
const String _kLockBiometricKey = 'app_lock_biometric';
const String _kLockPinHashKey = 'app_lock_pin_hash';
const String _kLockPatternHashKey = 'app_lock_pattern_hash';
const String _kLockSaltKey = 'app_lock_salt';

/// Key lama dari model single-method (dibaca sekali saat migrasi).
const String _kLegacyLockMethodKey = 'app_lock_method';

/// Persistensi lokal untuk pengaturan app lock.
/// PIN dan pola disimpan sebagai salted SHA-256 hash.
@Riverpod(keepAlive: true)
AppLockStorage appLockStorage(Ref ref) => AppLockStorage();

class AppLockStorage {
  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  // ---------------------------------------------------------------------------
  // Read
  // ---------------------------------------------------------------------------

  /// Migrasi + perbaikan data sekaligus.
  ///
  /// Jika app lock berstatus aktif tetapi kredensial (PIN/pola) tidak tersimpan
  /// (mis. sisa state dari mode biometric-only lama), data di-reset penuh agar
  /// aplikasi tidak terkunci selamanya tanpa jalur buka.
  Future<void> ensureUsable() async {
    final prefs = await _prefs;
    final enabled = prefs.getBool(_kLockEnabledKey) ?? false;
    if (!enabled) return;

    final credential = await _credentialOrMigrate(prefs);
    if (_hasCredentialHash(prefs, credential)) return;

    await _resetAll(prefs);
  }

  Future<bool> isEnabled() async {
    final prefs = await _prefs;
    return prefs.getBool(_kLockEnabledKey) ?? false;
  }

  /// Kredensial utama (PIN/pola) dengan migrasi dari format lama.
  Future<LockCredential> getCredential() async {
    final prefs = await _prefs;
    return _credentialOrMigrate(prefs);
  }

  /// Membaca credential, menerapkan migrasi dari key lama bila diperlukan.
  Future<LockCredential> _credentialOrMigrate(SharedPreferences prefs) async {
    final raw = prefs.getString(_kLockCredentialKey);
    if (raw != null) {
      return _credentialFromName(raw);
    }

    final legacy = prefs.getString(_kLegacyLockMethodKey);
    if (legacy == null) return LockCredential.pin;

    // Migrasi satu kali dari model single-method.
    final credential = _credentialFromName(legacy);
    final biometricOnly = legacy == 'biometric';
    await prefs.setString(_kLockCredentialKey, credential.name);
    if (biometricOnly) {
      await prefs.setBool(_kLockBiometricKey, true);
    }
    await prefs.remove(_kLegacyLockMethodKey);
    return credential;
  }

  Future<bool> isBiometricEnabled() async {
    final prefs = await _prefs;
    return prefs.getBool(_kLockBiometricKey) ?? false;
  }

  Future<bool> verifyPin(String pin) async {
    final prefs = await _prefs;
    final storedHash = prefs.getString(_kLockPinHashKey);
    final salt = prefs.getString(_kLockSaltKey);
    if (storedHash == null || salt == null) return false;
    return _hashPin(pin, salt) == storedHash;
  }

  Future<bool> verifyPattern(List<int> pattern) async {
    final prefs = await _prefs;
    final storedHash = prefs.getString(_kLockPatternHashKey);
    final salt = prefs.getString(_kLockSaltKey);
    if (storedHash == null || salt == null) return false;
    return _hashPattern(pattern, salt) == storedHash;
  }

  // ---------------------------------------------------------------------------
  // Write
  // ---------------------------------------------------------------------------

  Future<void> setEnabled(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(_kLockEnabledKey, value);
  }

  Future<void> setBiometricEnabled(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(_kLockBiometricKey, value);
  }

  Future<void> savePin(String pin) async {
    final prefs = await _prefs;
    final salt = _generateSalt();
    await prefs.setString(_kLockSaltKey, salt);
    await prefs.setString(_kLockPinHashKey, _hashPin(pin, salt));
    await prefs.setString(_kLockCredentialKey, LockCredential.pin.name);
  }

  Future<void> savePattern(List<int> pattern) async {
    final prefs = await _prefs;
    final salt = _generateSalt();
    await prefs.setString(_kLockSaltKey, salt);
    await prefs.setString(_kLockPatternHashKey, _hashPattern(pattern, salt));
    await prefs.setString(_kLockCredentialKey, LockCredential.pattern.name);
  }

  Future<void> clearAll() async {
    final prefs = await _prefs;
    await _resetAll(prefs);
  }

  /// Menghapus semua key app lock (dipisah agar bisa dipakai untuk repair).
  Future<void> _resetAll(SharedPreferences prefs) async {
    await prefs.remove(_kLockEnabledKey);
    await prefs.remove(_kLockCredentialKey);
    await prefs.remove(_kLockBiometricKey);
    await prefs.remove(_kLockPinHashKey);
    await prefs.remove(_kLockPatternHashKey);
    await prefs.remove(_kLockSaltKey);
    await prefs.remove(_kLegacyLockMethodKey);
  }

  // ---------------------------------------------------------------------------
  // Hashing helpers
  // ---------------------------------------------------------------------------

  LockCredential _credentialFromName(String raw) {
    return LockCredential.values.firstWhere(
      (c) => c.name == raw,
      orElse: () => LockCredential.pin,
    );
  }

  /// Apakah salt + hash untuk kredensial tertentu tersimpan?
  bool _hasCredentialHash(SharedPreferences prefs, LockCredential credential) {
    final salt = prefs.getString(_kLockSaltKey);
    if (salt == null) return false;
    final hashKey = credential == LockCredential.pin
        ? _kLockPinHashKey
        : _kLockPatternHashKey;
    return prefs.getString(hashKey) != null;
  }

  String _generateSalt() {
    final rng = Random.secure();
    final bytes = Uint8List.fromList(
      List<int>.generate(16, (_) => rng.nextInt(256)),
    );
    return base64Url.encode(bytes);
  }

  String _hashPin(String pin, String salt) {
    final bytes = utf8.encode('$pin:$salt');
    return sha256.convert(bytes).toString();
  }

  String _hashPattern(List<int> pattern, String salt) {
    final patternStr = pattern.join(',');
    final bytes = utf8.encode('$patternStr:$salt');
    return sha256.convert(bytes).toString();
  }
}
