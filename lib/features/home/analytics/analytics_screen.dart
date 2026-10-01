import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/dompet_brand.dart';
import '../../../core/theme/widgets/dompet_card.dart';
import '../../../core/utils/formatters.dart';
import '../application/statistics_controller.dart';
import '../application/transactions_controller.dart';
import 'analytics_data.dart';

const _kIncome = Color(0xFF34D399);
const _kExpense = Color(0xFFF87171);

/// Halaman analitik keuangan — route `/analytics`.
///
/// Menampilkan:
/// - Performance view (line/bar chart seri kumulatif + persentase)
/// - Kalender tanggal dengan indikator profit (+/-) per hari
class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  bool _barMode = false;
  DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);

  @override
  Widget build(BuildContext context) {
    final stats = ref.watch(statisticsControllerProvider);
    final transactions = ref.watch(transactionsControllerProvider);
    final series = buildSeries(transactions.items);

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (stats.error != null)
              _ErrorCard(message: stats.error!)
            else ...[
              _PercentagesCard(stats: stats),
              const SizedBox(height: 16),
              _PerformanceCard(
                series: series,
                barMode: _barMode,
                onModeChanged: (bar) => setState(() => _barMode = bar),
              ),
              const SizedBox(height: 16),
              _CalendarCard(
                month: _month,
                series: series,
                onPrev: () => setState(
                  () => _month = DateTime(_month.year, _month.month - 1),
                ),
                onNext: () => setState(
                  () => _month = DateTime(_month.year, _month.month + 1),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Kartu error bila load gagal.
class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return DompetCard(
      variant: DompetCardVariant.csGlassSurface,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: _kExpense, size: 40),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

/// Breakdown persentase dari statistik dashboard.
class _PercentagesCard extends StatelessWidget {
  const _PercentagesCard({required this.stats});
  final StatisticsState stats;

  @override
  Widget build(BuildContext context) {
    final s = stats.statistics;
    final totalFlow = s.totalIncome + s.totalExpense;
    final incomePct = totalFlow == 0
        ? 0
        : (s.totalIncome / totalFlow * 100).clamp(0, 100);
    final expensePct = 100 - incomePct;
    final margin =
        s.totalIncome == 0 ? 0 : (s.totalProfit / s.totalIncome * 100);

    return DompetCard(
      variant: DompetCardVariant.csGlassCard,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Persentase',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          if (totalFlow == 0)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: const LinearProgressIndicator(
                value: 1,
                minHeight: 10,
                backgroundColor: Colors.white10,
              ),
            )
          else
            _FlowBar(
              incomeFlex: incomePct.toInt().clamp(0, 100),
              expenseFlex: expensePct.toInt().clamp(0, 100),
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              _Pill(label: 'Income', pct: incomePct, color: _kIncome),
              const SizedBox(width: 8),
              _Pill(label: 'Expense', pct: expensePct, color: _kExpense),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Margin',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white54,
                    ),
                  ),
                  Text(
                    '${margin.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: margin >= 0 ? _kIncome : _kExpense,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FlowBar extends StatelessWidget {
  const _FlowBar({required this.incomeFlex, required this.expenseFlex});
  final int incomeFlex;
  final int expenseFlex;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        height: 10,
        child: Row(
          children: [
            Expanded(flex: incomeFlex, child: const ColoredBox(color: _kIncome)),
            if (expenseFlex > 0 && incomeFlex > 0) const SizedBox(width: 2),
            Expanded(flex: expenseFlex, child: const ColoredBox(color: _kExpense)),
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.pct, required this.color});
  final String label;
  final num pct;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$label ${pct.toStringAsFixed(0)}%',
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color),
      ),
    );
  }
}

/// Mode tampilan performance: line atau bar (seri kumulatif).
class _PerformanceCard extends StatelessWidget {
  const _PerformanceCard({
    required this.series,
    required this.barMode,
    required this.onModeChanged,
  });

  final AnalyticsSeries series;
  final bool barMode;
  final ValueChanged<bool> onModeChanged;

