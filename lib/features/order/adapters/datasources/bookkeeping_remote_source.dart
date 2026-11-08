import 'package:graphql/client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:dompetqu/core/graphql/gql_result.dart';
import 'package:dompetqu/core/graphql/graphql_providers.dart';
import 'package:dompetqu/core/logger/app_logger.dart';
import 'package:dompetqu/features/transactions/domain/models/transaction.dart';
import 'package:dompetqu/features/order/domain/models/bookkeeping_ledger.dart';
import 'package:dompetqu/features/order/domain/models/bookkeeping_failed_payments.dart';

part 'generated/bookkeeping_remote_source.g.dart';

/// Remote source GraphQL untuk bookkeeping API — server menghitung ringkasan,
/// saldo berjalan, dan grup tanggal.
class BookkeepingRemoteSource {
  BookkeepingRemoteSource(this._client);

  final GraphQLClient _client;
  final AppLogger _log = AppLogger.instance;

  static const _ledgerQuery = r'''
    query BookkeepingLedger($input: BookkeepingLedgerInput!) {
      bookkeepingLedger(input: $input) {
        month
        filter
        summaries {
          currency
          income
          expense
          profit
          transactionCount
        }
        groups {
          date
          transactionCount
          entries {
            transaction {
              id
              type
              amount
              capital
              description
              category
              paymentMethod { type assetId }
              customerId
              status
              paymentStatus
              createdAt
            }
            runningBalance
          }
        }
      }
    }
  ''';

