import 'package:flutter_test/flutter_test.dart';

import 'package:cx_dompetqiu/features/analytics/view/widgets/analytics_data.dart';
import 'package:cx_dompetqiu/features/transactions/domain/models/transaction.dart';

Transaction _tx({
  required String id,
  required String type,
  required String amount,
  required DateTime createdAt,
  String status = 'success',
}) => Transaction(
  id: id,
  type: type,
  amount: amount,
  status: status,
  createdAt: createdAt,
);

void main() {
  group('Skenario agregasi harian', () {
    test('mengelompokkan income & expense per hari lalu profit harian', () {
      final txs = [
        _tx(
          id: 't1',
          type: 'income',
          amount: 'IDR 100',
          createdAt: DateTime(2026, 1, 2, 9),
        ),
        _tx(
          id: 't2',
          type: 'expense',
          amount: 'IDR 40',
          createdAt: DateTime(2026, 1, 2, 15),
        ),
        _tx(
          id: 't3',
          type: 'income',
          amount: 'IDR 50',
          createdAt: DateTime(2026, 1, 1, 8),
        ),
      ];

      final daily = dailyProfit(txs);

      // Urut naik berdasarkan tanggal.
      expect(daily.map((d) => d.date).toList(), [
        DateTime(2026, 1, 1),
        DateTime(2026, 1, 2),
      ]);
      expect(daily.first.income, 50);
      expect(daily.first.expense, 0);
      expect(daily.last.income, 100);
      expect(daily.last.expense, 40);
      expect(daily.last.profit, 60);
    });

    test('mengabaikan transaksi yang statusnya bukan success', () {
      final txs = [
        _tx(
          id: 't1',
          type: 'income',
          amount: 'IDR 100',
          status: 'pending',
          createdAt: DateTime(2026, 1, 1),
        ),
        _tx(
          id: 't2',
          type: 'income',
          amount: 'IDR 25',
          status: 'success',
          createdAt: DateTime(2026, 1, 1),
        ),
      ];

      final daily = dailyProfit(txs);

      expect(daily, hasLength(1));
      expect(daily.single.income, 25);
    });

    test('amount tidak valid dihitung 0 tanpa melempar error', () {
      final txs = [
        _tx(
          id: 't1',
          type: 'income',
          amount: 'bukan-angka',
          createdAt: DateTime(2026, 1, 1),
        ),
      ];

      final daily = dailyProfit(txs);

      expect(daily.single.income, 0);
      expect(daily.single.profit, 0);
    });

    test('daftar kosong menghasilkan seri kosong', () {
      final series = buildSeries(const []);

      expect(series.isEmpty, isTrue);
      expect(series.daily, isEmpty);
      expect(series.cumulativeProfit, isEmpty);
      expect(series.totalProfit, 0);
    });
  });

  group('Skenario seri kumulatif', () {
    test('running profit menjumlahkan profit hari sebelumnya', () {
      final txs = [
        _tx(
          id: 't1',
          type: 'income',
          amount: 'IDR 100',
          createdAt: DateTime(2026, 1, 1),
        ),
        _tx(
          id: 't2',
          type: 'expense',
          amount: 'IDR 30',
          createdAt: DateTime(2026, 1, 2),
        ),
        _tx(
          id: 't3',
          type: 'income',
          amount: 'IDR 10',
          createdAt: DateTime(2026, 1, 3),
        ),
      ];

      final series = buildSeries(txs);

      expect(series.daily, hasLength(3));
      expect(series.cumulativeProfit, [100, 70, 80]);
      expect(series.totalProfit, 80);
    });
  });
}
