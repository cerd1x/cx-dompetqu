import 'package:get_it/get_it.dart';
import 'package:dompetqu/core/database/entities/debt_settlement_entity.dart';
import 'package:dompetqu/core/database/objectbox_database.dart';

abstract interface class DebtSettlementsLocalDataSource {
  Future<Set<String>> load();
  Future<void> save(Set<String> transactionIds);
}

class ObjectBoxDebtSettlementsDataSource
    implements DebtSettlementsLocalDataSource {
  ObjectBoxDatabase get _db => GetIt.instance.get<ObjectBoxDatabase>();

  @override
  Future<Set<String>> load() async {
    return _db.debtSettlementBox.getAll().map((e) => e.transactionId).toSet();
  }

  @override
  Future<void> save(Set<String> transactionIds) async {
    _db.debtSettlementBox.removeAll();
    final entities = transactionIds
        .map((id) => DebtSettlementEntity(transactionId: id))
        .toList();
    _db.debtSettlementBox.putMany(entities);
  }
}
