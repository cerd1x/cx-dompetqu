// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../auth_passkey_credential.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthPasskeyCredential {

 String get id; String? get deviceName; DateTime? get createdAt;
/// Create a copy of AuthPasskeyCredential
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthPasskeyCredentialCopyWith<AuthPasskeyCredential> get copyWith => _$AuthPasskeyCredentialCopyWithImpl<AuthPasskeyCredential>(this as AuthPasskeyCredential, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AuthPasskeyCredential;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthPasskeyCredential&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.deviceName, _this.deviceName) || other.deviceName == _this.deviceName)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}


@override
int get hashCode {
  final _this = this as AuthPasskeyCredential;
  return Object.hash(runtimeType,_this.id,_this.deviceName,_this.createdAt);
}

@override
String toString() {
  final _this = this as AuthPasskeyCredential;
  return 'AuthPasskeyCredential(id: ${_this.id}, deviceName: ${_this.deviceName}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $AuthPasskeyCredentialCopyWith<$Res>  {
  factory $AuthPasskeyCredentialCopyWith(AuthPasskeyCredential value, $Res Function(AuthPasskeyCredential) _then) = _$AuthPasskeyCredentialCopyWithImpl;
@useResult
$Res call({
 String id, String? deviceName, DateTime? createdAt
});




}
/// @nodoc
class _$AuthPasskeyCredentialCopyWithImpl<$Res>
    implements $AuthPasskeyCredentialCopyWith<$Res> {
  _$AuthPasskeyCredentialCopyWithImpl(this._self, this._then);

  final AuthPasskeyCredential _self;
  final $Res Function(AuthPasskeyCredential) _then;

/// Create a copy of AuthPasskeyCredential
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? deviceName = freezed,Object? createdAt = freezed,}) {
  return _then(AuthPasskeyCredential(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,deviceName: freezed == deviceName ? _self.deviceName : deviceName // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthPasskeyCredential].
extension AuthPasskeyCredentialPatterns on AuthPasskeyCredential {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthPasskeyCredential value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthPasskeyCredential() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthPasskeyCredential value)  $default,){
final _that = this;
switch (_that) {
case _AuthPasskeyCredential():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthPasskeyCredential value)?  $default,){
final _that = this;
switch (_that) {
case _AuthPasskeyCredential() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? deviceName,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthPasskeyCredential() when $default != null:
return $default(_that.id,_that.deviceName,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? deviceName,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _AuthPasskeyCredential():
return $default(_that.id,_that.deviceName,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? deviceName,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _AuthPasskeyCredential() when $default != null:
return $default(_that.id,_that.deviceName,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _AuthPasskeyCredential extends AuthPasskeyCredential {
  const _AuthPasskeyCredential({required this.id, this.deviceName, this.createdAt}): super._();
  

@override final  String id;
@override final  String? deviceName;
@override final  DateTime? createdAt;

/// Create a copy of AuthPasskeyCredential
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthPasskeyCredentialCopyWith<_AuthPasskeyCredential> get copyWith => __$AuthPasskeyCredentialCopyWithImpl<_AuthPasskeyCredential>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthPasskeyCredential&&(identical(other.id, id) || other.id == id)&&(identical(other.deviceName, deviceName) || other.deviceName == deviceName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,deviceName,createdAt);
}

@override
String toString() {
    return 'AuthPasskeyCredential(id: $id, deviceName: $deviceName, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$AuthPasskeyCredentialCopyWith<$Res> implements $AuthPasskeyCredentialCopyWith<$Res> {
  factory _$AuthPasskeyCredentialCopyWith(_AuthPasskeyCredential value, $Res Function(_AuthPasskeyCredential) _then) = __$AuthPasskeyCredentialCopyWithImpl;
@override @useResult
$Res call({
 String id, String? deviceName, DateTime? createdAt
});




}
/// @nodoc
class __$AuthPasskeyCredentialCopyWithImpl<$Res>
    implements _$AuthPasskeyCredentialCopyWith<$Res> {
  __$AuthPasskeyCredentialCopyWithImpl(this._self, this._then);

  final _AuthPasskeyCredential _self;
  final $Res Function(_AuthPasskeyCredential) _then;

/// Create a copy of AuthPasskeyCredential
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? deviceName = freezed,Object? createdAt = freezed,}) {
  return _then(_AuthPasskeyCredential(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,deviceName: freezed == deviceName ? _self.deviceName : deviceName // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
