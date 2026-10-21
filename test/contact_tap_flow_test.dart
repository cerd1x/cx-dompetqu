import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:dompetqu/core/theme/app_theme.dart';
import 'package:dompetqu/core/theme/widgets/round_action_button.dart';
import 'package:dompetqu/features/contacts/presentation/contacts_screen.dart';
import 'package:dompetqu/features/contacts/presentation/contact_detail_screen.dart';
import 'package:dompetqu/features/dashboard/stores/home_repository_provider.dart';
import 'package:dompetqu/features/contacts/domain/entities/contact.dart';
import 'package:dompetqu/features/contacts/domain/entities/contact_page.dart';
import 'package:dompetqu/features/dashboard/domain/repositories/home_repository.dart';
import 'package:dompetqu/core/theme/widgets/bottom_bar.dart';

class FakeContactsRepository implements HomeRepository {
  final _contact = Contact(
    id: 'c1',
    name: 'Budi',
    phones: ['0812-3456'],
    email: 'budi@mail.com',
    group: 'Keluarga',
    createdAt: DateTime(2025, 1, 15),
  );

  @override
  Future<List<Contact>> contacts() async => [_contact];

  @override
  Future<ContactPage> contactsPage({
    int? first,
    String? after,
    int? last,
    String? before,
  }) async =>
      ContactPage(items: [_contact], hasNextPage: false, nextCursor: null);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets('tap contact item -> detail body renders', (tester) async {
    final container = ProviderContainer.test(
      overrides: [
        homeRepositoryProvider.overrideWithValue(FakeContactsRepository()),
      ],
    );

    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    final router = GoRouter(
      initialLocation: '/contacts',
      routes: [
        GoRoute(
          path: '/contacts',
          builder: (_, _) => const Scaffold(body: ContactsScreen()),
        ),
        GoRoute(
          path: '/contact-detail/:id',
          builder: (_, s) =>
              ContactDetailScreen(contactId: s.pathParameters['id'] ?? ''),
        ),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(theme: AppTheme.dark, routerConfig: router),
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
    // `RoundActionButton` default memakai `Semantics` (bukan `Tooltip`) karena
    // tooltip `OverlayPortal` bermasalah di dalam `TabBottomBar` yang ber-blur.
    Finder actionButton(String label) => find.descendant(
      of: detail,
      matching: find.byWidgetPredicate(
        (widget) => widget is RoundActionButton && widget.label == label,
      ),
    );
    expect(actionButton('Edit'), findsOneWidget);
    expect(actionButton('Merge'), findsOneWidget);
    expect(actionButton('Delete'), findsOneWidget);
    expect(actionButton('Back'), findsOneWidget);
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
