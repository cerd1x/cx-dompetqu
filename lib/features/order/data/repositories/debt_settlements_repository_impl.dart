import 'package:dompetqu/features/order/domain/repositories/debt_settlements_repository.dart';
import 'package:dompetqu/features/order/data/datasources/debt_settlements_local_datasource.dart';

class DebtSettlementsRepositoryImpl implements DebtSettlementsRepository {
  const DebtSettlementsRepositoryImpl(this._local);

  final DebtSettlementsLocalDataSource _local;

  @override
  Future<Set<String>> load() => _local.load();

  @override
  Future<void> save(Set<String> transactionIds) => _local.save(transactionIds);
}
