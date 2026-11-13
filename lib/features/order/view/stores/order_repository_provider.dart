import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cx_dompetqiu/features/order/adapters/datasources/order_remote_source.dart';
import 'package:cx_dompetqiu/features/order/adapters/repositories/order_repository_impl.dart';
import 'package:cx_dompetqiu/features/order/domain/repositories/order_repository.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepositoryImpl(ref.watch(orderRemoteSourceProvider));
});
