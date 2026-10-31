import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dompetqu/features/assets/adapters/datasources/assets_remote_source.dart';
import 'package:dompetqu/features/contacts/adapters/datasources/contacts_remote_source.dart';
import 'package:dompetqu/features/inventory/data/datasources/inventory_remote_source.dart';
import 'package:dompetqu/features/dashboard/adapters/repositories/home_repository_impl.dart';
import 'package:dompetqu/features/statistics/data/datasources/statistics_remote_source.dart';
import 'package:dompetqu/features/transactions/data/datasources/transactions_remote_source.dart';
import 'package:dompetqu/features/dashboard/domain/repositories/home_repository.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepositoryImpl(
    ref.watch(assetsRemoteSourceProvider),
    ref.watch(contactsRemoteSourceProvider),
    ref.watch(inventoryRemoteSourceProvider),
    ref.watch(statisticsRemoteSourceProvider),
    ref.watch(transactionsRemoteSourceProvider),
  );
});
