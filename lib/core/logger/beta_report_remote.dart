import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';

/// Exception saat pengiriman laporan beta gagal.
class BetaReportException implements Exception {
  BetaReportException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Mengirim laporan beta ke backend: `POST {baseUrl}/api/beta/report`.
///
/// Endpoint ini hanya mencatat laporan via logger backend (belum ada
/// penyimpanan DB) — cukup untuk fase beta.
class BetaReportRemote {
  BetaReportRemote._();

  static final BetaReportRemote instance = BetaReportRemote._();

  final http.Client _client = http.Client();

  Uri get _endpoint => Uri.parse('${ApiConfig.baseUrl}/api/beta/report');

  Future<void> send({
    required String message,
    required List<Map<String, dynamic>> logs,
    String? appVersion,
  }) async {
    final response = await _client
        .post(
          _endpoint,
          headers: const {'Content-Type': 'application/json'},
          body: jsonEncode({
            'message': message,
            'appVersion': appVersion,
            'platform': defaultTargetPlatform.name,
            'logs': logs,
          }),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw BetaReportException(
        'Server merespons ${response.statusCode}: ${response.body}',
      );
    }
  }
}
