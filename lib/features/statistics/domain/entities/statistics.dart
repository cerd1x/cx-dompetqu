import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/statistics.freezed.dart';

/// Ringkasan statistik keuangan — padanan data model
/// `features/statistics/data/models/statistics.dart` (tanpa JSON: konversi
/// ada di mapper/repository, bukan di domain).
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

  const Statistics._();
}
