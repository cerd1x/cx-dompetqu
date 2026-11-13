import 'package:flutter_test/flutter_test.dart';

import 'package:cx_dompetqiu/features/transactions/adapters/models/transaction.dart'
    as data;
import 'package:cx_dompetqiu/features/transactions/adapters/models/transaction_page.dart'
    as data;
import 'package:cx_dompetqiu/features/transactions/domain/models/payment_method_type.dart';
import 'package:cx_dompetqiu/features/transactions/domain/models/transaction.dart';

void main() {
  group('Skenario nilai transaksi', () {
    test('amountValue memparse format ISO VALUE', () {
      expect(
        Transaction(
          id: 't',
          amount: 'IDR 1,250,000',
          createdAt: DateTime(2026, 1, 1),
        ).amountValue,
        1250000,
      );
    });

    test('amountValue negatif terbaca', () {
      expect(
        Transaction(
          id: 't',
          amount: 'USD -12.5',
          createdAt: DateTime(2026, 1, 1),
        ).amountValue,
        -12.5,
      );
    });

    test('amount invalid dianggap 0 tanpa melempar error', () {
      final tx = Transaction(
        id: 't',
        amount: 'bukan-angka',
        createdAt: DateTime(2026, 1, 1),
      );

      expect(tx.amountValue, 0);
    });

    test('displayName memakai deskripsi, lalu kategori, lalu tipe', () {
      final now = DateTime(2026, 1, 1);

      expect(
        Transaction(
          id: 't',
          description: 'Gaji',
          category: 'Kerja',
          createdAt: now,
        ).displayName,
        'Gaji',
      );
      expect(
        Transaction(id: 't', category: 'Kerja', createdAt: now).displayName,
        'Kerja',
      );
      expect(
        Transaction(id: 't', type: 'expense', createdAt: now).displayName,
        'expense',
      );
    });

    test('default domain transaksi', () {
      final tx = Transaction(id: 't', createdAt: DateTime(2026, 1, 1));

      expect(tx.type, 'income');
      expect(tx.amount, 'IDR 0');
      expect(tx.status, 'success');
      expect(tx.paymentStatus, 'unpaid');
      expect(tx.paymentMethod, isNull);
    });
  });

  group('Skenario tipe metode pembayaran', () {
    test('fromRaw mengenali semua wire value', () {
      for (final method in PaymentMethodType.values) {
        expect(PaymentMethodType.fromRaw(method.rawValue), method);
      }
    });

    test('fromRaw null/tak dikenal mengembalikan null', () {
      expect(PaymentMethodType.fromRaw('cash'), PaymentMethodType.cash);
      expect(PaymentMethodType.fromRaw('bitcoin'), isNull);
      expect(PaymentMethodType.fromRaw(null), isNull);
      expect(PaymentMethodType.fromRaw('CASH'), isNull);
    });

    test('rawValue sesuai kontrak backend', () {
      expect(
        PaymentMethodType.values.map((m) => m.rawValue),
        [
          'cash',
          'bank_transfer',
          'ewallet',
          'credit_card',
          'debit_card',
          'credit',
        ],
      );
    });

    test('label Bahasa Indonesia', () {
      expect(PaymentMethodType.cash.label, 'Tunai');
      expect(PaymentMethodType.bankTransfer.label, 'Transfer Bank');
      expect(PaymentMethodType.ewallet.label, 'E-Wallet');
      expect(PaymentMethodType.creditCard.label, 'Kartu Kredit');
      expect(PaymentMethodType.debitCard.label, 'Kartu Debit');
      expect(PaymentMethodType.credit.label, 'Kredit');
    });
  });

  group('Skenario parsing transaksi', () {
    test('fromJson mengubah id numerik, customerId, dan assetId', () {
      final tx = data.Transaction.fromJson({
        'id': 11,
        'type': 'expense',
        'amount': 'IDR 20000',
        'customerId': 7,
        'paymentMethod': {'type': 'cash', 'assetId': 3},
        'createdAt': '2026-02-03T04:05:06.000Z',
      });

      expect(tx.id, '11');
      expect(tx.customerId, '7');
      expect(tx.paymentMethod?.assetId, '3');
      expect(tx.createdAt, DateTime.utc(2026, 2, 3, 4, 5, 6));
    });

    test('fromJson memakai default untuk field opsional', () {
      final tx = data.Transaction.fromJson({
        'id': 't1',
        'createdAt': '2026-01-01T00:00:00.000Z',
      });

      expect(tx.type, 'income');
      expect(tx.amount, 'IDR 0');
      expect(tx.status, 'success');
      expect(tx.paymentStatus, 'unpaid');
      expect(tx.paymentMethod, isNull);
    });

    test('createdAt invalid jatuh ke waktu sekarang', () {
      final before = DateTime.now().subtract(const Duration(seconds: 1));
      final tx = data.Transaction.fromJson({
        'id': 't1',
        'createdAt': 'bukan-tanggal',
      });

      expect(tx.createdAt.isAfter(before), isTrue);
    });

    test('displayName pada model adapter', () {
      final tx = data.Transaction.fromJson({
        'id': 't1',
        'description': 'Makan siang',
        'createdAt': '2026-01-01T00:00:00.000Z',
      });

      expect(tx.displayName, 'Makan siang');
    });
  });

  group('Skenario halaman transaksi', () {
    Map<String, dynamic> pageJson() => {
      'edges': [
        {
          'cursor': 'c1',
          'node': {
            'id': 't1',
            'amount': 'IDR 10',
            'createdAt': '2026-01-02T00:00:00.000Z',
          },
        },
        {
          'cursor': 'c2',
          'node': {
            'id': 't2',
            'amount': 'IDR 20',
            'createdAt': '2026-01-01T00:00:00.000Z',
          },
        },
      ],
      'pageInfo': {
        'hasNextPage': true,
        'hasPreviousPage': false,
        'startCursor': 'c1',
        'endCursor': 'c2',
      },
    };

    test('fromJson memetakan items, cursor, dan pageInfo', () {
      final page = data.TransactionPage.fromJson(pageJson());

      expect(page.items.map((t) => t.id), ['t1', 't2']);
      expect(page.cursors, ['c1', 'c2']);
      expect(page.hasNextPage, isTrue);
      expect(page.hasPreviousPage, isFalse);
      expect(page.nextCursor, 'c2');
      expect(page.previousCursor, 'c1');
      expect(page.isEmpty, isFalse);
    });

    test('halaman kosong', () {
      final page = data.TransactionPage.fromJson({
        'edges': [],
        'pageInfo': <String, dynamic>{},
      });

      expect(page.isEmpty, isTrue);
      expect(page.items, isEmpty);
      expect(page.hasNextPage, isFalse);
      expect(page.nextCursor, isNull);
    });

    test('TransactionPage.empty statis', () {
      const page = data.TransactionPage.empty();

      expect(page.isEmpty, isTrue);
      expect(page.previousCursor, isNull);
    });

    test('edges bukan list melempar FormatException', () {
      expect(
        () => data.TransactionPage.fromJson({
          'edges': 'bukan-list',
          'pageInfo': {},
        }),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            contains('edges'),
          ),
        ),
      );
    });

    test('pageInfo hilang melempar FormatException', () {
      expect(
        () => data.TransactionPage.fromJson({'edges': []}),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            contains('pageInfo'),
          ),
        ),
      );
    });

    test('edge tanpa node melempar FormatException', () {
      expect(
        () => data.TransactionEdge.fromJson({'cursor': 'c1'}),
        throwsA(isA<FormatException>()),
      );
    });

    test('cursor hilang menjadi string kosong', () {
      final edge = data.TransactionEdge.fromJson({
        'node': {
          'id': 't1',
          'createdAt': '2026-01-01T00:00:00.000Z',
        },
      });

      expect(edge.cursor, '');
      expect(edge.node.id, 't1');
    });

    test('pageInfo default saat field hilang', () {
      final info = data.TransactionPageInfo.fromJson(const {});

      expect(info.hasNextPage, isFalse);
      expect(info.hasPreviousPage, isFalse);
      expect(info.startCursor, isNull);
      expect(info.endCursor, isNull);
    });
  });
}
