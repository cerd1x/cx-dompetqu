import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/datasources/order_remote_source.dart';
import '../data/repositories/order_repository_impl.dart';
import '../domain/repositories/order_repository.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepositoryImpl(ref.watch(orderRemoteSourceProvider));
});
