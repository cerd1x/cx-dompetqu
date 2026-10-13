import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../assets/data/datasources/assets_remote_source.dart';
import '../../contacts/data/datasources/contacts_remote_source.dart';
import '../../inventory/data/datasources/inventory_remote_source.dart';
import '../data/repositories/home_repository_impl.dart';
import '../../statistics/data/datasources/statistics_remote_source.dart';
import '../../transactions/data/datasources/transactions_remote_source.dart';
import '../domain/repositories/home_repository.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepositoryImpl(
    ref.watch(assetsRemoteSourceProvider),
    ref.watch(contactsRemoteSourceProvider),
    ref.watch(inventoryRemoteSourceProvider),
    ref.watch(statisticsRemoteSourceProvider),
    ref.watch(transactionsRemoteSourceProvider),
  );
});
