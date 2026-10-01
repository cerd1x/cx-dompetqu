import '../../../core/utils/balance.dart';
import '../models/transaction.dart';

/// Titik data harian hasil agregasi transaksi.
class DailyPoint {
  const DailyPoint({required this.date, this.income = 0, this.expense = 0});

  final DateTime date;
  final num income;
  final num expense;

  num get profit => income - expense;
}

/// Seri & ringkasan yang diturunkan dari daftar transaksi.
class AnalyticsSeries {
  const AnalyticsSeries({
    required this.daily,
    required this.cumulativeProfit,
    required this.totalProfit,
  });

  final List<DailyPoint> daily;
  final List<num> cumulativeProfit;
  final num totalProfit;

  bool get isEmpty => daily.isEmpty;
}

DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

num _value(Transaction tx) {
  try {
    return Balance.parse(tx.amount).value;
  } catch (_) {
    return 0;
  }
}

/// Kelompokkan transaksi per hari → income/expense/profit harian.
List<DailyPoint> dailyProfit(List<Transaction> txs) {
  final map = <DateTime, List<num>>{};
  for (final tx in txs) {
    if (tx.status != 'success') continue;
    final day = _day(tx.createdAt);
    final e = map.putIfAbsent(day, () => [0, 0]);
    final v = _value(tx);
    if (tx.type == 'expense') {
      e[1] += v;
    } else {
      e[0] += v;
    }
  }
  final keys = map.keys.toList()..sort();
  return [
    for (final k in keys)
      DailyPoint(date: k, income: map[k]![0], expense: map[k]![1]),
  ];
}

/// Bangun seri kumulatif (running profit) dari transaksi.
AnalyticsSeries buildSeries(List<Transaction> txs) {
  final daily = dailyProfit(txs);
  var run = 0.0;
  final cumulative = <num>[];
  for (final d in daily) {
    run += d.profit;
    cumulative.add(run);
  }
  return AnalyticsSeries(
    daily: daily,
    cumulativeProfit: cumulative,
    totalProfit: run,
  );
}
