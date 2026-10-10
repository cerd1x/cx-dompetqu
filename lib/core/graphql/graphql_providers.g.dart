// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graphql_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// GraphQL client tunggal untuk seluruh app, mirip `urql_client.ts` di web.
///
/// `queryRequestTimeout` dinaikkan dari default 5s → 30s: saat startup semua
/// controller load bersamaan dan backend dev (turso/D1) bisa lambat >5s,
/// default 5s membuat query timeout lalu data tampil kosong/error.

@ProviderFor(graphQLClient)
final graphQLClientProvider = GraphQLClientProvider._();

/// GraphQL client tunggal untuk seluruh app, mirip `urql_client.ts` di web.
///
/// `queryRequestTimeout` dinaikkan dari default 5s → 30s: saat startup semua
/// controller load bersamaan dan backend dev (turso/D1) bisa lambat >5s,
/// default 5s membuat query timeout lalu data tampil kosong/error.

final class GraphQLClientProvider
    extends $FunctionalProvider<GraphQLClient, GraphQLClient, GraphQLClient>
    with $Provider<GraphQLClient> {
  /// GraphQL client tunggal untuk seluruh app, mirip `urql_client.ts` di web.
  ///
  /// `queryRequestTimeout` dinaikkan dari default 5s → 30s: saat startup semua
  /// controller load bersamaan dan backend dev (turso/D1) bisa lambat >5s,
  /// default 5s membuat query timeout lalu data tampil kosong/error.
  GraphQLClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'graphQLClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$graphQLClientHash();

  @$internal
  @override
  $ProviderElement<GraphQLClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GraphQLClient create(Ref ref) {
    return graphQLClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GraphQLClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GraphQLClient>(value),
    );
  }
}

String _$graphQLClientHash() => r'ff00e2c767b3ba5463d797bf90c5e58a3d95ffb2';
