import 'package:flutter_test/flutter_test.dart';

import 'package:cx_dompetqiu/features/assets/adapters/models/asset.dart' as data;
import 'package:cx_dompetqiu/features/contacts/adapters/models/contact.dart'
    as data;
import 'package:cx_dompetqiu/features/contacts/adapters/models/contact_page.dart'
    as data;
import 'package:cx_dompetqiu/features/dashboard/adapters/mappers/home_model_mapper.dart';
import 'package:cx_dompetqiu/features/dashboard/view/stores/finance_overview_store.dart';
import 'package:cx_dompetqiu/features/inventory/adapters/models/product.dart'
    as data;
import 'package:cx_dompetqiu/features/statistics/adapters/models/statistics.dart'
    as data;
import 'package:cx_dompetqiu/features/transactions/adapters/models/transaction.dart'
    as data;
import 'package:cx_dompetqiu/features/transactions/adapters/models/transaction_page.dart'
    as data;

void main() {
  group('Skenario mapper data → domain', () {
    test('Asset dipetakan lengkap', () {
      final entity = const data.Asset(
        id: 'a1',
        name: 'BCA',
        type: 'bank',
        balance: 'IDR 1000',
      ).toEntity();

      expect(entity.id, 'a1');
      expect(entity.name, 'BCA');
      expect(entity.type, 'bank');
      expect(entity.balance, 'IDR 1000');
    });

    test('Contact dipetakan lengkap termasuk daftar phones', () {
      final entity = data.Contact(
        id: 'c1',
        name: 'Budi',
        email: 'budi@example.com',
        phones: const ['0812', '0813'],
        group: 'Keluarga',
      ).toEntity();

      expect(entity.id, 'c1');
      expect(entity.email, 'budi@example.com');
      expect(entity.phones, ['0812', '0813']);
      expect(entity.group, 'Keluarga');
    });

    test('ContactPage memetakan setiap kontak', () {
      final page = data.ContactPage(
        edges: [
          data.ContactEdge(
            cursor: 'c1',
            node: const data.Contact(id: '1', name: 'Budi'),
          ),
          data.ContactEdge(
            cursor: 'c2',
            node: const data.Contact(id: '2', name: 'Siti'),
          ),
        ],
        pageInfo: const data.ContactPageInfo(
          hasNextPage: true,
          hasPreviousPage: false,
          endCursor: 'c2',
        ),
      );

      final entity = page.toEntity();

      expect(entity.items.map((c) => c.name), ['Budi', 'Siti']);
      expect(entity.hasNextPage, isTrue);
      expect(entity.nextCursor, 'c2');
    });

    test('Product dipetakan termasuk angka & tanggal', () {
      final entity = data.Product(
        id: 'p1',
        name: 'Kopi',
        price: 25000,
        capital: 15000,
        margin: 10000,
        stock: 3,
        trackStock: true,
        createdAt: DateTime.utc(2026, 1, 1),
      ).toEntity();

      expect(entity.id, 'p1');
      expect(entity.price, 25000);
      expect(entity.stock, 3);
      expect(entity.trackStock, isTrue);
      expect(entity.createdAt, DateTime.utc(2026, 1, 1));
    });

    test('Statistics dipetakan semua field', () {
      final entity = const data.Statistics(
        totalIncome: 100,
        totalExpense: 40,
        totalProfit: 60,
        totalLoan: 10,
        totalCash: 5,
        totalAsset: 1000,
      ).toEntity();

      expect(entity.totalIncome, 100);
      expect(entity.totalExpense, 40);
      expect(entity.totalProfit, 60);
      expect(entity.totalLoan, 10);
      expect(entity.totalCash, 5);
      expect(entity.totalAsset, 1000);
    });

    test('Transaction dipetakan termasuk PaymentMethod', () {
      final entity = data.Transaction(
        id: 't1',
        type: 'expense',
        amount: 'IDR 100',
        paymentMethod: const data.PaymentMethod(type: 'cash', assetId: '9'),
        createdAt: DateTime.utc(2026, 2, 2),
      ).toEntity();

      expect(entity.id, 't1');
      expect(entity.amount, 'IDR 100');
      expect(entity.paymentMethod?.type, 'cash');
      expect(entity.paymentMethod?.assetId, '9');
      expect(entity.createdAt, DateTime.utc(2026, 2, 2));
    });

    test('TransactionPage memetakan edge menjadi item domain', () {
      final page = data.TransactionPage(
        edges: [
          data.TransactionEdge(
            cursor: 'c1',
            node: data.Transaction(
              id: 't1',
              amount: 'IDR 10',
              createdAt: DateTime.utc(2026, 1, 1),
            ),
          ),
        ],
        pageInfo: const data.TransactionPageInfo(
          hasNextPage: false,
          hasPreviousPage: true,
          startCursor: 'c1',
        ),
      );

      final entity = page.toEntity();

      expect(entity.items.single.id, 't1');
      expect(entity.hasNextPage, isFalse);
      expect(entity.nextCursor, isNull);
    });
  });

  group('Skenario state finance overview', () {
    test('default memuat kosong dan loading', () {
      const state = FinanceOverviewState();

      expect(state.transactions, isEmpty);
      expect(state.payments, isEmpty);
      expect(state.loading, isTrue);
      expect(state.error, isNull);
    });

    test('copyWith memperbarui sebagian state', () {
      const state = FinanceOverviewState();

      final updated = state.copyWith(loading: false, error: 'gagal');

      expect(updated.loading, isFalse);
      expect(updated.error, 'gagal');
      expect(updated.transactions, isEmpty);
    });
  });
}
