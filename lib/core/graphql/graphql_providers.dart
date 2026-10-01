import 'package:graphql/client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../config/api_config.dart';
import '../logger/app_logger.dart';
import '../network/cookie_aware_client.dart';

part 'graphql_providers.g.dart';

/// Link observability: catat setiap operasi GraphQL + error ke [AppLogger].
///
/// Ini menjamin semua remote source (auth, transactions, assets, dsb.)
/// otomatis terlacak tanpa mengubah masing-masing method.
class _GraphQLLogLink extends Link {
  final AppLogger _log = AppLogger.instance;

  @override
  Stream<Response> request(Request operation, [NextLink? forward]) async* {
    final opName = operation.operation.operationName ?? '(anonymous)';
    _log.debug('Request: $opName', tag: 'GraphQL');
    final upstream = forward?.call(operation) ?? const Stream<Response>.empty();
    await for (final response in upstream) {
      final errors = response.errors;
      if (errors != null && errors.isNotEmpty) {
        _log.error('$opName gagal: ${errors.first.message}', tag: 'GraphQL');
      }
      yield response;
    }
  }
}

/// Client HTTP yang mengelola cookie session (persist antar request).
@Riverpod(keepAlive: true)
CookieAwareClient cookieAwareClient(Ref ref) => CookieAwareClient();

/// GraphQL client tunggal untuk seluruh app, mirip `urql_client.ts` di web.
///
/// `queryRequestTimeout` dinaikkan dari default 5s → 30s: saat startup semua
/// controller load bersamaan dan backend dev (turso/D1) bisa lambat >5s,
/// default 5s membuat query timeout lalu data tampil kosong/error.
@Riverpod(keepAlive: true)
GraphQLClient graphQLClient(Ref ref) {
  final cookieClient = ref.watch(cookieAwareClientProvider);
  final httpLink = HttpLink(
    ApiConfig.graphqlEndpoint,
    httpClient: cookieClient,
  );
  AppLogger.instance.info(
    'GraphQL endpoint: ${ApiConfig.graphqlEndpoint}',
    tag: 'GraphQL',
  );
  return GraphQLClient(
    link: Link.from([_GraphQLLogLink(), httpLink]),
    cache: GraphQLCache(store: InMemoryStore()),
    queryRequestTimeout: const Duration(seconds: 30),
  );
}
