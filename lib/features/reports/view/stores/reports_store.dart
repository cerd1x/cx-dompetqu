import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:dompetqu/core/logger/app_logger.dart';
import 'package:dompetqu/core/logger/log_record.dart';
import 'package:dompetqu/features/reports/domain/repositories/reports_repository.dart';
import 'package:dompetqu/features/reports/view/stores/reports_repository_provider.dart';

part 'generated/reports_store.g.dart';

/// State untuk fitur reports / peninjauan log AppLogger.
class ReportsState {
  const ReportsState({
    this.searchQuery = '',
    this.maxRecords = 200,
    this.submitting = false,
    this.submitError,
    this.submitSuccess = false,
  });

  final String searchQuery;
  final int maxRecords;
  final bool submitting;
  final String? submitError;
  final bool submitSuccess;

  List<LogRecord> get records {
    final all = AppLogger.instance.latest(maxRecords);
    final q = searchQuery.trim().toLowerCase();
    if (q.isEmpty) return all;
    return all.where((r) {
      return r.line.toLowerCase().contains(q) ||
          r.tag.toLowerCase().contains(q);
    }).toList();
  }

  ReportsState copyWith({
    String? searchQuery,
    int? maxRecords,
    bool? submitting,
    String? submitError,
    bool? submitSuccess,
  }) => ReportsState(
    searchQuery: searchQuery ?? this.searchQuery,
    maxRecords: maxRecords ?? this.maxRecords,
    submitting: submitting ?? this.submitting,
    submitError: submitError,
    submitSuccess: submitSuccess ?? this.submitSuccess,
  );
}

@Riverpod(keepAlive: true)
class ReportsStore extends _$ReportsStore {
  @override
  ReportsState build() {
    // Dengarkan perubahan pada AppLogger agar store selalu sinkron.
    AppLogger.instance.addListener(_onLoggerChanged);
    ref.onDispose(() {
      AppLogger.instance.removeListener(_onLoggerChanged);
    });
    return const ReportsState();
  }

  void _onLoggerChanged() {
    if (!ref.mounted) return;
    // Trigger rebuild dengan menyalin state yang sama.
    state = state.copyWith();
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setMaxRecords(int max) {
    state = state.copyWith(maxRecords: max);
  }

  /// Simpan laporan (snapshot log) ke backend/database via repository.
  ///
  /// Saat ini adapter memakai ObjectBox ([ReportsObjectboxDataSource]).
  Future<void> submitReport({required String message}) async {
    if (_logger.records.isEmpty) {
      state = state.copyWith(submitError: 'Belum ada log untuk dikirim.');
      return;
    }
    state = state.copyWith(
      submitting: true,
      submitError: null,
      submitSuccess: false,
    );
    try {
      await ref
          .read(reportsRepositoryProvider)
          .submit(
            message: message,
            logs: _logger.exportJson(),
            appVersion: '1.0.0+1',
          );
      _logger.info('Laporan terkirim.', tag: 'Reports');
      if (!ref.mounted) return;
      state = state.copyWith(submitting: false, submitSuccess: true);
    } on Exception catch (e) {
      _logger.error('Gagal mengirim laporan.', error: e, tag: 'Reports');
      if (!ref.mounted) return;
      state = state.copyWith(submitting: false, submitError: e.toString());
    }
  }

  void clearLogs() {
    AppLogger.instance.clear();
  }

  AppLogger get _logger => AppLogger.instance;
}
