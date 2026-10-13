import '../entities/disabled_operation.dart';

abstract interface class KillswitchRepository {
  bool get hasToken;
  Future<List<DisabledOperation>> list();
  Future<DisabledOperation> disable(String operation, {String? reason});
  Future<bool> enable(String operation);
}
