import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql/client.dart';

import '../../../core/graphql/graphql_providers.dart';
import '../../../core/logger/app_logger.dart';
import 'gql_result.dart';

/// Remote source GraphQL untuk modul order — padanan `sources/order_source.ts`.
///
/// Tanpa codegen: provider manual via [orderRemoteSourceProvider].
class OrderRemoteSource {
  OrderRemoteSource(this._client);

  final GraphQLClient _client;

  static const _saleMutation = r'''
    mutation CreateOrderProductSale($input: CreateOrderProductSaleInput!) {
      createOrderProductSale(input: $input) { id status }
    }
  ''';

  static const _expenseMutation = r'''
    mutation CreateOrderExpense($input: CreateOrderExpenseInput!) {
      createOrderExpense(input: $input) { id status }
    }
  ''';

  static const _loanMutation = r'''
    mutation CreateOrderLoan($input: CreateOrderLoanInput!) {
      createOrderLoan(input: $input) { id status }
    }
  ''';

  static const _createTransactionMutation = r'''
    mutation CreateTransaction($input: CreateTransactionInput!) {
      createTransaction(input: $input) { id status }
    }
  ''';

  /// Catat pembayaran utang sebagai transaksi income — dipakai tab Debt saat
  /// pelunasan ditebus. Pembayaran dicatat penuh tanpa keuntungan (modal ikut
  /// pulih), jadi `capital` disamakan dengan `amount`.
  Future<bool> createDebtPayment({
    required num totalAmount,
    required String currency,
    required String customerId,
    required String description,
    String paymentMethod = 'cash',
  }) async {
    final balance = '${currency.toUpperCase()} ${totalAmount.toDouble()}';
    final result = await _client.mutate(
      MutationOptions(
        document: gql(_createTransactionMutation),
        variables: {
          'input': {
            'type': 'income',
            'amount': balance,
            'capital': balance,
            'date': DateTime.now().toUtc().toIso8601String(),
            'description': description,
            'category': 'Debt Payment',
            'paymentMethod': {'type': paymentMethod},
            'customerId': customerId,
            'status': 'success',
          },
        },
      ),
    );
    return _ok(
      result,
      key: 'createTransaction',
      fallback: 'Gagal mencatat pembayaran utang',
    );
  }

  Future<bool> createProductSale({
    required String productId,
    required int itemCount,
    required num totalAmount,
    required String currency,
    String? paymentMethod,
    String? customerId,
    String? description,
    String? payToAssetId,
  }) async {
    final input =
        {
          'productId': productId,
          'itemCount': itemCount,
          'totalAmount': totalAmount.toDouble(),
          'currency': currency,
          'paymentMethod': ?paymentMethod,
          'customerId': ?customerId,
          'description': ?description,
          'payToAssetId': ?payToAssetId,
        }..removeWhere(
          (key, value) =>
              value is String &&
              (key == 'customerId' || key == 'payToAssetId') &&
              value.trim().isEmpty,
        );
    AppLogger.instance.info(
      'createOrderProductSale request',
      tag: 'OrderRemoteSource',
      extras: {'query': _saleMutation, 'input': input},
    );
    final result = await _client.mutate(
      MutationOptions(
        document: gql(_saleMutation),
        variables: {'input': input},
      ),
    );
    AppLogger.instance.info(
      'createOrderProductSale result',
      tag: 'OrderRemoteSource',
      extras: {
        'data': result.data,
        'hasException': result.hasException,
        'graphqlErrors': result.exception?.graphqlErrors
            .map((e) => e.message)
            .toList(),
        'linkException': result.exception?.linkException?.toString(),
      },
    );
    return _ok(
      result,
      key: 'createOrderProductSale',
      fallback: 'Gagal membuat transaksi penjualan',
    );
  }

  Future<bool> createExpense({
    required num totalAmount,
    required String currency,
    required int itemCount,
    String? description,
    String? paymentMethod,
    String? customerId,
    String? payWithAssetId,
    String? payToAssetId,
  }) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(_expenseMutation),
        variables: {
          'input': {
            'totalAmount': totalAmount.toDouble(),
            'currency': currency,
            'itemCount': itemCount,
            'description': ?description,
            'paymentMethod': ?paymentMethod,
            'customerId': ?customerId,
            'payWithAssetId': ?payWithAssetId,
            'payToAssetId': ?payToAssetId,
          },
        },
      ),
    );
    return _ok(
      result,
      key: 'createOrderExpense',
      fallback: 'Gagal membuat transaksi pengeluaran',
    );
  }

  Future<bool> createLoan({
    required num totalAmount,
    required String currency,
    required int itemCount,
    String? paymentMethod,
    String? customerId,
    String? description,
    String? payWithAssetId,
  }) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(_loanMutation),
        variables: {
          'input': {
            'totalAmount': totalAmount.toDouble(),
            'currency': currency,
            'itemCount': itemCount,
            'paymentMethod': ?paymentMethod,
            'customerId': ?customerId,
            'description': ?description,
            'payWithAssetId': ?payWithAssetId,
          },
        },
      ),
    );
    return _ok(
      result,
      key: 'createOrderLoan',
      fallback: 'Gagal membuat transaksi pinjaman',
    );
  }

  bool _ok(
    QueryResult result, {
    required String key,
    required String fallback,
  }) {
    if (result.hasException) {
      throw StateError(gqlErrorMessage(result, fallback: fallback));
    }
    return result.data?[key] != null;
  }
}

final orderRemoteSourceProvider = Provider<OrderRemoteSource>(
  (ref) => OrderRemoteSource(ref.watch(graphQLClientProvider)),
);
