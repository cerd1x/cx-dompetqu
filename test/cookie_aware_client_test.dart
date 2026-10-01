import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dompetqu/core/network/cookie_aware_client.dart';

/// Buat token JWT palsu (payload berisi `expiresAt`) — hanya butuh bagian
/// payload yang di-decode oleh `_jwtExpiry`.
String _fakeJwt(DateTime expiresAt) {
  final payload =
      base64UrlEncode(utf8.encode(jsonEncode({'expiresAt': expiresAt.toIso8601String()})));
  return 'header.$payload.sig';
}

void main() {
  const sst = CookieAwareClient.sessionCookieName;
  const rft = CookieAwareClient.refreshCookieName;

  TestWidgetsFlutterBinding.ensureInitialized();

  test('restore + persist cookies dari SharedPreferences', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final stale = _fakeJwt(DateTime.now().subtract(const Duration(hours: 1)));
    await prefs.setString(
      CookieAwareClient.prefsKey,
      jsonEncode({sst: stale, rft: 'refresh-token'}),
    );

    final client = CookieAwareClient(graphqlEndpoint: Uri.parse('http://x/gql'));
    await client.restore();

    expect(client.token, stale);
    expect(client.refreshToken, 'refresh-token');
    expect(client.cookies, {sst: stale, rft: 'refresh-token'});
  });

  test('refreshSession tidak memanggil server saat __sst__ masih valid',
      () async {
    var called = 0;
    final inner = MockClient((_) async {
      called++;
      return http.Response('{}', 200);
    });
    final client =
        CookieAwareClient(inner: inner, graphqlEndpoint: Uri.parse('http://x/gql'));
    final fresh = _fakeJwt(DateTime.now().add(const Duration(hours: 1)));
    await client.setToken(fresh);
    await client.setRefreshToken('refresh-token');

    expect(await client.refreshSession(), isTrue);
    expect(called, 0);
  });

  test('refreshSession pakai __rft__ saat __sst__ usang, __sst__ diperbarui',
      () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final stale = _fakeJwt(DateTime.now().subtract(const Duration(hours: 1)));
    await prefs.setString(
      CookieAwareClient.prefsKey,
      jsonEncode({sst: stale, rft: 'refresh-token'}),
    );

    final inner = MockClient((request) async {
      expect(request.headers['cookie'], contains('$sst=$stale'));
      expect(request.headers['cookie'], contains('$rft=refresh-token'));
      final newSst = _fakeJwt(DateTime.now().add(const Duration(hours: 1)));
      return http.Response(
        '{"data":{"checkAuthorized":true}}',
        200,
        headers: {'set-cookie': '$sst=$newSst; Path=/; HttpOnly'},
      );
    });
    final client =
        CookieAwareClient(inner: inner, graphqlEndpoint: Uri.parse('http://x/gql'));
    await client.restore();

    expect(client.isSessionValid, isFalse);
    expect(await client.refreshSession(), isTrue);
    expect(client.isSessionValid, isTrue);

    // Harus persist — restore ulang dari disk.
    final restored =
        CookieAwareClient(graphqlEndpoint: Uri.parse('http://x/gql'));
    await restored.restore();
    expect(restored.token, isNotNull);
    expect(restored.isSessionValid, isTrue);
  });

  test('refreshSession gagal tanpa __rft__', () async {
    var called = 0;
    final inner = MockClient((_) async {
      called++;
      return http.Response('{}', 200);
    });
    final client =
        CookieAwareClient(inner: inner, graphqlEndpoint: Uri.parse('http://x/gql'));
    final stale = _fakeJwt(DateTime.now().subtract(const Duration(hours: 1)));
    await client.setToken(stale);

    expect(await client.refreshSession(), isFalse);
    expect(called, 0);
  });

  test('refreshSession mengirim cookie pada setiap request via send()', () async {
    SharedPreferences.setMockInitialValues({});
    http.BaseRequest? captured;
    final inner = MockClient((request) async {
      captured = request;
      return http.Response('{"data":{}}', 200);
    });
    final client =
        CookieAwareClient(inner: inner, graphqlEndpoint: Uri.parse('http://x/gql'));
    final fresh = _fakeJwt(DateTime.now().add(const Duration(hours: 1)));
    await client.setToken(fresh);
    await client.setRefreshToken('refresh-token');

    await client.post(Uri.parse('http://x/gql'));
    expect(captured!.headers['cookie'], contains('$sst=$fresh'));
    expect(captured!.headers['cookie'], contains('$rft=refresh-token'));
    expect(captured!.headers['authorization'], 'Bearer $fresh');
  });
}
