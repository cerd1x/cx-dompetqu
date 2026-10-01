import 'package:graphql/client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/graphql/graphql_providers.dart';
import '../models/product.dart';
import 'gql_result.dart';

part 'inventory_remote_source.g.dart';

/// Remote source GraphQL untuk modul products/inventory — padanan `sources/inventory_source.ts`.
class InventoryRemoteSource {
  InventoryRemoteSource(this._client);

  final GraphQLClient _client;

  static const _productsQuery = r'''
    query Products {
      products {
        id name description price capital margin currency stock trackStock createdAt updatedAt
      }
    }
  ''';

  static const _createMutation = r'''
    mutation CreateProduct($input: CreateProductInput!) {
      createProduct(input: $input) {
        id name description price capital margin currency stock trackStock createdAt updatedAt
      }
    }
  ''';

  static const _updateMutation = r'''
    mutation UpdateProduct($id: String!, $input: UpdateProductInput!) {
      updateProduct(id: $id, input: $input) {
        id name description price capital margin currency stock trackStock createdAt updatedAt
      }
    }
  ''';

  static const _deleteMutation = r'''
    mutation DeleteProduct($id: String!) { deleteProduct(id: $id) }
  ''';

  Future<List<Product>> products() async {
    final result = await _client.query(
      QueryOptions(
        document: gql(_productsQuery),
        fetchPolicy: FetchPolicy.noCache,
      ),
    );
    final list = result.data?['products'];
    if (list == null) {
      throw StateError(
        gqlErrorMessage(result, fallback: 'Gagal memuat inventori'),
      );
    }
    return (list as List<dynamic>)
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Product> create({
    required String name,
    String? description,
    required num price,
    num? capital,
    int stock = 0,
    bool trackStock = false,
  }) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(_createMutation),
        variables: {
          'input': {
            'name': name,
            'description': description,
            'price': price.toDouble(),
            'capital': capital?.toDouble(),
            'stock': stock,
            'trackStock': trackStock,
          },
        },
      ),
    );
    final json = result.data?['createProduct'];
    if (json == null) {
      throw StateError(
        gqlErrorMessage(result, fallback: 'Gagal menambah produk'),
      );
    }
    return Product.fromJson(json as Map<String, dynamic>);
  }

  Future<Product> update(
    String id, {
    String? name,
    String? description,
    num? price,
    num? capital,
    int? stock,
    bool? trackStock,
  }) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(_updateMutation),
        variables: {
          'id': id,
          'input': {
            'name': name,
            'description': description,
            'price': price?.toDouble(),
            'capital': capital?.toDouble(),
            'stock': stock,
            'trackStock': trackStock,
          },
        },
      ),
    );
    final json = result.data?['updateProduct'];
    if (json == null) {
      throw StateError(
        gqlErrorMessage(result, fallback: 'Gagal memperbarui produk'),
      );
    }
    return Product.fromJson(json as Map<String, dynamic>);
  }

  Future<bool> delete(String id) async {
    final result = await _client.mutate(
      MutationOptions(document: gql(_deleteMutation), variables: {'id': id}),
    );
    if (result.hasException) {
      throw StateError(
        gqlErrorMessage(result, fallback: 'Gagal menghapus produk'),
      );
    }
    return result.data?['deleteProduct'] as bool? ?? false;
  }
}

@Riverpod(keepAlive: true)
InventoryRemoteSource inventoryRemoteSource(Ref ref) =>
    InventoryRemoteSource(ref.watch(graphQLClientProvider));
