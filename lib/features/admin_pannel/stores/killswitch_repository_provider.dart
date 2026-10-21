import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/killswitch_remote_source.dart';
import '../data/repositories/killswitch_repository_impl.dart';
import '../domain/repositories/killswitch_repository.dart';

final killswitchRepositoryProvider = Provider<KillswitchRepository>((ref) {
  return KillswitchRepositoryImpl(ref.watch(killswitchRemoteSourceProvider));
});
