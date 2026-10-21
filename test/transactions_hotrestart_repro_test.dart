import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dompetqu/features/transactions/stores/transactions_store.dart';
import 'package:dompetqu/features/dashboard/stores/home_repository_provider.dart';
import 'package:dompetqu/features/transactions/domain/entities/transaction.dart';
import 'package:dompetqu/features/dashboard/domain/repositories/home_repository.dart';

Transaction _tx() => Transaction(
  id: 't1',
  type: 'income',
  amount: 'IDR 10000',
  category: 'Gaji',
  createdAt: DateTime(2026, 1, 1),
);

class FakeTransactionsRepository implements HomeRepository {
  FakeTransactionsRepository({this.error});

  final Object? error;
  int calls = 0;

  @override
  Future<List<Transaction>> transactions() async {
    calls++;
    await Future<void>.delayed(const Duration(milliseconds: 50));
    if (error != null) throw error!;
    return [_tx()];
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('cold start: provider load memuat data', () async {
    final repository = FakeTransactionsRepository();
    final container = ProviderContainer.test(
      overrides: [homeRepositoryProvider.overrideWithValue(repository)],
    );

    container.listen(transactionsStoreProvider, (_, _) {});
    // buang waktu untuk microtask + fetch 50ms
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final state = container.read(transactionsStoreProvider);
    expect(state.items, hasLength(1), reason: 'data harus termuat');
    expect(state.loading, isFalse);
    expect(repository.calls, 1);
  });

  test('hot-restart-like: container kedua juga harus load', () async {
    final repositoryA = FakeTransactionsRepository();
    final containerA = ProviderContainer.test(
      overrides: [homeRepositoryProvider.overrideWithValue(repositoryA)],
    );
    containerA.listen(transactionsStoreProvider, (_, _) {});
    await Future<void>.delayed(const Duration(milliseconds: 300));
    expect(containerA.read(transactionsStoreProvider).items, hasLength(1));
    containerA.dispose();

    // Simulasi hot restart: fresh container baru (state Dart di-reset).
    final repositoryB = FakeTransactionsRepository();
    final containerB = ProviderContainer.test(
      overrides: [homeRepositoryProvider.overrideWithValue(repositoryB)],
    );
    containerB.listen(transactionsStoreProvider, (_, _) {});
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final stateB = containerB.read(transactionsStoreProvider);
    expect(stateB.items, hasLength(1), reason: 'container baru harus termuat');
    expect(stateB.loading, isFalse);
    expect(repositoryB.calls, 1);
  });

  test(
    'query error muncul sebagai error (tidak ditelan jadi list kosong)',
    () async {
      final repository = FakeTransactionsRepository(
        error: StateError('GraphQL query failed'),
      );
      final container = ProviderContainer.test(
        overrides: [homeRepositoryProvider.overrideWithValue(repository)],
      );

      container.listen(transactionsStoreProvider, (_, _) {});
      await Future<void>.delayed(const Duration(milliseconds: 300));

      final state = container.read(transactionsStoreProvider);
      expect(state.items, isEmpty);
      expect(
        state.error,
        isNotNull,
        reason: 'error GraphQL harus tampil, bukan diam-diam jadi list kosong',
      );
      expect(state.error, contains('GraphQL query failed'));
    },
  );
}
