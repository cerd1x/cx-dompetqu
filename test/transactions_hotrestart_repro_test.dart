import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql/client.dart';

import 'package:dompetqu/features/home/application/transactions_controller.dart';
import 'package:dompetqu/features/home/data/transactions_remote_source.dart';
import 'package:dompetqu/features/home/models/transaction.dart';

GraphQLClient _dummyClient() => GraphQLClient(
      link: HttpLink('http://localhost:9999'),
      cache: GraphQLCache(store: InMemoryStore()),
    );

Transaction _tx() => Transaction(
      id: 't1',
      type: 'income',
      amount: 'IDR 10000',
      category: 'Gaji',
      createdAt: DateTime(2026, 1, 1),
    );

class FakeTxRemoteSource extends TransactionsRemoteSource {
  FakeTxRemoteSource() : super(_dummyClient());

  int calls = 0;

  @override
  Future<List<Transaction>> transactions() async {
    calls++;
    await Future<void>.delayed(const Duration(milliseconds: 50));
    return [_tx()];
  }
}

ProviderContainer _freshContainer(TransactionsRemoteSource source) {
  return ProviderContainer(
    overrides: [
      transactionsRemoteSourceProvider.overrideWithValue(source),
    ],
  );
}

void main() {
  test('cold start: provider load memuat data', () async {
    final source = FakeTxRemoteSource();
    final container = _freshContainer(source);
    addTearDown(container.dispose);

    container.listen(transactionsControllerProvider, (_, _) {});
    // buang waktu untuk microtask + fetch 50ms
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final state = container.read(transactionsControllerProvider);
    expect(state.items, hasLength(1), reason: 'data harus termuat');
    expect(state.loading, isFalse);
    expect(source.calls, 1);
  });

  test('hot-restart-like: container kedua juga harus load', () async {
    final sourceA = FakeTxRemoteSource();
    final containerA = _freshContainer(sourceA);
    containerA.listen(transactionsControllerProvider, (_, _) {});
    await Future<void>.delayed(const Duration(milliseconds: 300));
    expect(containerA.read(transactionsControllerProvider).items, hasLength(1));
    containerA.dispose();

    // Simulasi hot restart: fresh container baru (state Dart di-reset).
    final sourceB = FakeTxRemoteSource();
    final containerB = _freshContainer(sourceB);
    addTearDown(containerB.dispose);
    containerB.listen(transactionsControllerProvider, (_, _) {});
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final stateB = containerB.read(transactionsControllerProvider);
    expect(stateB.items, hasLength(1), reason: 'container baru harus termuat');
    expect(stateB.loading, isFalse);
    expect(sourceB.calls, 1);
  });

  test('query error muncul sebagai error (tidak ditelan jadi list kosong)', () async {
    final source = _ErrorTxRemoteSource();
    final container = _freshContainer(source);
    addTearDown(container.dispose);

    container.listen(transactionsControllerProvider, (_, _) {});
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final state = container.read(transactionsControllerProvider);
    expect(state.items, isEmpty);
    expect(state.error, isNotNull,
        reason: 'error GraphQL harus tampil, bukan diam-diam jadi list kosong');
  });
}

class _ErrorTxRemoteSource extends TransactionsRemoteSource {
  _ErrorTxRemoteSource() : super(_dummyClient());

  @override
  Future<List<Transaction>> transactions() async {
    // Jalur asli (super) dengan client dummy — hasilnya error (data null),
    // remote source harus melempar StateError agar controller mengisi error.
    return super.transactions();
  }
}
