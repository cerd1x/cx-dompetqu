import 'package:cx_dompetqiu/core/utils/balance.dart';
import 'package:cx_dompetqiu/features/assets/domain/models/asset.dart';
import 'package:cx_dompetqiu/features/statistics/domain/repositories/statistics_repository.dart';
import 'package:cx_dompetqiu/features/transactions/domain/models/transaction.dart';

/// Implementasi [StatisticsRepository] — perhitungan sisi klien dari data
/// transaksi dan aset.
class StatisticsRepositoryImpl implements StatisticsRepository {
  @override
  num totalIncome(List<Transaction> transactions) => transactions
      .where((t) => t.type == 'income')
      .fold(0, (sum, t) => sum + t.amountValue);

  @override
  num totalExpense(List<Transaction> transactions) => transactions
      .where((t) => t.type == 'expense')
      .fold(0, (sum, t) => sum + t.amountValue);

  @override
  num totalLoan(List<Transaction> transactions) => transactions
      .where((t) => t.type == 'loan')
      .fold(0, (sum, t) => sum + t.amountValue);

  @override
  num netProfit(List<Transaction> transactions) {
    final income = totalIncome(transactions);
    final expense = totalExpense(transactions);
    return income - expense;
  }

  @override
  num totalCash(List<Transaction> transactions) => transactions
      .where((t) => t.paymentMethod?.type == 'cash')
      .fold(0, (sum, t) => sum + t.amountValue);

  @override
  num totalAsset(List<Asset> assets) => assets.fold(0, (sum, a) {
    try {
      return sum + Balance.parse(a.balance).value;
    } on FormatException {
      return sum;
    }
  });
}
