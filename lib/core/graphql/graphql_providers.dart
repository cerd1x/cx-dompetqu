import 'package:graphql/client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../config/api_config.dart';
import '../logger/app_logger.dart';
import '../network/cookie_aware_client.dart';

part 'graphql_providers.g.dart';

/// Parser respons GraphQL yang toleran terhadap error tanpa field `message`.
///
/// `ResponseParser` bawaan `gql_link` melakukan `error["message"] as String`
/// (lihat `gql_link/src/response_parser.dart`) sehingga respons error yang
/// tidak menyertakan `message` melempar `ResponseFormatException` dan menutupi
/// pesan asli dari server. Parser ini menggantinya dengan pesan fallback agar
/// error tetap bisa dibaca dan dicatat.
class _LenientResponseParser extends ResponseParser {
  const _LenientResponseParser();

  @override
  GraphQLError parseError(Map<String, dynamic> error) => GraphQLError(
    message: (error['message'] as String?) ?? 'GraphQL error tanpa pesan',
    path: error['path'] as List?,
    locations: (error['locations'] as List?)
        ?.whereType<Map<String, dynamic>>()
        .map(parseLocation)
        .toList(),
    extensions: error['extensions'] as Map<String, dynamic>?,
  );

  @override
  ErrorLocation parseLocation(Map<String, dynamic> location) => ErrorLocation(
    line: (location['line'] as int?) ?? 0,
    column: (location['column'] as int?) ?? 0,
  );
}

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
        _log.error(
          '$opName gagal: ${errors.first.message}',
          tag: 'GraphQL',
          extras: errors.first.extensions == null
              ? null
              : {'extensions': errors.first.extensions},
        );
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
    parser: const _LenientResponseParser(),
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
