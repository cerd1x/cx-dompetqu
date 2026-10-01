import 'package:graphql/client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/graphql/graphql_providers.dart';
import '../models/statistics.dart';
import 'gql_result.dart';

part 'statistics_remote_source.g.dart';

/// Remote source GraphQL untuk modul statistic — padanan `sources/statistic_source.ts`.
class StatisticsRemoteSource {
  StatisticsRemoteSource(this._client);

  final GraphQLClient _client;

  static const _statisticsQuery = r'''
    query Statistics {
      statistics {
        totalIncome
        totalExpense
        totalProfit
        totalLoan
        totalCash
        totalAsset
      }
    }
  ''';

  Future<Statistics> statistics() async {
    final result = await _client.query(
      QueryOptions(
        document: gql(_statisticsQuery),
        fetchPolicy: FetchPolicy.noCache,
      ),
    );
    final json = result.data?['statistics'];
    if (json == null) {
      throw StateError(
        gqlErrorMessage(result, fallback: 'Gagal memuat statistik'),
      );
    }
    return Statistics.fromJson(json as Map<String, dynamic>);
  }
}

@Riverpod(keepAlive: true)
StatisticsRemoteSource statisticsRemoteSource(Ref ref) =>
    StatisticsRemoteSource(ref.watch(graphQLClientProvider));
