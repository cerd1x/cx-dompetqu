import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cx_dompetqiu/features/order/adapters/datasources/bookkeeping_remote_source.dart';
import 'package:cx_dompetqiu/features/order/adapters/repositories/bookkeeping_repository_impl.dart';
import 'package:cx_dompetqiu/features/order/domain/repositories/bookkeeping_repository.dart';

final bookkeepingRepositoryProvider = Provider<BookkeepingRepository>((ref) {
  return BookkeepingRepositoryImpl(ref.watch(bookkeepingRemoteSourceProvider));
});
