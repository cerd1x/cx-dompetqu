import 'package:graphql/client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:dompetqu/core/graphql/graphql_providers.dart';
import 'package:dompetqu/features/dashboard/adapters/datasources/home_datasources.dart';
import 'package:dompetqu/features/transactions/data/models/transaction.dart';
import 'package:dompetqu/features/transactions/data/models/transaction_page.dart';
import 'package:dompetqu/core/graphql/gql_result.dart';

part 'generated/transactions_remote_source.g.dart';

/// Remote source GraphQL untuk modul transactions — padanan `sources/transaction_source.ts`.
class TransactionsRemoteSource implements TransactionsDataSource {
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
        paymentStatus
        createdAt
      }
    }
  ''';

  static const _transactionsPageQuery = r'''
    query TransactionsPage($first: Int, $after: String, $last: Int, $before: String) {
      transactionConnection(first: $first, after: $after, last: $last, before: $before) {
        edges { cursor node { id type amount capital description category paymentMethod { type assetId } customerId status paymentStatus createdAt } }
        pageInfo { hasNextPage hasPreviousPage startCursor endCursor }
      }
    }
  ''';

  static const _updatePaymentStatusMutation = r'''
    mutation UpdateTransactionPaymentStatus($id: ID!, $input: UpdateTransactionInput!) {
      updateTransaction(id: $id, input: $input) {
        id
        paymentStatus
        customerId
      }
    }
  ''';

  @override
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
  @override
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

  /// Ubah status pembayaran transaksi (`unpaid` ↔ `paid`).
  ///
  /// `UpdateTransactionInput.customerId` bertipe non-null (`ID!`) di SDL
  /// `services/domain/transactions/adapters/driving/graphql/transaction.gql`,
  /// padahal transaksi tanpa pelanggan tidak menyimpan nilai apa pun. Karena
  /// resolver backend memperlakukan nilai falsy sebagai "tidak diubah"
  /// (`input.customerId ? ID.new(...) : undefined`), transaksi tanpa pelanggan
  /// dikirim sebagai string kosong — relasi pelanggan tidak ikut berubah.
  @override
  Future<Transaction> updatePaymentStatus(
    String id, {
    required String paymentStatus,
    String? customerId,
  }) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(_updatePaymentStatusMutation),
        variables: {
          'id': id,
          'input': {
            'paymentStatus': paymentStatus,
            'customerId': customerId ?? '',
          },
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    );
    final updated = result.data?['updateTransaction'];
    if (updated == null) {
      throw StateError(
        gqlErrorMessage(result, fallback: 'Gagal mengubah status pembayaran'),
      );
    }
    return Transaction.fromJson(updated as Map<String, dynamic>);
  }
}

@Riverpod(keepAlive: true)
TransactionsRemoteSource transactionsRemoteSource(Ref ref) =>
    TransactionsRemoteSource(ref.watch(graphQLClientProvider));
