// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Statistics _$StatisticsFromJson(Map<String, dynamic> json) => _Statistics(
  totalIncome: json['totalIncome'] as num? ?? 0,
  totalExpense: json['totalExpense'] as num? ?? 0,
  totalProfit: json['totalProfit'] as num? ?? 0,
  totalLoan: json['totalLoan'] as num? ?? 0,
  totalCash: json['totalCash'] as num? ?? 0,
  totalAsset: json['totalAsset'] as num? ?? 0,
);

Map<String, dynamic> _$StatisticsToJson(_Statistics instance) =>
    <String, dynamic>{
      'totalIncome': instance.totalIncome,
      'totalExpense': instance.totalExpense,
      'totalProfit': instance.totalProfit,
      'totalLoan': instance.totalLoan,
      'totalCash': instance.totalCash,
      'totalAsset': instance.totalAsset,
    };
