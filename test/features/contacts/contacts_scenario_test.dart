import 'package:flutter_test/flutter_test.dart';

import 'package:cx_dompetqiu/features/contacts/adapters/models/contact.dart'
    as data;
import 'package:cx_dompetqiu/features/contacts/adapters/models/contact_page.dart'
    as data;
import 'package:cx_dompetqiu/features/contacts/domain/models/contact.dart';
import 'package:cx_dompetqiu/features/contacts/view/stores/contacts_store.dart';

void main() {
  group('Skenario pencarian kontak', () {
    const items = [
      Contact(id: '1', name: 'Budi Santoso', phone: '08123456789'),
      Contact(id: '2', name: 'Siti Aminah', email: 'siti@example.com'),
      Contact(id: '3', name: 'Andi Wijaya'),
    ];

    test('query kosong mengembalikan semua kontak', () {
      expect(const ContactsState(items: items).filtered, items);
    });

    test('mencocokkan nama tanpa peduli kapitalisasi & spasi', () {
      final state = const ContactsState(items: items, searchQuery: '  budi ');

      expect(state.filtered.map((c) => c.id), ['1']);
    });

    test('mencocokkan nomor telepon', () {
      final state = const ContactsState(items: items, searchQuery: '0812');

      expect(state.filtered.map((c) => c.id), ['1']);
    });

    test('mencocokkan email', () {
      final state = const ContactsState(items: items, searchQuery: 'SITI@');

      expect(state.filtered.map((c) => c.id), ['2']);
    });

    test('query tanpa hasil mengembalikan list kosong', () {
      expect(
        const ContactsState(items: items, searchQuery: 'tidak-ada').filtered,
        isEmpty,
      );
    });
  });

  group('Skenario copyWith state kontak', () {
    test('error bisa di-set lalu dihapus menjadi null', () {
      const initial = ContactsState(error: 'gagal');

      expect(initial.copyWith(error: null).error, isNull);
      expect(initial.copyWith(loading: false).error, 'gagal');
    });

    test('nextCursor bisa di-set lalu dikosongkan', () {
      const initial = ContactsState(nextCursor: 'cursor-1', hasMore: true);

      final reset = initial.copyWith(nextCursor: null, hasMore: false);

      expect(reset.nextCursor, isNull);
      expect(reset.hasMore, isFalse);
      expect(initial.nextCursor, 'cursor-1');
    });

    test('nilai default state', () {
      const state = ContactsState();

      expect(state.pageSize, kContactsPageSize);
      expect(state.loading, isTrue);
      expect(state.items, isEmpty);
      expect(state.hasMore, isFalse);
      expect(state.loadingMore, isFalse);
    });
  });

  group('Skenario parsing kontak', () {
    test('Contact.fromJson mengubah id numerik dan tanggal ISO', () {
      final contact = data.Contact.fromJson({
        'id': 7,
        'name': 'Budi',
        'email': 'budi@example.com',
        'phone': '0812',
        'phones': ['0812', '0813'],
        'group': 'Keluarga',
        'createdAt': '2026-01-02T03:04:05.000Z',
      });

      expect(contact.id, '7');
      expect(contact.phones, ['0812', '0813']);
      expect(contact.createdAt, DateTime.utc(2026, 1, 2, 3, 4, 5));
      expect(contact.updatedAt, isNull);
    });

    test('ContactPage.fromJson memetakan edges, cursor, dan pageInfo', () {
      final page = data.ContactPage.fromJson({
        'edges': [
          {
            'cursor': 'c1',
            'node': {'id': '1', 'name': 'Budi'},
          },
          {
            'cursor': 'c2',
            'node': {'id': '2', 'name': 'Siti'},
          },
        ],
        'pageInfo': {
          'hasNextPage': true,
          'hasPreviousPage': false,
          'startCursor': 'c1',
          'endCursor': 'c2',
        },
      });

      expect(page.items.map((c) => c.id), ['1', '2']);
      expect(page.cursors, ['c1', 'c2']);
      expect(page.hasNextPage, isTrue);
      expect(page.hasPreviousPage, isFalse);
      expect(page.nextCursor, 'c2');
      expect(page.previousCursor, 'c1');
      expect(page.isEmpty, isFalse);
    });

    test('ContactPage.empty tidak punya halaman berikutnya', () {
      const page = data.ContactPage.empty();

      expect(page.isEmpty, isTrue);
      expect(page.hasNextPage, isFalse);
      expect(page.nextCursor, isNull);
    });

    test('edges bukan list melempar FormatException', () {
      expect(
        () => data.ContactPage.fromJson({'edges': 'bukan-list'}),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            contains('edges'),
          ),
        ),
      );
    });

    test('pageInfo hilang melempar FormatException', () {
      expect(
        () => data.ContactPage.fromJson({'edges': []}),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            contains('pageInfo'),
          ),
        ),
      );
    });

    test('edge tanpa node melempar FormatException', () {
      expect(
        () => data.ContactEdge.fromJson({'cursor': 'c1'}),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('Skenario grup duplikat', () {
    test('alasan grup nomor & nama dapat dibaca pengguna', () {
      final byPhone = ContactDuplicateGroup(
        type: DuplicateGroupType.phone,
        key: '0812',
        contacts: const [],
      );
      final byName = ContactDuplicateGroup(
        type: DuplicateGroupType.name,
        key: 'Budi',
        contacts: const [],
      );

      expect(byPhone.reason, 'Nomor sama: 0812');
      expect(byName.reason, 'Nama sama: "Budi"');
    });
  });
}
