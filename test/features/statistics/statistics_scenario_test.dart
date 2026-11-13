import 'package:flutter_test/flutter_test.dart';

import 'package:cx_dompetqiu/features/assets/domain/models/asset.dart';
import 'package:cx_dompetqiu/features/statistics/adapters/models/statistics.dart'
    as data;
import 'package:cx_dompetqiu/features/statistics/adapters/repositories/statistics_repository_impl.dart';
import 'package:cx_dompetqiu/features/statistics/domain/models/statistics.dart';
import 'package:cx_dompetqiu/features/statistics/domain/usecases/statistics_use_cases.dart';
import 'package:cx_dompetqiu/features/transactions/domain/models/transaction.dart';

Transaction _tx({
  required String type,
  required String amount,
  String? method,
}) => Transaction(
  id: 't-${type}-$amount-$method',
  type: type,
  amount: amount,
  paymentMethod: method == null ? null : PaymentMethod(type: method),
  createdAt: DateTime(2026, 1, 1),
);

void main() {
  group('Skenario perhitungan statistik', () {
    final repository = StatisticsRepositoryImpl();

    final transactions = [
      _tx(type: 'income', amount: 'IDR 100', method: 'cash'),
      _tx(type: 'income', amount: 'IDR 50', method: 'bank_transfer'),
      _tx(type: 'expense', amount: 'IDR 40', method: 'cash'),
      _tx(type: 'loan', amount: 'IDR 25'),
      _tx(type: 'transfer', amount: 'IDR 999'),
    ];

    test('totalIncome hanya tipe income', () {
      expect(repository.totalIncome(transactions), 150);
    });

    test('totalExpense hanya tipe expense', () {
      expect(repository.totalExpense(transactions), 40);
    });

    test('totalLoan hanya tipe loan', () {
      expect(repository.totalLoan(transactions), 25);
    });

    test('netProfit = income - expense', () {
      expect(repository.netProfit(transactions), 110);
    });

    test('totalCash hanya transaksi dengan metode cash', () {
      expect(repository.totalCash(transactions), 140);
    });

    test('daftar kosong menghasilkan nol', () {
      expect(repository.totalIncome(const []), 0);
      expect(repository.totalExpense(const []), 0);
      expect(repository.netProfit(const []), 0);
      expect(repository.totalCash(const []), 0);
    });

    test('amount tidak valid dihitung nol', () {
      final txs = [
        _tx(type: 'income', amount: 'rusak'),
        _tx(type: 'income', amount: 'IDR 10'),
      ];

      expect(repository.totalIncome(txs), 10);
    });

    test('totalAsset menjumlahkan saldo valid dan melewati yang invalid', () {
      const assets = [
        Asset(id: '1', name: 'BCA', balance: 'IDR 1000'),
        Asset(id: '2', name: 'Dompet', balance: 'IDR 500'),
        Asset(id: '3', name: 'Rusak', balance: 'bukan-saldo'),
      ];

      expect(repository.totalAsset(assets), 1500);
    });

    test('totalAsset daftar kosong = 0', () {
      expect(repository.totalAsset(const []), 0);
    });
  });

  group('Skenario use case statistik', () {
    test('mendelegasikan seluruh perhitungan ke repository', () {
      final useCases = StatisticsUseCases(StatisticsRepositoryImpl());
      final txs = [
        _tx(type: 'income', amount: 'IDR 30', method: 'cash'),
        _tx(type: 'expense', amount: 'IDR 10'),
      ];

      expect(useCases.totalIncome(txs), 30);
      expect(useCases.totalExpense(txs), 10);
      expect(useCases.totalLoan(txs), 0);
      expect(useCases.netProfit(txs), 20);
      expect(useCases.totalCash(txs), 30);
      expect(
        useCases.totalAsset(const [
          Asset(id: '1', name: 'Kas', balance: 'IDR 70'),
        ]),
        70,
      );
    });
  });

  group('Skenario model statistik', () {
    test('default domain semua nol', () {
      const stats = Statistics();

      expect(stats.totalIncome, 0);
      expect(stats.totalExpense, 0);
      expect(stats.totalProfit, 0);
      expect(stats.totalLoan, 0);
      expect(stats.totalCash, 0);
      expect(stats.totalAsset, 0);
    });

    test('adapter Statistics.fromJson memakai default saat kosong', () {
      final stats = data.Statistics.fromJson(const {});

      expect(stats.totalIncome, 0);
      expect(stats.totalAsset, 0);
    });

    test('adapter Statistics.fromJson membaca semua field', () {
      final stats = data.Statistics.fromJson(const {
        'totalIncome': 10,
        'totalExpense': 4,
        'totalProfit': 6,
        'totalLoan': 2,
        'totalCash': 1,
        'totalAsset': 100,
      });

      expect(stats.totalIncome, 10);
      expect(stats.totalProfit, 6);
      expect(stats.totalAsset, 100);
    });
  });
}
