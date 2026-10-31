// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../disabled_operation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DisabledOperation {

 String get operation; String? get reason; DateTime? get disabledAt;
/// Create a copy of DisabledOperation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DisabledOperationCopyWith<DisabledOperation> get copyWith => _$DisabledOperationCopyWithImpl<DisabledOperation>(this as DisabledOperation, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DisabledOperation;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DisabledOperation&&(identical(other.operation, _this.operation) || other.operation == _this.operation)&&(identical(other.reason, _this.reason) || other.reason == _this.reason)&&(identical(other.disabledAt, _this.disabledAt) || other.disabledAt == _this.disabledAt));
}


@override
int get hashCode {
  final _this = this as DisabledOperation;
  return Object.hash(runtimeType,_this.operation,_this.reason,_this.disabledAt);
}

@override
String toString() {
  final _this = this as DisabledOperation;
  return 'DisabledOperation(operation: ${_this.operation}, reason: ${_this.reason}, disabledAt: ${_this.disabledAt})';
}


}

/// @nodoc
abstract mixin class $DisabledOperationCopyWith<$Res>  {
  factory $DisabledOperationCopyWith(DisabledOperation value, $Res Function(DisabledOperation) _then) = _$DisabledOperationCopyWithImpl;
@useResult
$Res call({
 String operation, String? reason, DateTime? disabledAt
});




}
/// @nodoc
class _$DisabledOperationCopyWithImpl<$Res>
    implements $DisabledOperationCopyWith<$Res> {
  _$DisabledOperationCopyWithImpl(this._self, this._then);

  final DisabledOperation _self;
  final $Res Function(DisabledOperation) _then;

/// Create a copy of DisabledOperation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? operation = null,Object? reason = freezed,Object? disabledAt = freezed,}) {
  return _then(DisabledOperation(
operation: null == operation ? _self.operation : operation // ignore: cast_nullable_to_non_nullable
as String,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,disabledAt: freezed == disabledAt ? _self.disabledAt : disabledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [DisabledOperation].
extension DisabledOperationPatterns on DisabledOperation {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DisabledOperation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DisabledOperation() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DisabledOperation value)  $default,){
final _that = this;
switch (_that) {
case _DisabledOperation():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DisabledOperation value)?  $default,){
final _that = this;
switch (_that) {
case _DisabledOperation() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String operation,  String? reason,  DateTime? disabledAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DisabledOperation() when $default != null:
return $default(_that.operation,_that.reason,_that.disabledAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String operation,  String? reason,  DateTime? disabledAt)  $default,) {final _that = this;
switch (_that) {
case _DisabledOperation():
return $default(_that.operation,_that.reason,_that.disabledAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String operation,  String? reason,  DateTime? disabledAt)?  $default,) {final _that = this;
switch (_that) {
case _DisabledOperation() when $default != null:
return $default(_that.operation,_that.reason,_that.disabledAt);case _:
  return null;

}
}

}

/// @nodoc


class _DisabledOperation extends DisabledOperation {
  const _DisabledOperation({required this.operation, this.reason, this.disabledAt}): super._();
  

@override final  String operation;
@override final  String? reason;
@override final  DateTime? disabledAt;

/// Create a copy of DisabledOperation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DisabledOperationCopyWith<_DisabledOperation> get copyWith => __$DisabledOperationCopyWithImpl<_DisabledOperation>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DisabledOperation&&(identical(other.operation, operation) || other.operation == operation)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.disabledAt, disabledAt) || other.disabledAt == disabledAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,operation,reason,disabledAt);
}

@override
String toString() {
    return 'DisabledOperation(operation: $operation, reason: $reason, disabledAt: $disabledAt)';
}


}

/// @nodoc
abstract mixin class _$DisabledOperationCopyWith<$Res> implements $DisabledOperationCopyWith<$Res> {
  factory _$DisabledOperationCopyWith(_DisabledOperation value, $Res Function(_DisabledOperation) _then) = __$DisabledOperationCopyWithImpl;
@override @useResult
$Res call({
 String operation, String? reason, DateTime? disabledAt
});




}
/// @nodoc
class __$DisabledOperationCopyWithImpl<$Res>
    implements _$DisabledOperationCopyWith<$Res> {
  __$DisabledOperationCopyWithImpl(this._self, this._then);

  final _DisabledOperation _self;
  final $Res Function(_DisabledOperation) _then;

/// Create a copy of DisabledOperation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? operation = null,Object? reason = freezed,Object? disabledAt = freezed,}) {
  return _then(_DisabledOperation(
operation: null == operation ? _self.operation : operation // ignore: cast_nullable_to_non_nullable
as String,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,disabledAt: freezed == disabledAt ? _self.disabledAt : disabledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
