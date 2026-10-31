import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/disabled_operation.freezed.dart';

/// Satu operation GraphQL yang sedang dimatikan lewat kill switch.
@freezed
abstract class DisabledOperation with _$DisabledOperation {
  const factory DisabledOperation({
    required String operation,
    String? reason,
    DateTime? disabledAt,
  }) = _DisabledOperation;

  const DisabledOperation._();
}
