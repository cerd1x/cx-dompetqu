import 'package:dompetqu/features/order/domain/models/bookkeeping_failed_payments.dart';
import 'package:dompetqu/features/order/domain/models/bookkeeping_ledger.dart';

/// Repository interface untuk bookkeeping API.
abstract interface class BookkeepingRepository {
  /// Ambil buku besar satu bulan.
  Future<BookkeepingLedger> getLedger({
    required String month,
    required BookkeepingFilter filter,
    required int timezoneOffsetMinutes,
  });

  /// Ambil payment yang gagal satu bulan.
  Future<BookkeepingFailedPaymentsResult> getFailedPayments({
    required String month,
    required int timezoneOffsetMinutes,
  });
}
