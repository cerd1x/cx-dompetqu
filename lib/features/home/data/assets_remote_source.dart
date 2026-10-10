import 'package:graphql/client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/graphql/graphql_providers.dart';
import '../models/asset.dart';
import '../models/asset_mutation.dart';
import 'gql_result.dart';

part 'assets_remote_source.g.dart';

/// Remote source GraphQL untuk modul assets — padanan `sources/assets_source.ts`.
class AssetsRemoteSource {
  AssetsRemoteSource(this._client);

  final GraphQLClient _client;

  static const _assetsQuery = r'''
    query Assets { assets { id name type balance } }
  ''';

  static const _createMutation = r'''
    mutation CreateAsset($input: CreateAssetInput!) {
      createAsset(input: $input) { id name type balance }
    }
  ''';

  static const _updateMutation = r'''
    mutation UpdateAsset($id: ID!, $input: AssetInputUpdate!) {
      updateAsset(id: $id, input: $input) { id name type balance }
    }
  ''';

  static const _deleteMutation = r'''
    mutation DeleteAsset($name: String!) { deleteAsset(name: $name) }
  ''';

  static const _addBalanceMutation = r'''
    mutation AddBalance($assetId: ID!, $amount: String!) {
      addBalance(assetId: $assetId, amount: $amount) { id name type balance }
    }
  ''';

  static const _swapBalanceMutation = r'''
    mutation SwapBalance($fromAssetId: ID!, $toAssetId: ID!, $amount: String!) {
      swapBalance(fromAssetId: $fromAssetId, toAssetId: $toAssetId, amount: $amount) {
        from { id name type balance }
        to { id name type balance }
      }
    }
  ''';

  static const _assetMutationsQuery = r'''
    query AssetMutations($assetId: ID!) {
      assetMutations(assetId: $assetId) {
        id
        type
        amount
        currency
        balanceBefore
        balanceAfter
        description
        createdAt
      }
    }
  ''';

  Future<List<Asset>> assets() async {
    final result = await _client.query(
      QueryOptions(
        document: gql(_assetsQuery),
        fetchPolicy: FetchPolicy.noCache,
      ),
    );
    final list = result.data?['assets'];
    if (list == null) {
      throw StateError(gqlErrorMessage(result, fallback: 'Gagal memuat aset'));
    }
    return (list as List<dynamic>)
        .map((e) => Asset.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Asset> create({
    required String name,
    required String type,
    required String balance,
  }) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(_createMutation),
        variables: {
          'input': {'name': name, 'type': type, 'balance': balance},
        },
      ),
    );
    final json = result.data?['createAsset'];
    if (json == null) {
      throw StateError(
        gqlErrorMessage(result, fallback: 'Gagal menambah aset'),
      );
    }
    return Asset.fromJson(json as Map<String, dynamic>);
  }

  Future<Asset> update(
    String id, {
    String? name,
    String? type,
    String? balance,
  }) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(_updateMutation),
        variables: {
          'id': id,
          'input': {'name': name, 'type': type, 'balance': balance},
        },
      ),
    );
    final json = result.data?['updateAsset'];
    if (json == null) {
      throw StateError(
        gqlErrorMessage(result, fallback: 'Gagal memperbarui aset'),
      );
    }
    return Asset.fromJson(json as Map<String, dynamic>);
  }

  Future<bool> delete(String name) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(_deleteMutation),
        variables: {'name': name},
      ),
    );
    if (result.hasException) {
      throw StateError(
        gqlErrorMessage(result, fallback: 'Gagal menghapus aset'),
      );
    }
    return result.data?['deleteAsset'] as bool? ?? false;
  }

  Future<Asset> addBalance(String assetId, String amount) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(_addBalanceMutation),
        variables: {'assetId': assetId, 'amount': amount},
      ),
    );
    final json = result.data?['addBalance'];
    if (json == null) {
      throw StateError(
        gqlErrorMessage(result, fallback: 'Gagal menambah saldo'),
      );
    }
    return Asset.fromJson(json as Map<String, dynamic>);
  }

  Future<({Asset from, Asset to})> swapBalance(
    String fromAssetId,
    String toAssetId,
    String amount,
  ) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(_swapBalanceMutation),
        variables: {
          'fromAssetId': fromAssetId,
          'toAssetId': toAssetId,
          'amount': amount,
        },
      ),
    );
    final data = result.data?['swapBalance'];
    if (data == null) {
      throw StateError(gqlErrorMessage(result, fallback: 'Gagal swap saldo'));
    }
    final map = data as Map<String, dynamic>;
    return (
      from: Asset.fromJson(map['from'] as Map<String, dynamic>),
      to: Asset.fromJson(map['to'] as Map<String, dynamic>),
    );
  }

  Future<List<AssetMutation>> assetMutations(String assetId) async {
    final result = await _client.query(
      QueryOptions(
        document: gql(_assetMutationsQuery),
        variables: {'assetId': assetId},
        fetchPolicy: FetchPolicy.noCache,
      ),
    );
    final list = result.data?['assetMutations'];
    if (list == null) return [];
    return (list as List<dynamic>)
        .map((e) => AssetMutation.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

@Riverpod(keepAlive: true)
AssetsRemoteSource assetsRemoteSource(Ref ref) =>
    AssetsRemoteSource(ref.watch(graphQLClientProvider));
