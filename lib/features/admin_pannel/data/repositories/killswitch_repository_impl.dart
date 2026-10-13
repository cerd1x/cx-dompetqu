import '../../domain/entities/disabled_operation.dart';
import '../../domain/repositories/killswitch_repository.dart';
import '../killswitch_remote_source.dart';

class KillswitchRepositoryImpl implements KillswitchRepository {
  const KillswitchRepositoryImpl(this._remote);

  final KillswitchDataSource _remote;

  @override
  bool get hasToken => _remote.hasToken;

  @override
  Future<List<DisabledOperation>> list() async =>
      (await _remote.list()).map(_toEntity).toList();

  @override
  Future<DisabledOperation> disable(String operation, {String? reason}) async =>
      _toEntity(await _remote.disable(operation, reason: reason));

  @override
  Future<bool> enable(String operation) => _remote.enable(operation);

  DisabledOperation _toEntity(KillswitchEntry model) => DisabledOperation(
    operation: model.operation,
    reason: model.reason,
    disabledAt: model.disabledAt,
  );
}
