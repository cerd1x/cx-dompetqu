// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../app_lock_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppLockState {

 bool get isEnabled; LockCredential get credential; bool get biometricEnabled; bool get locked; int get failedAttempts; DateTime? get lockoutUntil;



@override
bool operator ==(Object other) {
  final _this = this as AppLockState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppLockState&&(identical(other.isEnabled, _this.isEnabled) || other.isEnabled == _this.isEnabled)&&(identical(other.credential, _this.credential) || other.credential == _this.credential)&&(identical(other.biometricEnabled, _this.biometricEnabled) || other.biometricEnabled == _this.biometricEnabled)&&(identical(other.locked, _this.locked) || other.locked == _this.locked)&&(identical(other.failedAttempts, _this.failedAttempts) || other.failedAttempts == _this.failedAttempts)&&(identical(other.lockoutUntil, _this.lockoutUntil) || other.lockoutUntil == _this.lockoutUntil));
}


@override
int get hashCode {
  final _this = this as AppLockState;
  return Object.hash(runtimeType,_this.isEnabled,_this.credential,_this.biometricEnabled,_this.locked,_this.failedAttempts,_this.lockoutUntil);
}

@override
String toString() {
  final _this = this as AppLockState;
  return 'AppLockState(isEnabled: ${_this.isEnabled}, credential: ${_this.credential}, biometricEnabled: ${_this.biometricEnabled}, locked: ${_this.locked}, failedAttempts: ${_this.failedAttempts}, lockoutUntil: ${_this.lockoutUntil})';
}


}




/// Adds pattern-matching-related methods to [AppLockState].
extension AppLockStatePatterns on AppLockState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppLockState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppLockState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppLockState value)  $default,){
final _that = this;
switch (_that) {
case _AppLockState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppLockState value)?  $default,){
final _that = this;
switch (_that) {
case _AppLockState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isEnabled,  LockCredential credential,  bool biometricEnabled,  bool locked,  int failedAttempts,  DateTime? lockoutUntil)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppLockState() when $default != null:
return $default(_that.isEnabled,_that.credential,_that.biometricEnabled,_that.locked,_that.failedAttempts,_that.lockoutUntil);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isEnabled,  LockCredential credential,  bool biometricEnabled,  bool locked,  int failedAttempts,  DateTime? lockoutUntil)  $default,) {final _that = this;
switch (_that) {
case _AppLockState():
return $default(_that.isEnabled,_that.credential,_that.biometricEnabled,_that.locked,_that.failedAttempts,_that.lockoutUntil);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isEnabled,  LockCredential credential,  bool biometricEnabled,  bool locked,  int failedAttempts,  DateTime? lockoutUntil)?  $default,) {final _that = this;
switch (_that) {
case _AppLockState() when $default != null:
return $default(_that.isEnabled,_that.credential,_that.biometricEnabled,_that.locked,_that.failedAttempts,_that.lockoutUntil);case _:
  return null;

}
}

}

/// @nodoc


class _AppLockState extends AppLockState {
  const _AppLockState({this.isEnabled = false, this.credential = LockCredential.pin, this.biometricEnabled = false, this.locked = true, this.failedAttempts = 0, this.lockoutUntil}): super._();
  

@override@JsonKey() final  bool isEnabled;
@override@JsonKey() final  LockCredential credential;
@override@JsonKey() final  bool biometricEnabled;
@override@JsonKey() final  bool locked;
@override@JsonKey() final  int failedAttempts;
@override final  DateTime? lockoutUntil;




@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppLockState&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled)&&(identical(other.credential, credential) || other.credential == credential)&&(identical(other.biometricEnabled, biometricEnabled) || other.biometricEnabled == biometricEnabled)&&(identical(other.locked, locked) || other.locked == locked)&&(identical(other.failedAttempts, failedAttempts) || other.failedAttempts == failedAttempts)&&(identical(other.lockoutUntil, lockoutUntil) || other.lockoutUntil == lockoutUntil));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isEnabled,credential,biometricEnabled,locked,failedAttempts,lockoutUntil);
}

@override
String toString() {
    return 'AppLockState(isEnabled: $isEnabled, credential: $credential, biometricEnabled: $biometricEnabled, locked: $locked, failedAttempts: $failedAttempts, lockoutUntil: $lockoutUntil)';
}


}




// dart format on
