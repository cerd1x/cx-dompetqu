import 'package:cx_dompetqiu/features/admin_pannel/adapters/killswitch_remote_source.dart';
import 'package:cx_dompetqiu/features/admin_pannel/adapters/repositories/killswitch_repository_impl.dart';
import 'package:cx_dompetqiu/features/admin_pannel/domain/repositories/killswitch_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final killswitchRepositoryProvider = Provider<KillswitchRepository>((ref) {
  return KillswitchRepositoryImpl(ref.watch(killswitchRemoteSourceProvider));
});
