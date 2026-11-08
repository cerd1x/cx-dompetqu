import 'package:dompetqu/features/order/domain/models/bookkeeping_ledger.dart';
import 'package:dompetqu/features/order/domain/models/bookkeeping_failed_payments.dart';
import 'package:dompetqu/features/order/domain/repositories/bookkeeping_repository.dart';
import 'package:dompetqu/features/order/adapters/datasources/bookkeeping_remote_source.dart';

/// Implementasi BookkeepingRepository — delegasi ke remote source.
class BookkeepingRepositoryImpl implements BookkeepingRepository {
  BookkeepingRepositoryImpl(this._source);

  final BookkeepingRemoteSource _source;

  @override
  Future<BookkeepingLedger> getLedger({
    required String month,
    required BookkeepingFilter filter,
    required int timezoneOffsetMinutes,
  }) {
    return _source.getLedger(
      month: month,
      filter: filter,
      timezoneOffsetMinutes: timezoneOffsetMinutes,
    );
  }

  @override
  Future<BookkeepingFailedPaymentsResult> getFailedPayments({
    required String month,
    required int timezoneOffsetMinutes,
  }) {
    return _source.getFailedPayments(
      month: month,
      timezoneOffsetMinutes: timezoneOffsetMinutes,
    );
  }
}
