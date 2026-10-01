import 'package:graphql/client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/graphql/graphql_providers.dart';
import '../models/transaction.dart';
import '../models/transaction_page.dart';
import 'gql_result.dart';

part 'transactions_remote_source.g.dart';

/// Remote source GraphQL untuk modul transactions — padanan `sources/transaction_source.ts`.
class TransactionsRemoteSource {
  TransactionsRemoteSource(this._client);

  final GraphQLClient _client;

  static const _transactionsQuery = r'''
    query Transactions {
      transactions {
        id
        type
        amount
        capital
        description
        category
        paymentMethod { type assetId }
        customerId
        status
        createdAt
      }
    }
  ''';

  static const _transactionsPageQuery = r'''
    query TransactionsPage($first: Int, $after: String, $last: Int, $before: String) {
      transactionConnection(first: $first, after: $after, last: $last, before: $before) {
        edges { cursor node { id type amount capital description category paymentMethod { type assetId } customerId status createdAt } }
        pageInfo { hasNextPage hasPreviousPage startCursor endCursor }
      }
    }
  ''';

  Future<List<Transaction>> transactions() async {
    final result = await _client.query(
      QueryOptions(
        document: gql(_transactionsQuery),
        fetchPolicy: FetchPolicy.noCache,
      ),
    );
    final list = result.data?['transactions'];
    if (list == null) {
      throw StateError(
        gqlErrorMessage(result, fallback: 'Gagal memuat transaksi'),
      );
    }
    return (list as List<dynamic>)
        .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Halaman transaksi dengan keyset pagination — padanan `transactionsPage()` di
  /// `services/domain/transactions/transactions.composition.ts`.
  ///
  /// Navigasi maju: [first] + [after]. Navigasi mundur: [last] + [before].
  /// [first] dan [last] tidak boleh dipakai bersamaan — server menolak dengan
  /// `"Cannot combine 'first' with 'last'"`. Tanpa argumen apa pun server memakai
  /// `DEFAULT_PAGE_SIZE` (20) dan mengembalikan halaman paling awal.
  ///
  /// [after]/[before] harus berupa cursor opaque dari
  /// [TransactionPage.nextCursor]/[TransactionPage.previousCursor] halaman sebelumnya.
  Future<TransactionPage> transactionsPage({
    int? first,
    String? after,
    int? last,
    String? before,
  }) async {
    final result = await _client.query(
      QueryOptions(
        document: gql(_transactionsPageQuery),
        variables: {
          'first': ?first,
          'after': ?after,
          'last': ?last,
          'before': ?before,
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    );
    final connection = result.data?['transactionConnection'];
    if (connection == null) {
      throw StateError(
        gqlErrorMessage(result, fallback: 'Gagal memuat halaman transaksi'),
      );
    }
    return TransactionPage.fromJson(connection as Map<String, dynamic>);
  }
}

@Riverpod(keepAlive: true)
TransactionsRemoteSource transactionsRemoteSource(Ref ref) =>
    TransactionsRemoteSource(ref.watch(graphQLClientProvider));
