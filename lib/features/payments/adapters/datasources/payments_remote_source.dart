import 'package:graphql/client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:cx_dompetqiu/core/graphql/gql_result.dart';
import 'package:cx_dompetqiu/core/graphql/graphql_providers.dart';
import 'package:cx_dompetqiu/features/payments/domain/models/payment.dart';

part 'generated/payments_remote_source.g.dart';

/// Remote source GraphQL untuk domain payment — padanan
/// `sources/payment_source.ts` di web.
///
/// Baca: `paymentsByStatus`; tulis: `retryPayment` (dipakai layar detail
/// payment gagal).
class PaymentsRemoteSource {
  PaymentsRemoteSource(this._client);

  final GraphQLClient _client;

  /// Cerminan `paymentsByStatus(status)` di
  /// `services/domain/payment/adapters/driving/graphql/payment.gql`.
  static const _paymentsByStatusQuery = r'''
    query PaymentsByStatus($status: PaymentStatusEnum!) {
      paymentsByStatus(status: $status) {
        id
        invoiceId
        amount
        currency
        method
        status
        gatewayRef
        description
        retryCount
        maxRetries
        meta {
          paymentType
          assetId
          lastError
          nextRetryDelayMs
        }
        createdAt
        updatedAt
      }
    }
  ''';

  /// Payment milik pengguna dengan [status] tertentu (mis. `failed`).
  Future<List<Payment>> byStatus(String status) async {
    final result = await _client.query(
      QueryOptions(
        document: gql(_paymentsByStatusQuery),
        variables: {'status': status},
        fetchPolicy: FetchPolicy.noCache,
      ),
    );
    final list = result.data?['paymentsByStatus'];
    if (list == null) {
      throw StateError(
        gqlErrorMessage(result, fallback: 'Gagal memuat payment'),
      );
    }
    return (list as List<dynamic>)
        .map((e) => _toPayment(e as Map<String, dynamic>))
        .toList();
  }

  /// Cerminan `retryPayment(paymentId)` di
  /// `services/domain/payment/adapters/driving/graphql/payment.gql`.
  static const _retryPaymentMutation = r'''
    mutation RetryPayment($paymentId: ID!) {
      retryPayment(paymentId: $paymentId) {
        id
        invoiceId
        amount
        currency
        method
        status
        gatewayRef
        description
        retryCount
        maxRetries
        meta {
          paymentType
          assetId
          lastError
          nextRetryDelayMs
        }
        createdAt
        updatedAt
      }
    }
  ''';

  /// Coba ulang payment gagal; mengembalikan payment terbaru dari backend.
  ///
  /// Backend menolak (GraphQL error) bila `retryCount >= maxRetries`, jadi
  /// guard `Payment.canRetry` di UI hanya optimistis — error tetap ditampilkan.
  Future<Payment> retry(String id) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(_retryPaymentMutation),
        variables: {'paymentId': id},
        fetchPolicy: FetchPolicy.noCache,
      ),
    );
    final json = result.data?['retryPayment'];
    if (json == null) {
      throw StateError(
        gqlErrorMessage(result, fallback: 'Gagal retry payment'),
      );
    }
    return _toPayment(json as Map<String, dynamic>);
  }
}

/// JSON GraphQL → entity domain. Enum dikirim backend dalam huruf kecil
/// (`failed`, `bank_transfer`), jadi dipakai apa adanya.
Payment _toPayment(Map<String, dynamic> json) => Payment(
  id: json['id'].toString(),
  invoiceId: json['invoiceId']?.toString(),
  amount: (json['amount'] as num?)?.toDouble() ?? 0,
  currency: json['currency'] as String? ?? 'IDR',
  method: json['method'] as String? ?? 'cash',
  status: json['status'] as String? ?? 'pending',
  gatewayRef: json['gatewayRef'] as String?,
  description: json['description'] as String?,
  retryCount: (json['retryCount'] as num?)?.toInt() ?? 0,
  maxRetries: (json['maxRetries'] as num?)?.toInt() ?? 3,
  metadata: _toMetadata(json['metadata']),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

/// `PaymentMetadata` GraphQL → model domain; `null` bila backend tidak
/// mengirim metadata (payment lama atau gateway tanpa detail).
PaymentMetadata? _toMetadata(Object? json) {
  if (json is! Map<String, dynamic>) return null;
  return PaymentMetadata(
    paymentType: json['paymentType'] as String?,
    assetId: (json['assetId'] as num?)?.toDouble(),
    lastError: json['lastError'] as String?,
    nextRetryDelayMs: (json['nextRetryDelayMs'] as num?)?.toDouble(),
  );
}

@Riverpod(keepAlive: true)
PaymentsRemoteSource paymentsRemoteSource(Ref ref) =>
    PaymentsRemoteSource(ref.watch(graphQLClientProvider));