  @override
  Widget build(BuildContext context) {
    return DompetCard(
      variant: DompetCardVariant.csGlassCard,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Performance',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              SegmentedButton<bool>(
                showSelectedIcon: false,
                style: SegmentedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  textStyle: const TextStyle(fontSize: 11),
                ),
                segments: const [
                  ButtonSegment(
                    value: false,
                    icon: Icon(Icons.show_chart, size: 14),
                    label: Text('Line'),
                  ),
                  ButtonSegment(
                    value: true,
                    icon: Icon(Icons.bar_chart, size: 14),
                    label: Text('Bar'),
                  ),
                ],
                selected: {barMode},
                onSelectionChanged: (v) => onModeChanged(v.first),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: series.isEmpty || series.daily.length == 1
                ? const _EmptyChart()
                : (barMode ? _BarCumulative(series: series) : _LineCumulative(series: series)),
          ),
        ],
      ),
    );
  }
}

class _LineCumulative extends StatelessWidget {
  const _LineCumulative({required this.series});
  final AnalyticsSeries series;

  @override
  Widget build(BuildContext context) {
    final data = [
      for (var i = 0; i < series.cumulativeProfit.length; i++)
        _ChartPoint(series.cumulativeProfit[i], series.daily[i].date),
    ];

    return SfCartesianChart(
      margin: const EdgeInsets.only(top: 8, right: 8),
      plotAreaBorderColor: Colors.transparent,
      primaryXAxis: DateTimeAxis(
        majorGridLines: const MajorGridLines(width: 0),
        axisLine: const AxisLine(width: 0),
        labelStyle: const TextStyle(fontSize: 9, color: Colors.white38),
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        interval: 1,
        intervalType: DateTimeIntervalType.days,
        labelFormat: 'dd/MM',
        // Keep x-axis range tight to the data span.
        minimum: data.first.date.subtract(const Duration(days: 1)),
        maximum: data.last.date.add(const Duration(days: 1)),
      ),
      primaryYAxis: NumericAxis(
        majorGridLines: const MajorGridLines(color: Color(0x1AFFFFFF)),
        axisLine: const AxisLine(width: 0),
        labelStyle: const TextStyle(fontSize: 9, color: Colors.white38),
        numberFormat: NumberFormat.compact(),
      ),
      series: [
        FastLineSeries<_ChartPoint, DateTime>(
          dataSource: data,
          xValueMapper: (p, _) => p.date,
          yValueMapper: (p, _) => p.value.toDouble(),
          name: 'Profit',
          color: _kIncome,
          width: 3,
          markerSettings: const MarkerSettings(
            isVisible: false,
            shape: DataMarkerType.circle,
          ),
        ),
      ],
      tooltipBehavior: TooltipBehavior(
        enable: true,
        header: '',
        color: const Color(0xFF1A1A1A),
        builder: (data, point, series, pointIndex, int seriesIndex) {
          final p = data as _ChartPoint;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('d MMM').format(p.date),
                  style: const TextStyle(fontSize: 10, color: Colors.white70),
                ),
                Text(
                  formatMoney(p.value, 'IDR'),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _BarCumulative extends StatelessWidget {
  const _BarCumulative({required this.series});
  final AnalyticsSeries series;

  @override
  Widget build(BuildContext context) {
    final data = [
      for (var i = 0; i < series.cumulativeProfit.length; i++)
        _ChartPoint(series.cumulativeProfit[i], series.daily[i].date),
    ];

    return SfCartesianChart(
      margin: const EdgeInsets.only(top: 8, right: 8),
      plotAreaBorderColor: Colors.transparent,
      primaryXAxis: DateTimeAxis(
        majorGridLines: const MajorGridLines(width: 0),
        axisLine: const AxisLine(width: 0),
        labelStyle: const TextStyle(fontSize: 9, color: Colors.white38),
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        interval: 1,
        intervalType: DateTimeIntervalType.days,
        labelFormat: 'dd/MM',
        minimum: data.first.date.subtract(const Duration(days: 1)),
        maximum: data.last.date.add(const Duration(days: 1)),
      ),
      primaryYAxis: NumericAxis(
        majorGridLines: const MajorGridLines(color: Color(0x1AFFFFFF)),
        axisLine: const AxisLine(width: 0),
        labelStyle: const TextStyle(fontSize: 9, color: Colors.white38),
        numberFormat: NumberFormat.compact(),
      ),
      series: [
        ColumnSeries<_ChartPoint, DateTime>(
          dataSource: data,
          xValueMapper: (p, _) => p.date,
          yValueMapper: (p, _) => p.value.toDouble(),
          pointColorMapper: (p, _) =>
              p.value >= 0 ? _kIncome : _kExpense,
          width: 0.5,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
          dataLabelSettings: const DataLabelSettings(isVisible: false),
        ),
      ],
      tooltipBehavior: TooltipBehavior(
        enable: true,
        header: '',
        color: const Color(0xFF1A1A1A),
        builder: (data, point, series, pointIndex, int seriesIndex) {
          final p = data as _ChartPoint;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('d MMM').format(p.date),
                  style: const TextStyle(fontSize: 10, color: Colors.white70),
                ),
                Text(
                  formatMoney(p.value, 'IDR'),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Titik data untuk chart Syncfusion.
class _ChartPoint {
  const _ChartPoint(this.value, this.date);

  final num value;
  final DateTime date;
}

class _EmptyChart extends StatelessWidget {
  const _EmptyChart();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Belum ada data transaksi',
        style: TextStyle(color: Colors.white38, fontSize: 12),
      ),
    );
  }
}

/// Kalender bulanan dengan indikator profit (+/-) per tanggal.
class _CalendarCard extends StatelessWidget {
  const _CalendarCard({
    required this.month,
    required this.series,
    required this.onPrev,
    required this.onNext,
  });

  final DateTime month;
  final AnalyticsSeries series;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  static const _weekdays = ['M', 'S', 'S', 'R', 'K', 'J', 'S'];

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(month.year, month.month, 1);
    final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);
    final leading = firstDay.weekday % 7; // Senin=0

    return DompetCard(
      variant: DompetCardVariant.csGlassCard,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Text(
                'Kalender',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.chevron_left, size: 18),
                onPressed: onPrev,
              ),
              Text(
                DateFormat('MMMM yyyy').format(month),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, size: 18),
                onPressed: onNext,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              for (final w in _weekdays)
                Expanded(
                  child: Center(
                    child: Text(
                      w,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white38,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            children: [
              for (var i = 0; i < leading; i++) const SizedBox.shrink(),
              for (var day = 1; day <= daysInMonth; day++)
                _DayCell(
                  date: DateTime(month.year, month.month, day),
                  profit: _profitFor(day),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(Icons.trending_up, size: 12, color: _kIncome),
              const SizedBox(width: 4),
              Text(
                'Profit hari itu',
                style: const TextStyle(fontSize: 10, color: Colors.white54),
              ),
            ],
          ),
        ],
      ),
    );
  }

  num _profitFor(int day) {
    final t = _dayOf(day);
    for (final d in series.daily) {
      if (d.date == t) return d.profit;
    }
    return 0;
  }

  DateTime _dayOf(int day) => DateTime(month.year, month.month, day);
}

class _DayCell extends StatelessWidget {
  const _DayCell({required this.date, required this.profit});

  final DateTime date;
  final num profit;

  @override
  Widget build(BuildContext context) {
    final isToday =
        date.year == DateTime.now().year &&
        date.month == DateTime.now().month &&
        date.day == DateTime.now().day;
    final hasProfit = profit != 0;

    return Container(
      decoration: BoxDecoration(
        color: isToday
            ? DompetBrand.purple.withValues(alpha: 0.25)
            : Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10, width: 0.5),
      ),
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${date.day}',
            style: TextStyle(
              fontSize: 11,
              fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          if (hasProfit) ...[
            const SizedBox(height: 2),
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: profit > 0 ? _kIncome : _kExpense,
              ),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                '${profit > 0 ? '+' : '-'}Rp${profit.abs().toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 7,
                  color: profit > 0 ? _kIncome : _kExpense,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

