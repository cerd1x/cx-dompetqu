import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql/client.dart';

import 'package:dompetqu/core/theme/app_theme.dart';
import 'package:dompetqu/core/theme/widgets/round_action_button.dart';
import 'package:dompetqu/features/home/contacts/contacts_screen.dart';
import 'package:dompetqu/features/home/contacts/contact_detail_screen.dart';
import 'package:dompetqu/features/home/data/contacts_remote_source.dart';
import 'package:dompetqu/features/home/models/contact.dart';
import 'package:dompetqu/features/home/widgets/bottom_bar.dart';

GraphQLClient _dummyClient() => GraphQLClient(
      link: HttpLink('http://localhost:9999'),
      cache: GraphQLCache(store: InMemoryStore()),
    );

class FakeContactsRemoteSource extends ContactsRemoteSource {
  FakeContactsRemoteSource() : super(_dummyClient());

  @override
  Future<List<Contact>> contacts() async => [
    Contact(
      id: 'c1',
      name: 'Budi',
      phones: ['0812-3456'],
      email: 'budi@mail.com',
      group: 'Keluarga',
      createdAt: DateTime(2025, 1, 15),
    ),
  ];
}

void main() {
  testWidgets('tap contact item -> detail body renders', (tester) async {
    final container = ProviderContainer(
      overrides: [
        contactsRemoteSourceProvider.overrideWithValue(
          FakeContactsRemoteSource(),
        ),
      ],
    );
    addTearDown(container.dispose);

    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    final router = GoRouter(
      initialLocation: '/contacts',
      routes: [
        GoRoute(path: '/contacts', builder: (_, _) => const ContactsScreen()),
        GoRoute(
          path: '/contact-detail/:id',
          builder: (_, s) => ContactDetailScreen(
            contactId: s.pathParameters['id'] ?? '',
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          theme: AppTheme.dark,
          routerConfig: router,
        ),
      ),
    );

    // Tunggu kontak dimuat lalu tampil di list.
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 16));
    }
    expect(find.text('Budi'), findsOneWidget);

    await tester.tap(find.text('Budi'));
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 16));
    }

    expect(tester.takeException(), isNull);
    expect(router.state.uri.path, '/contact-detail/c1');
    expect(find.text('0812-3456'), findsOneWidget);
    final detail = find.byType(ContactDetailScreen);
    expect(detail, findsOneWidget);
    expect(
      find.descendant(of: detail, matching: find.byType(TabBottomBar)),
      findsOneWidget,
    );
    expect(
      find.descendant(of: detail, matching: find.byTooltip('Edit')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: detail, matching: find.byTooltip('Merge')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: detail, matching: find.byTooltip('Delete')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: detail, matching: find.byTooltip('Back')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: detail, matching: find.byType(RoundActionButton)),
      findsNWidgets(4),
    );

    // Dump widget tree bila body tidak ditemukan (diagnosa).
    if (find.text('0812-3456').evaluate().isEmpty) {
      debugPrint(tester.allWidgets.join('\n'));
    }

    expect(find.text('0812-3456'), findsOneWidget);
  });
}