  /// Ambil buku besar satu bulan dari server.
  Future<BookkeepingLedger> getLedger({
    required String month,
    required BookkeepingFilter filter,
    required int timezoneOffsetMinutes,
  }) async {
    final result = await _client.query(
      QueryOptions(
        document: gql(_ledgerQuery),
        variables: {
          'input': {
            'month': month,
            'timezoneOffsetMinutes': timezoneOffsetMinutes,
            'filter': filter.graphqlValue,
          },
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    );
    final data = result.data?['bookkeepingLedger'];
    if (data == null) {
      final msg = gqlErrorMessage(result, fallback: 'Gagal memuat buku besar');
      _log.error(
        'getLedger gagal: $msg',
        tag: 'BookkeepingRemote',
        extras: {'month': month, 'filter': filter.name},
      );
      throw StateError(msg);
    }
    _log.success(
      'Ledger dimuat untuk $month (${filter.name})',
      tag: 'BookkeepingRemote',
    );
    return _parseLedger(data as Map<String, dynamic>);
  }

  static const _failedPaymentsQuery = r'''
    query BookkeepingFailedPayments($input: BookkeepingFailedPaymentsInput!) {
      bookkeepingFailedPayments(input: $input) {
        month
        payments {
          id
          amount
          method
          status
          gatewayRef
          description
          retryCount
          maxRetries
          canRetry
          lastError
          createdAt
          updatedAt
        }
        totalCount
        retryableCount
      }
    }
  ''';

  /// Ambil payment gagal satu bulan dari server.
  Future<BookkeepingFailedPaymentsResult> getFailedPayments({
    required String month,
    required int timezoneOffsetMinutes,
  }) async {
    final result = await _client.query(
      QueryOptions(
        document: gql(_failedPaymentsQuery),
        variables: {
          'input': {
            'month': month,
            'timezoneOffsetMinutes': timezoneOffsetMinutes,
          },
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    );
    final data = result.data?['bookkeepingFailedPayments'];
    if (data == null) {
      final msg = gqlErrorMessage(
        result,
        fallback: 'Gagal memuat payment gagal',
      );
      _log.error(
        'getFailedPayments gagal: $msg',
        tag: 'BookkeepingRemote',
        extras: {'month': month},
      );
      throw StateError(msg);
    }
    _log.success(
      'Failed payments dimuat untuk $month',
      tag: 'BookkeepingRemote',
    );
    return _parseFailedPayments(data as Map<String, dynamic>);
  }

  /// Parse JSON GraphQL → domain BookkeepingLedger.
  BookkeepingLedger _parseLedger(Map<String, dynamic> json) {
    final summaries =
        (json['summaries'] as List<dynamic>?)
            ?.map((s) => _parseSummary(s as Map<String, dynamic>))
            .toList() ??
        [];
    final groups =
        (json['groups'] as List<dynamic>?)
            ?.map((g) => _parseDayGroup(g as Map<String, dynamic>))
            .toList() ??
        [];

    // Parse filter string → enum
    final filterStr = json['filter'] as String? ?? 'all';
    final filter = BookkeepingFilter.values.firstWhere(
      (f) => f.name == filterStr,
      orElse: () => BookkeepingFilter.all,
    );

    return BookkeepingLedger(
      month: json['month'] as String? ?? '',
      filter: filter,
      summaries: summaries,
      groups: groups,
    );
  }

  BookkeepingSummary _parseSummary(Map<String, dynamic> json) {
    return BookkeepingSummary(
      currency: json['currency'] as String? ?? 'IDR',
      income: _moneyValue(json['income']),
      expense: _moneyValue(json['expense']),
      profit: _moneyValue(json['profit']),
      transactionCount: json['transactionCount'] as int? ?? 0,
    );
  }

  BookkeepingDayGroup _parseDayGroup(Map<String, dynamic> json) {
    final entries =
        (json['entries'] as List<dynamic>?)
            ?.map((e) => _parseEntry(e as Map<String, dynamic>))
            .toList() ??
        [];
    return BookkeepingDayGroup(
      date: json['date'] as String? ?? '',
      transactionCount: json['transactionCount'] as int? ?? 0,
      entries: entries,
    );
  }

  BookkeepingEntry _parseEntry(Map<String, dynamic> json) {
    final txJson = json['transaction'] as Map<String, dynamic>?;

    return BookkeepingEntry(
      transaction: txJson != null
          ? Transaction(
              id: txJson['id']?.toString() ?? '',
              type: txJson['type'] as String? ?? 'income',
              amount: _moneyString(txJson['amount']),
              capital: txJson['capital'] as String?,
              description: txJson['description'] as String?,
              category: txJson['category'] as String?,
              paymentMethod: txJson['paymentMethod'] != null
                  ? PaymentMethod(
                      type:
                          (txJson['paymentMethod']
                                  as Map<String, dynamic>?)?['type']
                              as String? ??
                          'cash',
                      assetId:
                          (txJson['paymentMethod']
                                  as Map<String, dynamic>?)?['assetId']
                              ?.toString(),
                    )
                  : null,
              customerId: txJson['customerId']?.toString(),
              status: txJson['status'] as String? ?? 'success',
              paymentStatus: txJson['paymentStatus'] as String? ?? 'unpaid',
              createdAt:
                  DateTime.tryParse(txJson['createdAt'] as String? ?? '') ??
                  DateTime.now(),
            )
          : Transaction(id: '', createdAt: DateTime.now()),
      runningBalance: _moneyString(json['runningBalance']),
    );
  }

  /// Parse scalar Money backend ("CURRENCY AMOUNT") → string domain.
  ///
  /// Backend `Money!` dikirim sebagai string "IDR 1500000" (scalar).
  /// Map {currency, amount} hanya didukung untuk backward-compat bila
  /// server belum migrasi.
  String _moneyString(Object? money) {
    if (money is String) return money;
    if (money is! Map<String, dynamic>) return 'IDR 0';
    final currency = money['currency'] as String? ?? 'IDR';
    final amount = money['amount'];
    if (amount == null) return '$currency 0';
    return '$currency $amount';
  }

  /// Parse scalar Money backend ("CURRENCY AMOUNT") → string domain.
  ///
  /// Backend `Money!` dikirim sebagai string "IDR 1500000" (scalar).
  /// Map {currency, amount} hanya didukung untuk backward-compat.
  String _moneyValue(Object? money) {
    if (money is String) return money;
    if (money is! Map<String, dynamic>) return 'IDR 0';
    final currency = money['currency'] as String? ?? 'IDR';
    final amount = money['amount'] ?? 0;
    return '$currency $amount';
  }

  /// Parse JSON GraphQL → domain BookkeepingFailedPaymentsResult.
  BookkeepingFailedPaymentsResult _parseFailedPayments(
    Map<String, dynamic> json,
  ) {
    final payments =
        (json['payments'] as List<dynamic>?)
            ?.map((p) => _parseFailedPayment(p as Map<String, dynamic>))
            .toList() ??
        [];
    return BookkeepingFailedPaymentsResult(
      month: json['month'] as String? ?? '',
      payments: payments,
      totalCount: json['totalCount'] as int? ?? 0,
      retryableCount: json['retryableCount'] as int? ?? 0,
    );
  }

  BookkeepingFailedPayment _parseFailedPayment(Map<String, dynamic> json) {
    return BookkeepingFailedPayment(
      id: json['id']?.toString() ?? '',
      amount: _moneyString(json['amount']),
      method: json['method'] as String? ?? 'cash',
      status: json['status'] as String? ?? 'failed',
      gatewayRef: json['gatewayRef'] as String?,
      description: json['description'] as String?,
      retryCount: json['retryCount'] as int? ?? 0,
      maxRetries: json['maxRetries'] as int? ?? 3,
      canRetry: json['canRetry'] as bool? ?? false,
      lastError: json['lastError'] as String?,
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
    );
  }
}

@Riverpod(keepAlive: true)
BookkeepingRemoteSource bookkeepingRemoteSource(Ref ref) =>
    BookkeepingRemoteSource(ref.watch(graphQLClientProvider));
