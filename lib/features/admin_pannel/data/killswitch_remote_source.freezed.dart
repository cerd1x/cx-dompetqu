// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'killswitch_remote_source.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$KillswitchEntry {

/// Kunci operation GraphQL, format `"<Type>.<field>"` (mis.
/// `Mutation.createTransaction`).
 String get operation;/// Alasan operator (opsional).
 String? get reason;/// Waktu saat operation dimatikan.
@JsonKey(fromJson: _parseDate) DateTime? get disabledAt;
/// Create a copy of KillswitchEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KillswitchEntryCopyWith<KillswitchEntry> get copyWith => _$KillswitchEntryCopyWithImpl<KillswitchEntry>(this as KillswitchEntry, _$identity);

  /// Serializes this KillswitchEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as KillswitchEntry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KillswitchEntry&&(identical(other.operation, _this.operation) || other.operation == _this.operation)&&(identical(other.reason, _this.reason) || other.reason == _this.reason)&&(identical(other.disabledAt, _this.disabledAt) || other.disabledAt == _this.disabledAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as KillswitchEntry;
  return Object.hash(runtimeType,_this.operation,_this.reason,_this.disabledAt);
}

@override
String toString() {
  final _this = this as KillswitchEntry;
  return 'KillswitchEntry(operation: ${_this.operation}, reason: ${_this.reason}, disabledAt: ${_this.disabledAt})';
}


}

/// @nodoc
abstract mixin class $KillswitchEntryCopyWith<$Res>  {
  factory $KillswitchEntryCopyWith(KillswitchEntry value, $Res Function(KillswitchEntry) _then) = _$KillswitchEntryCopyWithImpl;
@useResult
$Res call({
 String operation, String? reason,@JsonKey(fromJson: _parseDate) DateTime? disabledAt
});




}
/// @nodoc
class _$KillswitchEntryCopyWithImpl<$Res>
    implements $KillswitchEntryCopyWith<$Res> {
  _$KillswitchEntryCopyWithImpl(this._self, this._then);

  final KillswitchEntry _self;
  final $Res Function(KillswitchEntry) _then;

/// Create a copy of KillswitchEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? operation = null,Object? reason = freezed,Object? disabledAt = freezed,}) {
  return _then(KillswitchEntry(
operation: null == operation ? _self.operation : operation // ignore: cast_nullable_to_non_nullable
as String,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,disabledAt: freezed == disabledAt ? _self.disabledAt : disabledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [KillswitchEntry].
extension KillswitchEntryPatterns on KillswitchEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KillswitchEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KillswitchEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KillswitchEntry value)  $default,){
final _that = this;
switch (_that) {
case _KillswitchEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KillswitchEntry value)?  $default,){
final _that = this;
switch (_that) {
case _KillswitchEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String operation,  String? reason, @JsonKey(fromJson: _parseDate)  DateTime? disabledAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KillswitchEntry() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String operation,  String? reason, @JsonKey(fromJson: _parseDate)  DateTime? disabledAt)  $default,) {final _that = this;
switch (_that) {
case _KillswitchEntry():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String operation,  String? reason, @JsonKey(fromJson: _parseDate)  DateTime? disabledAt)?  $default,) {final _that = this;
switch (_that) {
case _KillswitchEntry() when $default != null:
return $default(_that.operation,_that.reason,_that.disabledAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KillswitchEntry implements KillswitchEntry {
  const _KillswitchEntry({required this.operation, this.reason, @JsonKey(fromJson: _parseDate) this.disabledAt});
  factory _KillswitchEntry.fromJson(Map<String, dynamic> json) => _$KillswitchEntryFromJson(json);

/// Kunci operation GraphQL, format `"<Type>.<field>"` (mis.
/// `Mutation.createTransaction`).
@override final  String operation;
/// Alasan operator (opsional).
@override final  String? reason;
/// Waktu saat operation dimatikan.
@override@JsonKey(fromJson: _parseDate) final  DateTime? disabledAt;

/// Create a copy of KillswitchEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KillswitchEntryCopyWith<_KillswitchEntry> get copyWith => __$KillswitchEntryCopyWithImpl<_KillswitchEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KillswitchEntryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _KillswitchEntry&&(identical(other.operation, operation) || other.operation == operation)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.disabledAt, disabledAt) || other.disabledAt == disabledAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,operation,reason,disabledAt);
}

@override
String toString() {
    return 'KillswitchEntry(operation: $operation, reason: $reason, disabledAt: $disabledAt)';
}


}

/// @nodoc
abstract mixin class _$KillswitchEntryCopyWith<$Res> implements $KillswitchEntryCopyWith<$Res> {
  factory _$KillswitchEntryCopyWith(_KillswitchEntry value, $Res Function(_KillswitchEntry) _then) = __$KillswitchEntryCopyWithImpl;
@override @useResult
$Res call({
 String operation, String? reason,@JsonKey(fromJson: _parseDate) DateTime? disabledAt
});




}
/// @nodoc
class __$KillswitchEntryCopyWithImpl<$Res>
    implements _$KillswitchEntryCopyWith<$Res> {
  __$KillswitchEntryCopyWithImpl(this._self, this._then);

  final _KillswitchEntry _self;
  final $Res Function(_KillswitchEntry) _then;

/// Create a copy of KillswitchEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? operation = null,Object? reason = freezed,Object? disabledAt = freezed,}) {
  return _then(_KillswitchEntry(
operation: null == operation ? _self.operation : operation // ignore: cast_nullable_to_non_nullable
as String,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,disabledAt: freezed == disabledAt ? _self.disabledAt : disabledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
