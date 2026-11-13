import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:cx_dompetqiu/features/admin_pannel/adapters/killswitch_remote_source.dart';

void main() {
  group('Skenario validasi kunci operation', () {
    test('menerima Query/Mutation dengan nama valid', () {
      expect(kOperationKeyPattern.hasMatch('Query.statistics'), isTrue);
      expect(kOperationKeyPattern.hasMatch('Mutation.createTransaction'), isTrue);
      expect(kOperationKeyPattern.hasMatch('Mutation._internal'), isTrue);
    });

    test('menolak key tanpa prefix Query/Mutation atau nama tidak valid', () {
      expect(kOperationKeyPattern.hasMatch('statistics'), isFalse);
      expect(kOperationKeyPattern.hasMatch('Subscription.onCreated'), isFalse);
      expect(kOperationKeyPattern.hasMatch('Query.'), isFalse);
      expect(kOperationKeyPattern.hasMatch('Query.1abc'), isFalse);
      expect(kOperationKeyPattern.hasMatch('Query.statistics users'), isFalse);
    });
  });

  group('Skenario parsing KillswitchEntry', () {
    test('disabledAt ISO string diparse', () {
      final entry = KillswitchEntry.fromJson({
        'operation': 'Mutation.createTransaction',
        'reason': 'maintenance',
        'disabledAt': '2026-01-02T03:04:05.000Z',
      });

      expect(entry.operation, 'Mutation.createTransaction');
      expect(entry.reason, 'maintenance');
      expect(entry.disabledAt, isNotNull);
      expect(entry.disabledAt!.toUtc(), DateTime.utc(2026, 1, 2, 3, 4, 5));
    });

    test('disabledAt unix detik dikonversi', () {
      final entry = KillswitchEntry.fromJson({
        'operation': 'Query.statistics',
        'disabledAt': 1767323045,
      });

      expect(
        entry.disabledAt!.toUtc(),
        DateTime.fromMillisecondsSinceEpoch(1767323045 * 1000, isUtc: true),
      );
    });

    test('disabledAt kosong menjadi null', () {
      final entry = KillswitchEntry.fromJson({
        'operation': 'Query.statistics',
        'disabledAt': null,
      });

      expect(entry.disabledAt, isNull);
    });
  });

  group('Skenario KillswitchRemoteSource', () {
    test('menolak request saat token admin kosong', () async {
      final source = KillswitchRemoteSource(
        MockClient((_) async => http.Response('{}', 200)),
        adminToken: '   ',
      );

      expect(source.hasToken, isFalse);
      await expectLater(source.list(), throwsA(isA<KillswitchException>()));
    });

    test('list memetakan items dan mengirim header x-admin-token', () async {
      late http.Request captured;
      final source = KillswitchRemoteSource(
        MockClient((request) async {
          captured = request;
          return http.Response(
            jsonEncode({
              'status': 'ok',
              'count': 1,
              'items': [
                {'operation': 'Query.statistics', 'reason': 'x'},
              ],
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
        adminToken: 'secret',
      );

      final items = await source.list();

      expect(source.hasToken, isTrue);
      expect(items, hasLength(1));
      expect(items.single.operation, 'Query.statistics');
      expect(captured.headers['x-admin-token'], 'secret');
      expect(captured.headers.containsKey('authorization'), isFalse);
    });

    test('disable mengirim reason yang sudah di-trim', () async {
      late http.Request captured;
      final source = KillswitchRemoteSource(
        MockClient((request) async {
          captured = request;
          return http.Response(
            jsonEncode({
              'operation': 'Mutation.createTransaction',
              'reason': 'maintenance',
              'disabledAt': '2026-01-01T00:00:00.000Z',
            }),
            201,
          );
        }),
        adminToken: 'secret',
      );

      final entry = await source.disable(
        'Mutation.createTransaction',
        reason: '  maintenance  ',
      );

      expect(entry.operation, 'Mutation.createTransaction');
      expect(entry.reason, 'maintenance');
      expect(jsonDecode(captured.body), {'reason': 'maintenance'});
      expect(captured.method, 'POST');
      expect(captured.url.path, endsWith('/Mutation.createTransaction'));
    });

    test('disable tanpa reason tidak mengirim body reason', () async {
      late http.Request captured;
      final source = KillswitchRemoteSource(
        MockClient((request) async {
          captured = request;
          return http.Response('{}', 200);
        }),
        adminToken: 'secret',
      );

      await source.disable('Query.statistics', reason: '   ');

      expect(jsonDecode(captured.body), isEmpty);
    });

    test('enable mengembalikan changed=false bila sudah hidup', () async {
      final source = KillswitchRemoteSource(
        MockClient(
          (request) async => http.Response(jsonEncode({'changed': false}), 200),
        ),
        adminToken: 'secret',
      );

      expect(await source.enable('Query.statistics'), isFalse);
    });

    test('respons non-2xx dilempar sebagai KillswitchException', () async {
      final source = KillswitchRemoteSource(
        MockClient(
          (_) async => http.Response(
            jsonEncode({'error': 'forbidden'}),
            403,
          ),
        ),
        adminToken: 'secret',
      );

      await expectLater(
        source.list(),
        throwsA(
          isA<KillswitchException>()
              .having((e) => e.statusCode, 'statusCode', 403)
              .having((e) => e.message, 'message', contains('forbidden')),
        ),
      );
    });
  });
}
