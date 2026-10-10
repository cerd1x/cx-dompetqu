import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../core/config/api_config.dart';

/// Satu baris kill switch (`api_killswitch`) — operation GraphQL yang dimatikan.
///
/// Kontrak REST: `GET /admin/killswitch` mengembalikan
/// `{ status, count, items: [{ operation, reason, disabledAt }] }`.
class KillswitchEntry {
  const KillswitchEntry({
    required this.operation,
    this.reason,
    this.disabledAt,
  });

  /// Kunci operation GraphQL, format `"<Type>.<field>"` (mis.
  /// `Mutation.createTransaction`).
  final String operation;

  /// Alasan operator (opsional).
  final String? reason;

  /// Waktu saat operation dimatikan.
  final DateTime? disabledAt;

  factory KillswitchEntry.fromJson(Map<String, dynamic> json) {
    return KillswitchEntry(
      operation: json['operation'] as String? ?? '',
      reason: json['reason'] as String?,
      disabledAt: _parseDate(json['disabledAt']),
    );
  }

  /// Terima `disabledAt` sebagai ISO string (serialisasi Date) atau unix detik.
  static DateTime? _parseDate(Object? value) {
    if (value is num) {
      return DateTime.fromMillisecondsSinceEpoch(
        value.toInt() * 1000,
        isUtc: true,
      ).toLocal();
    }
    if (value is String) return DateTime.tryParse(value)?.toLocal();
    return null;
  }
}

/// Exception saat pemanggilan endpoint kill switch gagal.
class KillswitchException implements Exception {
  KillswitchException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

/// Pola operation key yang valid — sama dengan `operationKeySchema` di backend.
final RegExp kOperationKeyPattern = RegExp(
  r'^(Query|Mutation)\.[_A-Za-z][_0-9A-Za-z]*$',
);

/// Remote source REST untuk kontrol kill switch.
///
/// Sengaja REST (bukan GraphQL): jalur kontrol harus tetap bisa dipakai saat
/// layer GraphQL yang justru bermasalah. Setiap request wajib menyertakan
/// header `x-admin-token`.
class KillswitchRemoteSource {
  KillswitchRemoteSource(this._client, {required this.adminToken});

  final http.Client _client;
  final String adminToken;

  static const _timeout = Duration(seconds: 15);

  /// `true` bila token admin terkonfigurasi.
  bool get hasToken => adminToken.trim().isNotEmpty;

  Uri get _base => Uri.parse(ApiConfig.killswitchEndpoint);

  Uri _operationUri(String operation) =>
      Uri.parse('${ApiConfig.killswitchEndpoint}/${Uri.encodeComponent(operation)}');

  Map<String, String> get _headers => {
    'content-type': 'application/json',
    'x-admin-token': adminToken,
  };

  /// Ambil daftar operation yang sedang dimatikan.
  Future<List<KillswitchEntry>> list() async {
    _ensureToken();
    final res = await _client
        .get(_base, headers: _headers)
        .timeout(_timeout);
    _ensureOk(res);
    final body = _decode(res.body);
    final items = body['items'];
    if (items is! List) return const [];
    return items
        .whereType<Map>()
        .map((e) => KillswitchEntry.fromJson(e.cast<String, dynamic>()))
        .toList();
  }

  /// Matikan [operation] (idempotent). `POST /admin/killswitch/:operation`.
  Future<KillswitchEntry> disable(String operation, {String? reason}) async {
    _ensureToken();
    final trimmed = reason?.trim();
    final res = await _client
        .post(
          _operationUri(operation),
          headers: _headers,
          body: jsonEncode({
            if (trimmed != null && trimmed.isNotEmpty) 'reason': trimmed,
          }),
        )
        .timeout(_timeout);
    _ensureOk(res);
    final body = _decode(res.body);
    return KillswitchEntry(
      operation: body['operation'] as String? ?? operation,
      reason: body['reason'] as String?,
      disabledAt: KillswitchEntry._parseDate(body['disabledAt']),
    );
  }

  /// Nyalakan kembali [operation]. `DELETE /admin/killswitch/:operation`.
  ///
  /// Mengembalikan `changed` (bagian dari `EnableOperationResult`) — `false`
  /// bila operation memang tidak sedang dimatikan.
  Future<bool> enable(String operation) async {
    _ensureToken();
    final res = await _client
        .delete(_operationUri(operation), headers: _headers)
        .timeout(_timeout);
    _ensureOk(res);
    final body = _decode(res.body);
    return body['changed'] as bool? ?? true;
  }

  void _ensureToken() {
    if (!hasToken) {
      throw KillswitchException(
        'Token admin belum diset. Jalankan dengan '
        '--dart-define=KILLSWITCH_ADMIN_TOKEN=...',
        statusCode: 401,
      );
    }
  }

  void _ensureOk(http.Response res) {
    if (res.statusCode == 200 || res.statusCode == 201) return;
    String detail = res.body;
    try {
      final body = _decode(res.body);
      detail = (body['error'] as String?) ?? (body['message'] as String?) ?? detail;
    } catch (_) {
      // biarkan body mentah
    }
    throw KillswitchException(
      'Server merespons ${res.statusCode}: $detail',
      statusCode: res.statusCode,
    );
  }

  Map<String, dynamic> _decode(String raw) {
    if (raw.isEmpty) return const {};
    final decoded = jsonDecode(raw);
    return decoded is Map<String, dynamic> ? decoded : const {};
  }
}

/// Provider remote source kill switch (manual, tanpa codegen).
final killswitchRemoteSourceProvider = Provider<KillswitchRemoteSource>(
  (ref) => KillswitchRemoteSource(
    http.Client(),
    adminToken: ApiConfig.killswitchAdminToken,
  ),
);
