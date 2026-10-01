import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql/client.dart';

import 'package:dompetqu/features/home/application/contacts_controller.dart';
import 'package:dompetqu/features/home/data/contacts_remote_source.dart';
import 'package:dompetqu/features/home/models/contact.dart';
import 'package:dompetqu/features/home/models/contact_page.dart';

/// Response `contactConnection` sesuai bentuk di `contact.gql`.
Map<String, dynamic> _connection({
  required List<Map<String, dynamic>> edges,
  bool hasNextPage = false,
  bool hasPreviousPage = false,
  String? startCursor,
  String? endCursor,
}) =>
    {
      'edges': edges,
      'pageInfo': {
        'hasNextPage': hasNextPage,
        'hasPreviousPage': hasPreviousPage,
        'startCursor': startCursor,
        'endCursor': endCursor,
      },
    };

Map<String, dynamic> _edge(String cursor, String id, String name) => {
      'cursor': cursor,
      'node': {
        'id': id,
        'name': name,
        'email': null,
        'phone': null,
        'phones': <String>[],
        'group': null,
        'avatar': null,
        'createdAt': null,
        'updatedAt': null,
      },
    };

/// Client yang merekam request dan selalu mengembalikan [connection] sebagai
/// hasil query `contactConnection`.
({GraphQLClient client, List<Request> requests}) _recordingClient(
  Map<String, dynamic> connection,
) {
  final requests = <Request>[];
  final link = Link.function((request, [forward]) {
    requests.add(request);
    return Stream.value(
      Response(data: {'contactConnection': connection}, response: const {}),
    );
  });
  return (
    client: GraphQLClient(
      link: link,
      cache: GraphQLCache(store: InMemoryStore()),
    ),
    requests: requests,
  );
}

/// Sumber kontak palsu yang mengembalikan halaman berurutan dari [pages] dan
/// mencatat argumen tiap panggilan `contactsPage`.
class FakePagedContactsSource extends ContactsRemoteSource {
  FakePagedContactsSource(this.pages)
      : super(GraphQLClient(
          link: HttpLink('http://localhost:9999'),
          cache: GraphQLCache(store: InMemoryStore()),
        ));

  final List<ContactPage> pages;

  /// Argumen `contactsPage` per panggilan.
  final List<({int? first, String? after})> calls = [];

  @override
  Future<List<Contact>> contacts() async => pages.first.items;

  @override
  Future<ContactPage> contactsPage({
    int? first,
    String? after,
    int? last,
    String? before,
  }) async {
    calls.add((first: first, after: after));
    return pages[calls.length - 1 < pages.length ? calls.length - 1 : pages.length - 1];
  }
}

ContactPage _page(
  List<({String id, String name})> nodes, {
  bool hasNextPage = false,
  String? endCursor,
}) =>
    ContactPage(
      edges: [
        for (final n in nodes)
          ContactEdge(cursor: 'cur-${n.id}', node: Contact(id: n.id, name: n.name)),
      ],
      pageInfo: ContactPageInfo(
        hasNextPage: hasNextPage,
        hasPreviousPage: false,
        startCursor: nodes.isEmpty ? null : 'cur-${nodes.first.id}',
        endCursor: nodes.isEmpty ? null : (endCursor ?? 'cur-${nodes.last.id}'),
      ),
    );

