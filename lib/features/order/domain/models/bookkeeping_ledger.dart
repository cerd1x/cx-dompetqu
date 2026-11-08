import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:dompetqu/features/transactions/domain/models/transaction.dart';

part 'generated/bookkeeping_ledger.freezed.dart';

/// Buku besar satu bulan — hasil query `bookkeepingLedger`.
@freezed
abstract class BookkeepingLedger with _$BookkeepingLedger {
  const factory BookkeepingLedger({
    required String month,
    required BookkeepingFilter filter,
    required List<BookkeepingSummary> summaries,
    required List<BookkeepingDayGroup> groups,
  }) = _BookkeepingLedger;
}

/// Ringkasan per mata uang.
@freezed
abstract class BookkeepingSummary with _$BookkeepingSummary {
  const factory BookkeepingSummary({
    required String currency,
    required String income,
    required String expense,
    required String profit,
    required int transactionCount,
  }) = _BookkeepingSummary;
}

/// Grup transaksi satu hari.
@freezed
abstract class BookkeepingDayGroup with _$BookkeepingDayGroup {
  const factory BookkeepingDayGroup({
    required String date,
    required int transactionCount,
    required List<BookkeepingEntry> entries,
  }) = _BookkeepingDayGroup;
}

/// Satu baris ledger: transaksi + saldo berjalan.
@freezed
abstract class BookkeepingEntry with _$BookkeepingEntry {
  const factory BookkeepingEntry({
    required Transaction transaction,
    required String runningBalance,
  }) = _BookkeepingEntry;
}

/// Filter tipe transaksi — cerminan enum GraphQL.
enum BookkeepingFilter {
  all,
  income,
  expense,
  transfer,
  outcome;

  String get label => switch (this) {
    BookkeepingFilter.all => 'All',
    BookkeepingFilter.income => 'Income',
    BookkeepingFilter.expense => 'Expense',
    BookkeepingFilter.transfer => 'Transfer',
    BookkeepingFilter.outcome => 'Outcome',
  };

  String get graphqlValue => name;
}
