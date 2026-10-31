import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import 'app_lock_datasources.dart';

class LocalAppLockBiometricDataSource implements AppLockBiometricDataSource {
  LocalAppLockBiometricDataSource() : _auth = LocalAuthentication();

  final LocalAuthentication _auth;

  @override
  Future<bool> authenticate() async {
    try {
      if (!await _auth.canCheckBiometrics) return false;
      return await _auth.authenticate(
        localizedReason: 'Autentikasi untuk membuka aplikasi',
        persistAcrossBackgrounding: true,
        biometricOnly: true,
      );
    } on PlatformException {
      return false;
    }
  }
}
