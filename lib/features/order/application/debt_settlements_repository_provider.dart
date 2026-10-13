import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/datasources/debt_settlements_local_datasource.dart';
import '../data/repositories/debt_settlements_repository_impl.dart';
import '../domain/repositories/debt_settlements_repository.dart';

final debtSettlementsRepositoryProvider = Provider<DebtSettlementsRepository>(
  (ref) => DebtSettlementsRepositoryImpl(
    SharedPreferencesDebtSettlementsDataSource(),
  ),
);
