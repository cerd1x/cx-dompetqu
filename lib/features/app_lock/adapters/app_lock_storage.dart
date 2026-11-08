import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:dompetqu/core/database/entities/app_lock_entity.dart';
import 'package:dompetqu/core/database/objectbox_database.dart';
import 'package:dompetqu/features/app_lock/adapters/datasources/app_lock_datasources.dart';
import 'package:dompetqu/features/app_lock/domain/models/app_lock_state.dart';

part 'generated/app_lock_storage.g.dart';

/// Persistensi lokal untuk pengaturan app lock.
/// PIN dan pola disimpan sebagai salted SHA-256 hash.
@Riverpod(keepAlive: true)
AppLockStorage appLockStorage(Ref ref) => AppLockStorage();

class AppLockStorage implements AppLockLocalDataSource {
  ObjectBoxDatabase get _db => GetIt.instance.get<ObjectBoxDatabase>();

  // ---------------------------------------------------------------------------
  // Read
  // ---------------------------------------------------------------------------

  @override
  Future<void> ensureUsable() async {
    final entity = _db.appLockBox.get(1);
    if (entity == null || !entity.enabled) return;

    final hasHash =
        (entity.credential == 'pin' && entity.pinHash != null) ||
        (entity.credential == 'pattern' && entity.patternHash != null);

    if (hasHash) return;

    await clearAll();
  }

  @override
  Future<bool> isEnabled() async {
    final entity = _db.appLockBox.get(1);
    return entity?.enabled ?? false;
  }

  @override
  Future<LockCredential> getCredential() async {
    final entity = _db.appLockBox.get(1);
    final raw = entity?.credential ?? 'pin';
    return _credentialFromName(raw);
  }

  @override
  Future<bool> isBiometricEnabled() async {
    final entity = _db.appLockBox.get(1);
    return entity?.biometric ?? false;
  }

  @override
  Future<bool> verifyPin(String pin) async {
    final entity = _db.appLockBox.get(1);
    if (entity == null || entity.pinHash == null || entity.salt == null) {
      return false;
    }
    return _hashPin(pin, entity.salt!) == entity.pinHash;
  }

  @override
  Future<bool> verifyPattern(List<int> pattern) async {
    final entity = _db.appLockBox.get(1);
    if (entity == null || entity.patternHash == null || entity.salt == null) {
      return false;
    }
    return _hashPattern(pattern, entity.salt!) == entity.patternHash;
  }

  // ---------------------------------------------------------------------------
  // Write
  // ---------------------------------------------------------------------------

  @override
  Future<void> setEnabled(bool value) async {
    final entity = _db.appLockBox.get(1) ?? AppLockEntity(id: 1);
    entity.enabled = value;
    _db.appLockBox.put(entity);
  }

  @override
  Future<void> setBiometricEnabled(bool value) async {
    final entity = _db.appLockBox.get(1) ?? AppLockEntity(id: 1);
    entity.biometric = value;
    _db.appLockBox.put(entity);
  }

  @override
  Future<void> savePin(String pin) async {
    final entity = _db.appLockBox.get(1) ?? AppLockEntity(id: 1);
    final salt = _generateSalt();
    entity.salt = salt;
    entity.pinHash = _hashPin(pin, salt);
    entity.credential = 'pin';
    _db.appLockBox.put(entity);
  }

  @override
  Future<void> savePattern(List<int> pattern) async {
    final entity = _db.appLockBox.get(1) ?? AppLockEntity(id: 1);
    final salt = _generateSalt();
    entity.salt = salt;
    entity.patternHash = _hashPattern(pattern, salt);
    entity.credential = 'pattern';
    _db.appLockBox.put(entity);
  }

  @override
  Future<void> clearAll() async {
    _db.appLockBox.remove(1);
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
