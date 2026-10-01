import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql/client.dart';

import 'package:dompetqu/core/theme/app_theme.dart';
import 'package:dompetqu/features/home/application/contacts_controller.dart';
import 'package:dompetqu/features/home/contacts/contacts_screen.dart';
import 'package:dompetqu/features/home/data/contacts_remote_source.dart';
import 'package:dompetqu/features/home/models/contact.dart';
import 'package:dompetqu/features/home/models/contact_page.dart';

/// Sumber dengan dua halaman: halaman 1 (ada berikutnya) dan halaman 2 (habis).
class TwoPageSource extends ContactsRemoteSource {
  TwoPageSource()
      : super(GraphQLClient(
          link: HttpLink('http://localhost:9999'),
          cache: GraphQLCache(store: InMemoryStore()),
        ));

  static final page1 = ContactPage(
    edges: const [
      ContactEdge(cursor: 'cur-2', node: Contact(id: 'c2', name: 'Budi')),
      ContactEdge(cursor: 'cur-1', node: Contact(id: 'c1', name: 'Citra')),
    ],
    pageInfo: const ContactPageInfo(
      hasNextPage: true,
      hasPreviousPage: false,
      startCursor: 'cur-2',
      endCursor: 'cur-1',
    ),
  );

  static final page2 = ContactPage(
    edges: const [
      ContactEdge(cursor: 'cur-0', node: Contact(id: 'c0', name: 'Andi')),
    ],
    pageInfo: const ContactPageInfo(
      hasNextPage: false,
      hasPreviousPage: true,
      startCursor: 'cur-0',
      endCursor: 'cur-0',
    ),
  );

  /// Halaman yang diminta (`null` = halaman pertama).
  final List<ContactPage?> requested = [];

  @override
  Future<List<Contact>> contacts() async => page1.items;

  @override
  Future<ContactPage> contactsPage({
    int? first,
    String? after,
    int? last,
    String? before,
  }) async {
    requested.add(after == null ? null : page2);
    return after == null ? page1 : page2;
  }
}

void main() {
  testWidgets('list kontak dimuat per halaman lalu dilanjutkan', (tester) async {
    final source = TwoPageSource();
    final container = ProviderContainer(
      overrides: [contactsRemoteSourceProvider.overrideWithValue(source)],
    );
    addTearDown(container.dispose);

    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: AppTheme.dark,
          // `Scaffold` dipakai sebagai parent karena search field di bottom bar
          // butuh ancestor Material.
          home: const Scaffold(body: ContactsScreen()),
        ),
      ),
    );
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 16));
    }

    // Halaman pertama saja yang tampil + tombol load more.
    expect(find.text('Budi'), findsOneWidget);
    expect(find.text('Citra'), findsOneWidget);
    expect(find.text('Andi'), findsNothing);
    expect(find.text('Muat lebih banyak'), findsOneWidget);
    expect(container.read(contactsControllerProvider).hasMore, isTrue);

    await tester.tap(find.text('Muat lebih banyak'));
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 16));
    }

    // Halaman kedua append, tombol load more hilang (tidak ada halaman lagi).
    expect(find.text('Andi'), findsOneWidget);
    expect(find.text('Muat lebih banyak'), findsNothing);
    final state = container.read(contactsControllerProvider);
    expect(state.items.map((c) => c.id).toList(), ['c2', 'c1', 'c0']);
    expect(state.hasMore, isFalse);
    // `after` memakai endCursor halaman pertama.
    expect(source.requested, [null, TwoPageSource.page2]);
  });
}
