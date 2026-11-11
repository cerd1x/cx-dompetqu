import 'package:dompetqu/features/assets/domain/models/asset.dart';
import 'package:dompetqu/features/statistics/domain/repositories/statistics_repository.dart';
import 'package:dompetqu/features/transactions/domain/models/transaction.dart';

/// Use case statistik — delegasi ke [StatisticsRepository].
class StatisticsUseCases {
  const StatisticsUseCases(this._repository);

  final StatisticsRepository _repository;

  num totalIncome(List<Transaction> transactions) =>
      _repository.totalIncome(transactions);

  num totalExpense(List<Transaction> transactions) =>
      _repository.totalExpense(transactions);

  num totalLoan(List<Transaction> transactions) =>
      _repository.totalLoan(transactions);

  num netProfit(List<Transaction> transactions) =>
      _repository.netProfit(transactions);

  num totalCash(List<Transaction> transactions) =>
      _repository.totalCash(transactions);

  num totalAsset(List<Asset> assets) => _repository.totalAsset(assets);
}
