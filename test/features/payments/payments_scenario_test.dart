import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cx_dompetqiu/features/payments/domain/models/payment.dart';
import 'package:cx_dompetqiu/features/payments/domain/repositories/payments_repository.dart';
import 'package:cx_dompetqiu/features/payments/view/stores/failed_payments_store.dart';
import 'package:cx_dompetqiu/features/payments/view/stores/payments_repository_provider.dart';

class _FakePaymentsRepository implements PaymentsRepository {
  _FakePaymentsRepository(this.payments);

  final List<Payment> payments;
  String? lastStatus;

  @override
  Future<List<Payment>> byStatus(String status) async {
    lastStatus = status;
    return payments;
  }

  @override
  Future<Payment> retry(String id) async =>
      payments.firstWhere((p) => p.id == id);
}

Payment _payment(
  String id, {
  DateTime? createdAt,
  int retryCount = 0,
  int maxRetries = 3,
  String? description,
}) => Payment(
  id: id,
  amount: 1000,
  retryCount: retryCount,
  maxRetries: maxRetries,
  description: description,
  createdAt: createdAt ?? DateTime(2026, 3, 1),
);

void main() {
  group('Skenario kebijakan retry payment', () {
    test('canRetry true selama retryCount < maxRetries', () {
      expect(_payment('p', retryCount: 0, maxRetries: 3).canRetry, isTrue);
      expect(_payment('p', retryCount: 2, maxRetries: 3).canRetry, isTrue);
    });

    test('canRetry false saat batas tercapai atau terlampaui', () {
      expect(_payment('p', retryCount: 3, maxRetries: 3).canRetry, isFalse);
      expect(_payment('p', retryCount: 4, maxRetries: 3).canRetry, isFalse);
    });

    test('displayName memakai deskripsi atau fallback id', () {
      expect(_payment('p1', description: 'Langganan').displayName, 'Langganan');
      expect(_payment('p2').displayName, 'Payment p2');
    });

    test('metadata menyimpan error gateway & delay retry', () {
      const metadata = PaymentMetadata(
        paymentType: 'general',
        assetId: 7,
        lastError: 'card declined',
        nextRetryDelayMs: 1500,
      );

      expect(metadata.lastError, 'card declined');
      expect(metadata.nextRetryDelayMs, 1500);
      expect(metadata.assetId, 7);
    });
  });

  group('Skenario daftar payment gagal per bulan', () {
    late _FakePaymentsRepository repository;
    late ProviderContainer container;

    setUp(() {
      repository = _FakePaymentsRepository([
        _payment('jan', createdAt: DateTime(2026, 1, 31, 23)),
        _payment('mar-old', createdAt: DateTime(2026, 3, 1, 8)),
        _payment('mar-new', createdAt: DateTime(2026, 3, 20, 10)),
        _payment('apr', createdAt: DateTime(2026, 4, 1)),
      ]);
      container = ProviderContainer(
        overrides: [paymentsRepositoryProvider.overrideWithValue(repository)],
      );
    });

    tearDown(() => container.dispose());

    test('hanya payment pada bulan yang diminta, terbaru dulu', () async {
      final items = await container.read(
        failedPaymentsProvider(DateTime(2026, 3)).future,
      );

      expect(items.map((p) => p.id), ['mar-new', 'mar-old']);
      expect(repository.lastStatus, 'failed');
    });

    test('bulan tanpa payment mengembalikan daftar kosong', () async {
      final items = await container.read(
        failedPaymentsProvider(DateTime(2026, 6)).future,
      );

      expect(items, isEmpty);
    });

    test('batas awal bulan ikut, batas awal bulan berikutnya eksklusif', () async {
      final march = await container.read(
        failedPaymentsProvider(DateTime(2026, 3)).future,
      );
      final january = await container.read(
        failedPaymentsProvider(DateTime(2026, 1)).future,
      );

      expect(march.map((p) => p.id), isNot(contains('apr')));
      expect(january.map((p) => p.id), ['jan']);
    });
  });
}
