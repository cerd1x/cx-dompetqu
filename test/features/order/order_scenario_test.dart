import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cx_dompetqiu/features/order/domain/models/bookkeeping_ledger.dart';
import 'package:cx_dompetqiu/features/order/domain/repositories/debt_settlements_repository.dart';
import 'package:cx_dompetqiu/features/order/view/stores/debt_settlements.dart';
import 'package:cx_dompetqiu/features/order/view/stores/debt_settlements_repository_provider.dart';

class _FakeDebtRepository implements DebtSettlementsRepository {
  _FakeDebtRepository([Set<String>? initial])
    : stored = {...?initial};

  final Set<String> stored;
  int loadCalls = 0;
  final List<Set<String>> saves = [];

  @override
  Future<Set<String>> load() async {
    loadCalls++;
    return {...stored};
  }

  @override
  Future<void> save(Set<String> transactionIds) async {
    stored
      ..clear()
      ..addAll(transactionIds);
    saves.add({...transactionIds});
  }
}

Future<void> _waitForLoad(DebtSettlements notifier) async {
  for (var i = 0; i < 50 && !notifier.isReady; i++) {
    await Future<void>.delayed(const Duration(milliseconds: 1));
  }
}

void main() {
  group('Skenario filter buku besar', () {
    test('label tiap filter', () {
      expect(
        BookkeepingFilter.values.map((f) => f.label),
        ['All', 'Income', 'Expense', 'Transfer', 'Outcome'],
      );
    });

    test('graphqlValue sama dengan nama enum', () {
      for (final filter in BookkeepingFilter.values) {
        expect(filter.graphqlValue, filter.name);
      }
    });
  });

  group('Skenario status pelunasan utang', () {
    ProviderContainer containerWith(_FakeDebtRepository repository) {
      final container = ProviderContainer(
        overrides: [
          debtSettlementsRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);
      return container;
    }

    test('memuat status tersimpan saat provider dibuat', () async {
      final repository = _FakeDebtRepository({'tx-1'});
      final container = containerWith(repository);

      final notifier = container.read(debtSettlementsProvider.notifier);
      await _waitForLoad(notifier);

      expect(repository.loadCalls, 1);
      expect(notifier.isReady, isTrue);
      expect(notifier.isSettled('tx-1'), isTrue);
      expect(notifier.statusOf('tx-1'), DebtStatus.settled);
      expect(notifier.statusOf('tx-2'), DebtStatus.outstanding);
    });

    test('markSettled menambah id dan menyimpan', () async {
      final repository = _FakeDebtRepository();
      final container = containerWith(repository);
      final notifier = container.read(debtSettlementsProvider.notifier);
      await _waitForLoad(notifier);

      await notifier.markSettled('tx-9');

      expect(notifier.isSettled('tx-9'), isTrue);
      expect(repository.stored, {'tx-9'});
      expect(repository.saves.last, {'tx-9'});
    });

    test('markSettled id yang sudah lunas tidak menyimpan ulang', () async {
      final repository = _FakeDebtRepository({'tx-1'});
      final container = containerWith(repository);
      final notifier = container.read(debtSettlementsProvider.notifier);
      await _waitForLoad(notifier);

      await notifier.markSettled('tx-1');

      expect(repository.saves, isEmpty);
    });

    test('revert menghapus id dan menyimpan', () async {
      final repository = _FakeDebtRepository({'tx-1', 'tx-2'});
      final container = containerWith(repository);
      final notifier = container.read(debtSettlementsProvider.notifier);
      await _waitForLoad(notifier);

      await notifier.revert('tx-1');

      expect(notifier.isSettled('tx-1'), isFalse);
      expect(notifier.isSettled('tx-2'), isTrue);
      expect(repository.stored, {'tx-2'});
    });

    test('revert id yang belum lunas tidak menyimpan ulang', () async {
      final repository = _FakeDebtRepository();
      final container = containerWith(repository);
      final notifier = container.read(debtSettlementsProvider.notifier);
      await _waitForLoad(notifier);

      await notifier.revert('tx-404');

      expect(repository.saves, isEmpty);
    });
  });
}
