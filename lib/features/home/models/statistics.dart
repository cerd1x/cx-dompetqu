import 'package:freezed_annotation/freezed_annotation.dart';

part 'statistics.freezed.dart';
part 'statistics.g.dart';

/// Padanan `Statistic` di schema GraphQL (`services/domain/statistic`).
@freezed
abstract class Statistics with _$Statistics {
  const factory Statistics({
    @Default(0) num totalIncome,
    @Default(0) num totalExpense,
    @Default(0) num totalProfit,
    @Default(0) num totalLoan,
    @Default(0) num totalCash,
    @Default(0) num totalAsset,
  }) = _Statistics;

  factory Statistics.fromJson(Map<String, dynamic> json) =>
      _$StatisticsFromJson(json);
}
