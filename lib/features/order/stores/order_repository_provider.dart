import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dompetqu/features/order/data/datasources/order_remote_source.dart';
import 'package:dompetqu/features/order/data/repositories/order_repository_impl.dart';
import 'package:dompetqu/features/order/domain/repositories/order_repository.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepositoryImpl(ref.watch(orderRemoteSourceProvider));
});
