import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cx_dompetqiu/features/assets/adapters/datasources/assets_remote_source.dart';
import 'package:cx_dompetqiu/features/contacts/adapters/datasources/contacts_remote_source.dart';
import 'package:cx_dompetqiu/features/inventory/adapters/datasources/inventory_remote_source.dart';
import 'package:cx_dompetqiu/features/dashboard/adapters/repositories/home_repository_impl.dart';
import 'package:cx_dompetqiu/features/statistics/adapters/datasources/statistics_remote_source.dart';
import 'package:cx_dompetqiu/features/transactions/adapters/datasources/transactions_remote_source.dart';
import 'package:cx_dompetqiu/features/dashboard/domain/repositories/home_repository.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepositoryImpl(
    ref.watch(assetsRemoteSourceProvider),
    ref.watch(contactsRemoteSourceProvider),
    ref.watch(inventoryRemoteSourceProvider),
    ref.watch(statisticsRemoteSourceProvider),
    ref.watch(transactionsRemoteSourceProvider),
  );
});
