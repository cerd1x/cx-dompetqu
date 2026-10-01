// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'passkey.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PasskeyOptions {

 String get options; String get challenge;
/// Create a copy of PasskeyOptions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PasskeyOptionsCopyWith<PasskeyOptions> get copyWith => _$PasskeyOptionsCopyWithImpl<PasskeyOptions>(this as PasskeyOptions, _$identity);

  /// Serializes this PasskeyOptions to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PasskeyOptions;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PasskeyOptions&&(identical(other.options, _this.options) || other.options == _this.options)&&(identical(other.challenge, _this.challenge) || other.challenge == _this.challenge));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PasskeyOptions;
  return Object.hash(runtimeType,_this.options,_this.challenge);
}

@override
String toString() {
  final _this = this as PasskeyOptions;
  return 'PasskeyOptions(options: ${_this.options}, challenge: ${_this.challenge})';
}


}

/// @nodoc
abstract mixin class $PasskeyOptionsCopyWith<$Res>  {
  factory $PasskeyOptionsCopyWith(PasskeyOptions value, $Res Function(PasskeyOptions) _then) = _$PasskeyOptionsCopyWithImpl;
@useResult
$Res call({
 String options, String challenge
});




}
/// @nodoc
class _$PasskeyOptionsCopyWithImpl<$Res>
    implements $PasskeyOptionsCopyWith<$Res> {
  _$PasskeyOptionsCopyWithImpl(this._self, this._then);

  final PasskeyOptions _self;
  final $Res Function(PasskeyOptions) _then;

/// Create a copy of PasskeyOptions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? options = null,Object? challenge = null,}) {
  return _then(PasskeyOptions(
options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as String,challenge: null == challenge ? _self.challenge : challenge // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PasskeyOptions].
extension PasskeyOptionsPatterns on PasskeyOptions {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PasskeyOptions value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PasskeyOptions() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PasskeyOptions value)  $default,){
final _that = this;
switch (_that) {
case _PasskeyOptions():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PasskeyOptions value)?  $default,){
final _that = this;
switch (_that) {
case _PasskeyOptions() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String options,  String challenge)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PasskeyOptions() when $default != null:
return $default(_that.options,_that.challenge);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String options,  String challenge)  $default,) {final _that = this;
switch (_that) {
case _PasskeyOptions():
return $default(_that.options,_that.challenge);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String options,  String challenge)?  $default,) {final _that = this;
switch (_that) {
case _PasskeyOptions() when $default != null:
return $default(_that.options,_that.challenge);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PasskeyOptions implements PasskeyOptions {
  const _PasskeyOptions({required this.options, required this.challenge});
  factory _PasskeyOptions.fromJson(Map<String, dynamic> json) => _$PasskeyOptionsFromJson(json);

@override final  String options;
@override final  String challenge;

/// Create a copy of PasskeyOptions
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PasskeyOptionsCopyWith<_PasskeyOptions> get copyWith => __$PasskeyOptionsCopyWithImpl<_PasskeyOptions>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PasskeyOptionsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PasskeyOptions&&(identical(other.options, options) || other.options == options)&&(identical(other.challenge, challenge) || other.challenge == challenge));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,options,challenge);
}

@override
String toString() {
    return 'PasskeyOptions(options: $options, challenge: $challenge)';
}


}

