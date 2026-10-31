import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dompetqu/core/config/api_config.dart';
import 'package:dompetqu/core/logger/app_logger.dart';

part 'generated/cookie_aware_client.g.dart';

/// Mengelola cookie session (`__sst__`) & refresh (`__rft__`) dari backend.
///
/// Cookie adalah satu-satunya sumber kebenaran token dan dipersist ke
/// [SharedPreferences]. Meniru perilaku browser `credentials: "include"`:
/// - mengirim header `Cookie` pada setiap request
/// - menangkap header `Set-Cookie` dari response
/// - saat `__sst__` usang tapi `__rft__` masih valid, [refreshSession]
///   meminta backend mengeluarkan `__sst__` baru via Set-Cookie.
class CookieAwareClient extends http.BaseClient {
  CookieAwareClient({http.Client? inner, Uri? graphqlEndpoint})
    : _inner = inner ?? http.Client(),
      _graphqlEndpoint =
          graphqlEndpoint ?? Uri.parse(ApiConfig.graphqlEndpoint);

  static const String prefsKey = 'session_cookies';

  static const String sessionCookieName = '__sst__';
  static const String refreshCookieName = '__rft__';

  final http.Client _inner;
  final Uri _graphqlEndpoint;
  final Map<String, String> _cookies = {};
  final AppLogger _log = AppLogger.instance;

  /// Refresh yang sedang berjalan — mendedupe pemanggilan `send()` yang
  /// terjadi bersamaan saat expiry terdeteksi.
  Future<bool>? _refreshInFlight;

  /// Nilai `__sst__` yang sudah dicoba di-refresh tapi gagal. Dicegah dicoba
  /// ulang pada request berikutnya supaya tidak membanjiri server; di-reset
  /// saat token baru masuk (`setToken`) atau refresh sukses.
  String? _refreshFailedFor;

  /// Mengembalikan salinan cookie yang tersimpan (untuk persistence/debug).
  Map<String, String> get cookies => Map.unmodifiable(_cookies);

  /// Session token (JWT) dari cookie `__sst__`.
  String? get token => _cookies[sessionCookieName];

  /// Refresh token (JWT) dari cookie `__rft__`.
  String? get refreshToken => _cookies[refreshCookieName];

