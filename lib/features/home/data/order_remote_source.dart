import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql/client.dart';

import '../../../core/graphql/graphql_providers.dart';
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
    final result = await _client.mutate(
      MutationOptions(
        document: gql(_saleMutation),
        variables: {
          'input': {
            'productId': productId,
            'itemCount': itemCount,
            'totalAmount': totalAmount.toDouble(),
            'currency': currency,
            'paymentMethod': ?paymentMethod,
            'customerId': ?customerId,
            'description': ?description,
            'payToAssetId': ?payToAssetId,
          },
        },
      ),
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