void main() {
  group('ContactPage.fromJson', () {
    test('memetakan edges ke items dan cursors', () {
      final page = ContactPage.fromJson(_connection(
        edges: [
          _edge('Y3M6Mzoz', 'c3', 'Citra'),
          _edge('Y3M6Mzo0', 'c2', 'Budi'),
        ],
        hasNextPage: true,
        endCursor: 'Y3M6Mzo0',
        startCursor: 'Y3M6Mzoz',
      ));

      expect(page.items.map((c) => c.id).toList(), ['c3', 'c2']);
      expect(page.items.first.name, 'Citra');
      expect(page.cursors, ['Y3M6Mzoz', 'Y3M6Mzo0']);
      expect(page.hasNextPage, isTrue);
      expect(page.hasPreviousPage, isFalse);
      expect(page.nextCursor, 'Y3M6Mzo0');
      expect(page.previousCursor, 'Y3M6Mzoz');
      expect(page.isEmpty, isFalse);
    });

    test('halaman kosong tanpa cursor', () {
      final page = ContactPage.fromJson(_connection(edges: []));

      expect(page.items, isEmpty);
      expect(page.cursors, isEmpty);
      expect(page.hasNextPage, isFalse);
      expect(page.nextCursor, isNull);
      expect(page.isEmpty, isTrue);
    });

    test('cursor kosong pada pageInfo dianggap null', () {
      final page = ContactPage.fromJson({
        'edges': <Map<String, dynamic>>[],
        'pageInfo': {'hasNextPage': false, 'hasPreviousPage': false},
      });

      expect(page.nextCursor, isNull);
      expect(page.previousCursor, isNull);
    });

    test('menolak payload tanpa edges', () {
      expect(
        () => ContactPage.fromJson({'pageInfo': <String, dynamic>{}}),
        throwsA(isA<FormatException>()),
      );
    });

    test('menolak payload tanpa pageInfo', () {
      expect(
        () => ContactPage.fromJson({'edges': <Map<String, dynamic>>[]}),
        throwsA(isA<FormatException>()),
      );
    });

    test('menolak edge tanpa node', () {
      expect(
        () => ContactPage.fromJson(_connection(
          edges: [
            {'cursor': 'c', 'node': null},
          ],
        )),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('ContactsRemoteSource.contactsPage', () {
    test('mengirim first saja dan mengembalikan halaman', () async {
      final rec = _recordingClient(_connection(
        edges: [_edge('cur1', 'c1', 'Citra')],
        hasNextPage: true,
        endCursor: 'cur1',
      ));

      final page = await ContactsRemoteSource(rec.client).contactsPage(first: 1);

      expect(rec.requests, hasLength(1));
      // Argumen null tidak ikut dikirim sebagai key variables.
      expect(rec.requests.first.variables, {'first': 1});
      expect(page.items.single.name, 'Citra');
      expect(page.hasNextPage, isTrue);
      expect(page.nextCursor, 'cur1');
    });

    test('mengirim after untuk halaman berikutnya', () async {
      final rec = _recordingClient(_connection(edges: []));

      await ContactsRemoteSource(rec.client).contactsPage(
        first: 20,
        after: 'cur1',
      );

      expect(rec.requests.first.variables, {'first': 20, 'after': 'cur1'});
    });

    test('mengirim last/before untuk navigasi mundur', () async {
      final rec = _recordingClient(_connection(edges: []));

      await ContactsRemoteSource(rec.client).contactsPage(
        last: 5,
        before: 'cur9',
      );

      expect(rec.requests.first.variables, {'last': 5, 'before': 'cur9'});
    });

    test('tanpa argumen tidak mengirim variables', () async {
      final rec = _recordingClient(_connection(edges: []));

      await ContactsRemoteSource(rec.client).contactsPage();

      expect(rec.requests.first.variables, isEmpty);
    });

    test('melempar StateError dengan pesan GraphQL saat data null', () async {
      final client = GraphQLClient(
        link: Link.function(
          (request, [forward]) => Stream.value(Response(
            data: null,
            response: const {},
            errors: [
              GraphQLError(message: 'Cannot combine first with last'),
            ],
          )),
        ),
        cache: GraphQLCache(store: InMemoryStore()),
      );

      await expectLater(
        ContactsRemoteSource(client).contactsPage(first: 5, last: 5),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            contains('Cannot combine first with last'),
          ),
        ),
      );
    });
  });

  group('ContactsController pagination', () {
    /// Container dengan sumber palsu; load awal dari `build()` sudah selesai.
    Future<ProviderContainer> containerWith(FakePagedContactsSource source) async {
      final container = ProviderContainer(
        overrides: [contactsRemoteSourceProvider.overrideWithValue(source)],
      );
      addTearDown(container.dispose);
      // `build()` menunda `load()` ke microtask — biarkan selesai dulu agar
      // tidak menimpa state yang diuji.
      await Future<void>.delayed(const Duration(milliseconds: 10));
      return container;
    }

    test('loadPage mengisi items dan cursor halaman berikutnya', () async {
      final source = FakePagedContactsSource([
        _page([
          (id: 'c3', name: 'Citra'),
          (id: 'c2', name: 'Budi'),
        ], hasNextPage: true, endCursor: 'cur-c2'),
      ]);
      final container = await containerWith(source);

      await container
          .read(contactsControllerProvider.notifier)
          .loadPage(pageSize: 2);

      final state = container.read(contactsControllerProvider);
      expect(state.items.map((c) => c.id).toList(), ['c3', 'c2']);
      expect(state.hasMore, isTrue);
      expect(state.nextCursor, 'cur-c2');
      expect(state.loading, isFalse);
      expect(state.loadingMore, isFalse);
      expect(source.calls.single, (first: 2, after: null));
    });

    test('loadMore append halaman berikutnya dan maju cursor', () async {
      final source = FakePagedContactsSource([
        _page([
          (id: 'c3', name: 'Citra'),
          (id: 'c2', name: 'Budi'),
        ], hasNextPage: true, endCursor: 'cur-c2'),
        _page([(id: 'c1', name: 'Andi')]),
      ]);
      final container = await containerWith(source);
      final controller = container.read(contactsControllerProvider.notifier);

      await controller.loadPage(pageSize: 2);
      final loaded = await controller.loadMore();

      final state = container.read(contactsControllerProvider);
      expect(loaded, isTrue);
      expect(state.items.map((c) => c.id).toList(), ['c3', 'c2', 'c1']);
      expect(state.hasMore, isFalse);
      expect(state.nextCursor, isNull);
      expect(state.loadingMore, isFalse);
      // Cursor halaman sebelumnya diteruskan apa adanya.
      expect(source.calls.last, (first: 2, after: 'cur-c2'));
    });

    test('loadMore no-op saat tidak ada halaman berikutnya', () async {
      final source = FakePagedContactsSource([
        _page([(id: 'c1', name: 'Andi')]),
      ]);
      final container = await containerWith(source);
      final controller = container.read(contactsControllerProvider.notifier);

      await controller.loadPage(pageSize: 2);
      final loaded = await controller.loadMore();

      expect(loaded, isFalse);
      expect(source.calls, hasLength(1));
      expect(container.read(contactsControllerProvider).items, hasLength(1));
    });

    test('loadMore mengabaikan kontak duplikat antar halaman', () async {
      final source = FakePagedContactsSource([
        _page([
          (id: 'c2', name: 'Budi'),
          (id: 'c1', name: 'Andi'),
        ], hasNextPage: true, endCursor: 'cur-c1'),
        // c1 terulang di halaman kedua (mis. insert baru di server).
        _page([
          (id: 'c1', name: 'Andi'),
          (id: 'c0', name: 'Zaki'),
        ]),
      ]);
      final container = await containerWith(source);
      final controller = container.read(contactsControllerProvider.notifier);

      await controller.loadPage(pageSize: 2);
      await controller.loadMore();

      expect(
        container.read(contactsControllerProvider).items.map((c) => c.id),
        ['c2', 'c1', 'c0'],
      );
    });

    test('load() di mode pagination memuat ulang halaman pertama', () async {
      final source = FakePagedContactsSource([
        _page([(id: 'c1', name: 'Andi')], hasNextPage: true, endCursor: 'cur-c1'),
        _page([(id: 'c0', name: 'Zaki')]),
      ]);
      final container = await containerWith(source);
      final controller = container.read(contactsControllerProvider.notifier);

      await controller.loadPage(pageSize: 2);
      await controller.load();

      final state = container.read(contactsControllerProvider);
      // `load()` mengikuti mode aktif: halaman pertama, bukan daftar penuh.
      expect(state.items.map((c) => c.id).toList(), ['c0']);
      expect(state.hasMore, isFalse);
      expect(source.calls.map((c) => c.after), [null, null]);
    });

    test('loadAll() memuat daftar penuh dan mematikan state pagination', () async {
      final source = FakePagedContactsSource([
        _page([(id: 'c1', name: 'Andi')], hasNextPage: true, endCursor: 'cur-c1'),
      ]);
      final container = await containerWith(source);
      final controller = container.read(contactsControllerProvider.notifier);

      await controller.loadPage(pageSize: 2);
      await controller.loadAll();

      final state = container.read(contactsControllerProvider);
      expect(controller.isPaged, isFalse);
      expect(state.items, hasLength(1));
      expect(state.hasMore, isFalse);
      expect(state.nextCursor, isNull);
    });

    test('ensureAllLoaded() hanya memuat penuh saat mode pagination', () async {
      final source = FakePagedContactsSource([
        _page([(id: 'c1', name: 'Andi')], hasNextPage: true, endCursor: 'cur-c1'),
      ]);
      final container = await containerWith(source);
      final controller = container.read(contactsControllerProvider.notifier);

      await controller.loadPage(pageSize: 2);
      expect(source.calls, hasLength(1));

      await controller.ensureAllLoaded();
      expect(source.calls, hasLength(1));
      expect(container.read(contactsControllerProvider).hasMore, isFalse);

      // Panggil kedua no-op: sudah dimuat penuh.
      await controller.ensureAllLoaded();
      expect(source.calls, hasLength(1));
    });
  });
}