  /// Memuat cookie tersimpan dari disk. Panggil sekali saat startup.
  Future<void> restore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(prefsKey);
      if (raw == null) {
        _log.debug('Tidak ada cookie tersimpan', tag: 'CookieClient');
        return;
      }
      try {
        final decoded = jsonDecode(raw) as Map<String, dynamic>;
        decoded.forEach((key, value) => _cookies[key] = value as String);
        _log.debug(
          'Restore cookie: ${_cookies.keys.join(', ')}',
          tag: 'CookieClient',
        );
      } on FormatException {
        _log.warn('Cookie tersimpan rusak, dihapus.', tag: 'CookieClient');
        await prefs.remove(prefsKey);
      }
    } catch (e) {
      _log.warn('Restore gagal: $e', tag: 'CookieClient');
    }
  }

  /// Menyimpan session token ke cookie `__sst__` (persist ke disk).
  Future<void> setToken(String? value) async {
    _setCookie(sessionCookieName, value);
    // Token baru layak dicoba refresh lagi bila nanti kedaluwarsa.
    _refreshFailedFor = null;
    await _persist();
  }

  /// Menyimpan refresh token ke cookie `__rft__` (persist ke disk).
  Future<void> setRefreshToken(String? value) async {
    _setCookie(refreshCookieName, value);
    await _persist();
  }

  /// Hapus semua cookie (saat sign out).
  Future<void> clear() async {
    _cookies.clear();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(prefsKey);
    } catch (e) {
      _log.warn('clear gagal: $e', tag: 'CookieClient');
    }
    _log.debug('Cookie dibersihkan', tag: 'CookieClient');
  }

  /// Apakah session token (`__sst__`) masih berlaku?
  bool get isSessionValid {
    final session = _cookies[sessionCookieName];
    if (session == null || session.isEmpty) return false;
    final expiry = _jwtExpiry(session);
    if (expiry == null) return true; // tidak bisa didecode → anggap valid
    return DateTime.now().isBefore(expiry);
  }

  /// Refresh `__sst__` memakai `__rft__` bila session sudah usang.
  ///
  /// Backend meng-rotate `__sst__` lewat Set-Cookie ketika ada request dengan
  /// cookie usang namun refresh token (di DB) masih valid. Request refresh
  /// dikirim langsung ke endpoint GraphQL (query `checkAuthorized`) tanpa
  /// perlu GraphQL client — token baru di-capture dari Set-Cookie.
  ///
  /// Mengembalikan `true` bila `__sst__` kini valid.
  ///
  /// Dipublikasikan seperti semula; pemanggilan yang datang saat refresh
  /// berjalan menunggu refresh yang sama (dedupe).
  Future<bool> refreshSession() {
    final inFlight = _refreshInFlight;
    if (inFlight != null) return inFlight;
    final future = _refreshSession();
    _refreshInFlight = future;
    return future.whenComplete(() {
      if (identical(_refreshInFlight, future)) _refreshInFlight = null;
    });
  }

  Future<bool> _refreshSession() async {
    if (isSessionValid) {
      _markRefreshResult(true);
      return true;
    }
    if (refreshToken == null || refreshToken!.isEmpty) {
      _log.warn('Refresh gagal: tidak ada __rft__', tag: 'CookieClient');
      _markRefreshResult(false);
      return false;
    }
    _log.debug('Session usang — refresh memakai __rft__', tag: 'CookieClient');
    try {
      final request = http.Request('POST', _graphqlEndpoint)
        ..headers['content-type'] = 'application/json'
        ..headers['accept'] = 'application/json'
        ..body = jsonEncode({
          'query': 'query CheckAuthorized { checkAuthorized }',
        });
      if (_cookies.isNotEmpty) {
        request.headers['cookie'] = _cookies.entries
            .map((e) => '${e.key}=${e.value}')
            .join('; ');
      }
      final response = await _inner.send(request);
      _captureSetCookie(response.headers);
      await _persist();
      final ok = isSessionValid;
      _log.debug(
        'Refresh session: ${ok ? 'OK' : 'gagal'}',
        tag: 'CookieClient',
      );
      _markRefreshResult(ok);
      return ok;
    } catch (e) {
      // Kegagalan transport (jaringan/server down) bersifat sesaat: TIDAK
      // ditandai sebagai throttled supaya request berikutnya mencoba refresh
      // lagi. Throttle hanya untuk hasil "resmi" (token/refresh ditolak).
      _log.warn('Refresh session gagal: $e', tag: 'CookieClient');
      return false;
    }
  }

  /// Catat hasil refresh untuk [send] — sukses me-reset throttle, gagal
  /// menandai token yang sudah dicoba supaya tidak di-refresh ulang tiap request.
  void _markRefreshResult(bool ok) {
    _refreshFailedFor = ok ? null : _cookies[sessionCookieName];
  }

  Future<void> _persist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(prefsKey, jsonEncode(_cookies));
    } catch (e) {
      _log.warn('Persist cookie gagal: $e', tag: 'CookieClient');
    }
  }

  void _setCookie(String name, String? value) {
    if (value == null || value.isEmpty) {
      _cookies.remove(name);
    } else {
      _cookies[name] = value;
    }
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // Rotasi `__sst__` yang sudah lewat expiry lokal SEBELUM request utama.
    // Tanpa ini token expired dikirim apa adanya → backend melempar
    // "Missing or expired token" padahal `__rft__` masih berlaku, dan sesi
    // tetap dianggap authenticated sehingga error tampil terus (refresh
    // sebelumnya hanya berjalan sekali saat restore awal).
    final sessionSebelum = _cookies[sessionCookieName];
    if (sessionSebelum != null &&
        sessionSebelum.isNotEmpty &&
        !isSessionValid &&
        (refreshToken?.isNotEmpty ?? false) &&
        _refreshFailedFor != sessionSebelum) {
      await refreshSession();
    }
    if (_cookies.isNotEmpty) {
      request.headers.putIfAbsent(
        'cookie',
        () => _cookies.entries.map((e) => '${e.key}=${e.value}').join('; '),
      );
    }
    // Dibaca ulang setelah potensi rotasi di atas — `Bearer` harus memakai
    // token terbaru, bukan yang sudah kedaluwarsa.
    final session = _cookies[sessionCookieName];
    if (session != null) {
      request.headers.putIfAbsent('authorization', () => 'Bearer $session');
    }
    late http.StreamedResponse response;
    try {
      response = await _inner.send(request);
    } catch (error, stackTrace) {
      _log.error(
        'HTTP ${request.method} ${request.url} gagal',
        tag: 'CookieClient',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
    _captureSetCookie(response.headers);
    await _persist();
    return response;
  }

  /// Baca `expiresAt` dari payload JWT `__sst__` (tanpa verifikasi).
  DateTime? _jwtExpiry(String token) {
    try {
      final parts = token.split('.');
      if (parts.length < 2) return null;
      final payload = utf8.decode(
        base64Url.decode(base64Url.normalize(parts[1])),
      );
      final json = jsonDecode(payload) as Map<String, dynamic>;
      final raw = json['expiresAt'];
      if (raw is String) return DateTime.tryParse(raw);
      if (raw is num) return DateTime.fromMillisecondsSinceEpoch(raw.round());
      return null;
    } catch (_) {
      return null;
    }
  }

  void _captureSetCookie(Map<String, String> headers) {
    headers.forEach((name, value) {
      if (name.toLowerCase() != 'set-cookie') return;
      for (final raw in value.split(',')) {
        final cookie = raw.split(';').first.trim();
        final eq = cookie.indexOf('=');
        if (eq <= 0) continue;
        final key = cookie.substring(0, eq).trim();
        final val = cookie.substring(eq + 1).trim();
        if (val.isEmpty) {
          // Abaikan penghapusan cookie sesi oleh Set-Cookie kosong.
          // Backend mengirim `__sst__=; Max-Age=0` pada SEMUA kegagalan
          // `authorize()` (termasuk gangguan sesaat, lihat blok catch di
          // `createContext` cx-services/shared/infra/graphql/yoga-context.ts).
          // Menghapus cookie di sini memutus jalur refresh: rotasi `__sst__`
          // di backend justru membutuhkan cookie usang tersebut dikirim ulang,
          // sehingga satu kegagalan sesaat memaksa login manual. Sign-out
          // eksplisit tetap aman — `AuthRepositoryImpl.signOut()` membersihkan
          // cookie secara lokal lewat `clear()`.
          if (key != sessionCookieName && key != refreshCookieName) {
            _cookies.remove(key);
          }
        } else {
          _cookies[key] = val;
        }
      }
    });
  }

  @override
  void close() => _inner.close();
}

/// Client HTTP yang mengelola cookie session (persist antar request).
@Riverpod(keepAlive: true)
CookieAwareClient cookieAwareClient(Ref ref) => CookieAwareClient();
