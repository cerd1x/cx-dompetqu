import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dompetqu/features/order/adapters/datasources/debt_settlements_local_datasource.dart';
import 'package:dompetqu/features/order/adapters/repositories/debt_settlements_repository_impl.dart';
import 'package:dompetqu/features/order/domain/repositories/debt_settlements_repository.dart';

final debtSettlementsRepositoryProvider = Provider<DebtSettlementsRepository>(
  (ref) => DebtSettlementsRepositoryImpl(
    SharedPreferencesDebtSettlementsDataSource(),
  ),
);