/// @nodoc
abstract mixin class _$PasskeyOptionsCopyWith<$Res> implements $PasskeyOptionsCopyWith<$Res> {
  factory _$PasskeyOptionsCopyWith(_PasskeyOptions value, $Res Function(_PasskeyOptions) _then) = __$PasskeyOptionsCopyWithImpl;
@override @useResult
$Res call({
 String options, String challenge
});




}
/// @nodoc
class __$PasskeyOptionsCopyWithImpl<$Res>
    implements _$PasskeyOptionsCopyWith<$Res> {
  __$PasskeyOptionsCopyWithImpl(this._self, this._then);

  final _PasskeyOptions _self;
  final $Res Function(_PasskeyOptions) _then;

/// Create a copy of PasskeyOptions
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? options = null,Object? challenge = null,}) {
  return _then(_PasskeyOptions(
options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as String,challenge: null == challenge ? _self.challenge : challenge // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$PasskeyCredential {

 String get id; String? get deviceName; DateTime? get createdAt;
/// Create a copy of PasskeyCredential
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PasskeyCredentialCopyWith<PasskeyCredential> get copyWith => _$PasskeyCredentialCopyWithImpl<PasskeyCredential>(this as PasskeyCredential, _$identity);

  /// Serializes this PasskeyCredential to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PasskeyCredential;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PasskeyCredential&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.deviceName, _this.deviceName) || other.deviceName == _this.deviceName)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PasskeyCredential;
  return Object.hash(runtimeType,_this.id,_this.deviceName,_this.createdAt);
}

@override
String toString() {
  final _this = this as PasskeyCredential;
  return 'PasskeyCredential(id: ${_this.id}, deviceName: ${_this.deviceName}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $PasskeyCredentialCopyWith<$Res>  {
  factory $PasskeyCredentialCopyWith(PasskeyCredential value, $Res Function(PasskeyCredential) _then) = _$PasskeyCredentialCopyWithImpl;
@useResult
$Res call({
 String id, String? deviceName, DateTime? createdAt
});




}
/// @nodoc
class _$PasskeyCredentialCopyWithImpl<$Res>
    implements $PasskeyCredentialCopyWith<$Res> {
  _$PasskeyCredentialCopyWithImpl(this._self, this._then);

  final PasskeyCredential _self;
  final $Res Function(PasskeyCredential) _then;

/// Create a copy of PasskeyCredential
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? deviceName = freezed,Object? createdAt = freezed,}) {
  return _then(PasskeyCredential(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,deviceName: freezed == deviceName ? _self.deviceName : deviceName // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PasskeyCredential].
extension PasskeyCredentialPatterns on PasskeyCredential {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PasskeyCredential value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PasskeyCredential() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PasskeyCredential value)  $default,){
final _that = this;
switch (_that) {
case _PasskeyCredential():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PasskeyCredential value)?  $default,){
final _that = this;
switch (_that) {
case _PasskeyCredential() when $default != null:
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
case _PasskeyCredential() when $default != null:
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
case _PasskeyCredential():
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
case _PasskeyCredential() when $default != null:
return $default(_that.id,_that.deviceName,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PasskeyCredential implements PasskeyCredential {
  const _PasskeyCredential({required this.id, this.deviceName, this.createdAt});
  factory _PasskeyCredential.fromJson(Map<String, dynamic> json) => _$PasskeyCredentialFromJson(json);

@override final  String id;
@override final  String? deviceName;
@override final  DateTime? createdAt;

/// Create a copy of PasskeyCredential
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PasskeyCredentialCopyWith<_PasskeyCredential> get copyWith => __$PasskeyCredentialCopyWithImpl<_PasskeyCredential>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PasskeyCredentialToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PasskeyCredential&&(identical(other.id, id) || other.id == id)&&(identical(other.deviceName, deviceName) || other.deviceName == deviceName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,deviceName,createdAt);
}

@override
String toString() {
    return 'PasskeyCredential(id: $id, deviceName: $deviceName, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$PasskeyCredentialCopyWith<$Res> implements $PasskeyCredentialCopyWith<$Res> {
  factory _$PasskeyCredentialCopyWith(_PasskeyCredential value, $Res Function(_PasskeyCredential) _then) = __$PasskeyCredentialCopyWithImpl;
@override @useResult
$Res call({
 String id, String? deviceName, DateTime? createdAt
});




}
/// @nodoc
class __$PasskeyCredentialCopyWithImpl<$Res>
    implements _$PasskeyCredentialCopyWith<$Res> {
  __$PasskeyCredentialCopyWithImpl(this._self, this._then);

  final _PasskeyCredential _self;
  final $Res Function(_PasskeyCredential) _then;

/// Create a copy of PasskeyCredential
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? deviceName = freezed,Object? createdAt = freezed,}) {
  return _then(_PasskeyCredential(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,deviceName: freezed == deviceName ? _self.deviceName : deviceName // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
