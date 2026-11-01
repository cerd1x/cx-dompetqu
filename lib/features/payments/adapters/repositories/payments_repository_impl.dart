import 'package:dompetqu/features/payments/adapters/datasources/payments_remote_source.dart';
import 'package:dompetqu/features/payments/domain/models/payment.dart';
import 'package:dompetqu/features/payments/domain/repositories/payments_repository.dart';

/// Implementasi port payment di atas [PaymentsRemoteSource] (GraphQL).
class PaymentsRepositoryImpl implements PaymentsRepository {
  PaymentsRepositoryImpl(this._source);

  final PaymentsRemoteSource _source;

  @override
  Future<List<Payment>> byStatus(String status) => _source.byStatus(status);

  @override
  Future<Payment> retry(String id) => _source.retry(id);
}
