import 'package:graphql/client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/graphql/graphql_providers.dart';
import '../models/contact.dart';
import '../models/contact_page.dart';
import 'gql_result.dart';

part 'contacts_remote_source.g.dart';

/// Remote source GraphQL untuk modul contacts — padanan `sources/contacts_source.ts`.
class ContactsRemoteSource {
  ContactsRemoteSource(this._client);

  final GraphQLClient _client;

  static const _contactsQuery = r'''
    query Contacts {
      contacts { id name email phone phones group avatar createdAt updatedAt }
    }
  ''';

  static const _contactsPageQuery = r'''
    query ContactsPage($first: Int, $after: String, $last: Int, $before: String) {
      contactConnection(first: $first, after: $after, last: $last, before: $before) {
        edges { cursor node { id name email phone phones group avatar createdAt updatedAt } }
        pageInfo { hasNextPage hasPreviousPage startCursor endCursor }
      }
    }
  ''';

  static const _createMutation = r'''
    mutation CreateContact($input: CreateContactInput!) {
      createContact(input: $input) { id name email phone phones group }
    }
  ''';

  static const _updateMutation = r'''
    mutation UpdateContact($id: String!, $input: UpdateContactInput!) {
      updateContact(id: $id, input: $input) { id name email phone phones group }
    }
  ''';

  static const _deleteMutation = r'''
    mutation DeleteContact($id: String!) { deleteContact(id: $id) }
  ''';

  Future<List<Contact>> contacts() async {
    final result = await _client.query(
      QueryOptions(
        document: gql(_contactsQuery),
        fetchPolicy: FetchPolicy.noCache,
      ),
    );
    final list = result.data?['contacts'];
    if (list == null) {
      throw StateError(
        gqlErrorMessage(result, fallback: 'Gagal memuat kontak'),
      );
    }
    return (list as List<dynamic>)
        .map((e) => Contact.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Halaman kontak dengan keyset pagination — padanan `contactsPage()` di
  /// `services/domain/contacts/contacts.composition.ts`.
  ///
  /// Navigasi maju: [first] + [after]. Navigasi mundur: [last] + [before].
  /// [first] dan [last] tidak boleh dipakai bersamaan — server menolak dengan
  /// `"Cannot combine 'first' with 'last'"`. Tanpa argumen apa pun server memakai
  /// `DEFAULT_PAGE_SIZE` (20) dan mengembalikan halaman paling awal.
  ///
  /// [after]/[before] harus berupa cursor opaque dari
  /// [ContactPage.nextCursor]/[ContactPage.previousCursor] halaman sebelumnya.
  Future<ContactPage> contactsPage({
    int? first,
    String? after,
    int? last,
    String? before,
  }) async {
    final result = await _client.query(
      QueryOptions(
        document: gql(_contactsPageQuery),
        // Hanya kirim variabel yang diisi: argumen `null` berarti "tidak ada".
        variables: {
          'first': ?first,
          'after': ?after,
          'last': ?last,
          'before': ?before,
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    );
    final connection = result.data?['contactConnection'];
    if (connection == null) {
      throw StateError(
        gqlErrorMessage(result, fallback: 'Gagal memuat halaman kontak'),
      );
    }
    return ContactPage.fromJson(connection as Map<String, dynamic>);
  }

  Future<Contact> create({
    required String name,
    String? email,
    String? phone,
    List<String>? phones,
    String? group,
  }) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(_createMutation),
        variables: {
          'input': {
            'name': name,
            'email': email,
            'phone': phone,
            'phones': phones,
            'group': group,
          },
        },
      ),
    );
    final json = result.data?['createContact'];
    if (json == null) {
      throw StateError(
        gqlErrorMessage(result, fallback: 'Gagal menambah kontak'),
      );
    }
    return Contact.fromJson(json as Map<String, dynamic>);
  }

  Future<Contact> update(
    String id, {
    String? name,
    String? email,
    String? phone,
    List<String>? phones,
  }) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(_updateMutation),
        variables: {
          'id': id,
          'input': {'name': name, 'email': email, 'phone': phone, 'phones': phones},
        },
      ),
    );
    final json = result.data?['updateContact'];
    if (json == null) {
      throw StateError(
        gqlErrorMessage(result, fallback: 'Gagal memperbarui kontak'),
      );
    }
    return Contact.fromJson(json as Map<String, dynamic>);
  }

  Future<bool> delete(String id) async {
    final result = await _client.mutate(
      MutationOptions(document: gql(_deleteMutation), variables: {'id': id}),
    );
    if (result.hasException) {
      throw StateError(
        gqlErrorMessage(result, fallback: 'Gagal menghapus kontak'),
      );
    }
    return result.data?['deleteContact'] as bool? ?? false;
  }
}

@Riverpod(keepAlive: true)
ContactsRemoteSource contactsRemoteSource(Ref ref) =>
    ContactsRemoteSource(ref.watch(graphQLClientProvider));
