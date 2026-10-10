import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../cs_dialog.dart';
import '../dompet_brand.dart';

/// Menampilkan date-range picker bergaya CS glass dan mengembalikan
/// [DateTimeRange] terpilih (atau null jika dibatalkan).
///
/// Kalender digambar manual (bukan `showDateRangePicker` bawaan) supaya
/// tampilannya sepenuhnya konsisten dengan tema frosted-glass app;
/// container memakai [CsDialog].
///
/// Contoh:
/// ```dart
/// final range = await showCsDateRangePicker(
///   context: context,
///   firstDate: DateTime(2020),
///   lastDate: DateTime.now(),
/// );
/// ```
Future<DateTimeRange?> showCsDateRangePicker({
  required BuildContext context,
  required DateTime firstDate,
  required DateTime lastDate,
  DateTimeRange? initialDateRange,
  String title = 'Pilih Rentang',
}) {
  return showDialog<DateTimeRange>(
    context: context,
    barrierDismissible: false,
    builder: (_) => CsDateRangePicker(
      firstDate: firstDate,
      lastDate: lastDate,
      initialDateRange: initialDateRange,
      title: title,
    ),
  );
}

/// Dialog pemilih rentang tanggal — kalender satu bulan dengan navigasi
/// bulan, seleksi rentang dua ketukan, dan aksi Batal/Terapkan.
class CsDateRangePicker extends StatefulWidget {
  const CsDateRangePicker({
    super.key,
    required this.firstDate,
    required this.lastDate,
    this.initialDateRange,
    this.title = 'Pilih Rentang',
  });

  final DateTime firstDate;
  final DateTime lastDate;
  final DateTimeRange? initialDateRange;
  final String title;

  @override
  State<CsDateRangePicker> createState() => _CsDateRangePickerState();
}

class _CsDateRangePickerState extends State<CsDateRangePicker> {
  late DateTime _visible;
  DateTime? _start;
  DateTime? _end;

  static const _weekdays = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

  /// Nama bulan manual — TIDAK memakai DateFormat(locale) supaya bebas
  /// dari LocaleDataException (data simbol intl tidak dijamin termuat).
  static const _monthsFull = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];
  static const _monthsShort = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];

  @override
  void initState() {
    super.initState();
    _start = widget.initialDateRange?.start;
    _end = widget.initialDateRange?.end;
    final anchor = _start ?? DateTime.now();
    _visible = DateTime(anchor.year, anchor.month);
  }

  // ── helpers ──────────────────────────────────────────────────────────

  static bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  int get _daysInMonth => DateTime(_visible.year, _visible.month + 1, 0).day;

  /// Tinggi total area kalender.
  static const double _gridHeight = 322;

  /// Jumlah baris grid bulan aktif: 1 baris label hari + sel tanggal
  /// (termasuk sel kosong leading) dibagi 7 kolom, dibulatkan ke atas.
  int get _gridRows => ((7 + _leadingBlanks + _daysInMonth) / 7).ceil();

  /// Sel kosong sebelum tanggal 1 (Senin = kolom pertama).
  int get _leadingBlanks => DateTime(_visible.year, _visible.month).weekday - 1;

  bool _isDisabled(DateTime day) =>
      day.isBefore(_dayStart(widget.firstDate)) ||
      day.isAfter(_dayStart(widget.lastDate));

  static DateTime _dayStart(DateTime d) => DateTime(d.year, d.month, d.day);

  bool _inRange(DateTime day) {
    if (_start == null || _end == null) return false;
    return !day.isBefore(_start!) && !day.isAfter(_end!);
  }

  void _onDayTap(DateTime day) {
    if (_isDisabled(day)) return;
    setState(() {
      if (_start == null || _end != null) {
        // Ketukan pertama / mulai seleksi baru.
        _start = day;
        _end = null;
      } else if (day.isBefore(_start!)) {
        _start = day;
      } else {
        _end = day;
      }
    });
  }

  void _shiftMonth(int delta) {
    final min = DateTime(widget.firstDate.year, widget.firstDate.month);
    final max = DateTime(widget.lastDate.year, widget.lastDate.month);
    var target = DateTime(_visible.year, _visible.month + delta);
    if (target.isBefore(min)) target = min;
    if (target.isAfter(max)) target = max;
    setState(() => _visible = target);
  }

  String get _rangeLabel {
    if (_start == null) return 'Pilih tanggal mulai';
    if (_end == null) {
      return '${_fmtShort(_start!)} · pilih tanggal akhir';
    }
    return '${_fmtShort(_start!)} – ${_fmtFull(_end!)}';
  }

  static String _fmtShort(DateTime d) =>
      '${d.day} ${_monthsShort[d.month - 1]}';

  static String _fmtFull(DateTime d) =>
      '${d.day} ${_monthsShort[d.month - 1]} ${d.year}';

  // ── build ────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return CsDialog(
      title: widget.title,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(foregroundColor: Colors.white54),
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: (_start != null && _end != null)
              ? () => Navigator.of(
                  context,
                ).pop(DateTimeRange(start: _start!, end: _end!))
              : null,
          style: TextButton.styleFrom(
            foregroundColor: _start != null && _end != null
                ? DompetBrand.primary
                : Colors.white24,
          ),
          child: const Text('Terapkan'),
        ),
      ],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // selected range section
          Row(
            children: [
              const Icon(
                Icons.calendar_month_outlined,
                size: 14,
                color: DompetBrand.primary,
              ),
              const SizedBox(width: 8),
              Text(
                _rangeLabel,
                style: const TextStyle(fontSize: 12.5, color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // month navigation section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _navIcon(Icons.chevron_left_rounded, _canGoBack, () {
                _shiftMonth(-1);
              }),
              Text(
                '${_monthsFull[_visible.month - 1]} ${_visible.year}',
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              _navIcon(Icons.chevron_right_rounded, _canGoForward, () {
                _shiftMonth(1);
              }),
            ],
          ),
          const SizedBox(height: 10),
          // calendar grid section (label hari + sel tanggal dalam SATU
          // grid agar kolom rata sempurna). Tinggi baris = tinggi grid /
          // jumlah baris aktual bulan tsb → angka tidak pernah terpotong,
          // sekalipun bulan punya 6 pekan.
          SizedBox(
            height: _gridHeight,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisExtent: _gridHeight / _gridRows,
              ),
              itemCount: 7 + _leadingBlanks + _daysInMonth,
              itemBuilder: (_, i) {
                if (i < 7) {
                  return Center(
                    child: Text(
                      _weekdays[i],
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.35),
                      ),
                    ),
                  );
                }
                final dayNumber = i - 7 - _leadingBlanks + 1;
                if (dayNumber < 1) return const SizedBox.shrink();
                final day = DateTime(_visible.year, _visible.month, dayNumber);
                return _DayCell(
                  day: day,
                  isDisabled: _isDisabled(day),
                  isStart: _start != null && _sameDay(day, _start!),
                  isEnd: _end != null && _sameDay(day, _end!),
                  inRange: _inRange(day),
                  isToday: _sameDay(day, DateTime.now()),
                  onTap: () => _onDayTap(day),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  bool get _canGoBack {
    final min = DateTime(widget.firstDate.year, widget.firstDate.month);
    return _visible.isAfter(min);
  }

  bool get _canGoForward {
    final max = DateTime(widget.lastDate.year, widget.lastDate.month);
    return _visible.isBefore(max);
  }

  Widget _navIcon(IconData icon, bool enabled, VoidCallback onTap) {
    return IconButton(
      onPressed: enabled ? onTap : null,
      icon: Icon(icon, size: 20),
      color: DompetBrand.primary,
      disabledColor: Colors.white24,
      visualDensity: VisualDensity.compact,
    );
  }
}

/// Satu sel tanggal — lingkaran gold untuk ujung rentang, pita tipis
/// untuk tanggal di antaranya, ring gold untuk "hari ini".
class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.onTap,
    required this.isDisabled,
    required this.isStart,
    required this.isEnd,
    required this.inRange,
    required this.isToday,
  });

  final DateTime day;
  final VoidCallback onTap;
  final bool isDisabled;
  final bool isStart;
  final bool isEnd;
  final bool inRange;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final isEndpoint = isStart || isEnd;
    final fg = isDisabled
        ? Colors.white.withValues(alpha: 0.15)
        : isEndpoint
        ? DompetBrand.blackBg
        : inRange
        ? Colors.white
        : Colors.white.withValues(alpha: 0.75);

    final bg = isEndpoint
        ? DompetBrand.primary
        : inRange
        ? DompetBrand.primary.withValues(alpha: 0.16)
        : Colors.transparent;

    final shape = isEndpoint ? BoxShape.circle : BoxShape.rectangle;

    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Box(
        style: BoxStyler()
            .alignment(Alignment.center)
            .margin(EdgeInsetsGeometryMix.value(const EdgeInsets.all(2)))
            .decoration(
              DecorationMix.value(
                BoxDecoration(
                  color: bg,
                  shape: shape,
                  borderRadius: shape == BoxShape.rectangle
                      ? BorderRadius.circular(8)
                      : null,
                  border: isToday && !isEndpoint
                      ? Border.all(
                          color: DompetBrand.primary.withValues(alpha: 0.55),
                        )
                      : null,
                ),
              ),
            ),
        child: Text('${day.day}', style: TextStyle(fontSize: 12.5, color: fg)),
      ),
    );
  }
}
