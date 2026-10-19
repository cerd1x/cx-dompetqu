// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../openrouter_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OpenRouterModel {

 String get id; String get name; int? get contextLength;
/// Create a copy of OpenRouterModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OpenRouterModelCopyWith<OpenRouterModel> get copyWith => _$OpenRouterModelCopyWithImpl<OpenRouterModel>(this as OpenRouterModel, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OpenRouterModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OpenRouterModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.contextLength, _this.contextLength) || other.contextLength == _this.contextLength));
}


@override
int get hashCode {
  final _this = this as OpenRouterModel;
  return Object.hash(runtimeType,_this.id,_this.name,_this.contextLength);
}

@override
String toString() {
  final _this = this as OpenRouterModel;
  return 'OpenRouterModel(id: ${_this.id}, name: ${_this.name}, contextLength: ${_this.contextLength})';
}


}

/// @nodoc
abstract mixin class $OpenRouterModelCopyWith<$Res>  {
  factory $OpenRouterModelCopyWith(OpenRouterModel value, $Res Function(OpenRouterModel) _then) = _$OpenRouterModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, int? contextLength
});




}
/// @nodoc
class _$OpenRouterModelCopyWithImpl<$Res>
    implements $OpenRouterModelCopyWith<$Res> {
  _$OpenRouterModelCopyWithImpl(this._self, this._then);

  final OpenRouterModel _self;
  final $Res Function(OpenRouterModel) _then;

/// Create a copy of OpenRouterModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? contextLength = freezed,}) {
  return _then(OpenRouterModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,contextLength: freezed == contextLength ? _self.contextLength : contextLength // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [OpenRouterModel].
extension OpenRouterModelPatterns on OpenRouterModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OpenRouterModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OpenRouterModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OpenRouterModel value)  $default,){
final _that = this;
switch (_that) {
case _OpenRouterModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OpenRouterModel value)?  $default,){
final _that = this;
switch (_that) {
case _OpenRouterModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int? contextLength)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OpenRouterModel() when $default != null:
return $default(_that.id,_that.name,_that.contextLength);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int? contextLength)  $default,) {final _that = this;
switch (_that) {
case _OpenRouterModel():
return $default(_that.id,_that.name,_that.contextLength);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int? contextLength)?  $default,) {final _that = this;
switch (_that) {
case _OpenRouterModel() when $default != null:
return $default(_that.id,_that.name,_that.contextLength);case _:
  return null;

}
}

}

/// @nodoc


class _OpenRouterModel extends OpenRouterModel {
  const _OpenRouterModel({required this.id, required this.name, this.contextLength}): super._();
  

@override final  String id;
@override final  String name;
@override final  int? contextLength;

/// Create a copy of OpenRouterModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OpenRouterModelCopyWith<_OpenRouterModel> get copyWith => __$OpenRouterModelCopyWithImpl<_OpenRouterModel>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OpenRouterModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.contextLength, contextLength) || other.contextLength == contextLength));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,contextLength);
}

@override
String toString() {
    return 'OpenRouterModel(id: $id, name: $name, contextLength: $contextLength)';
}


}

/// @nodoc
abstract mixin class _$OpenRouterModelCopyWith<$Res> implements $OpenRouterModelCopyWith<$Res> {
  factory _$OpenRouterModelCopyWith(_OpenRouterModel value, $Res Function(_OpenRouterModel) _then) = __$OpenRouterModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int? contextLength
});




}
/// @nodoc
class __$OpenRouterModelCopyWithImpl<$Res>
    implements _$OpenRouterModelCopyWith<$Res> {
  __$OpenRouterModelCopyWithImpl(this._self, this._then);

  final _OpenRouterModel _self;
  final $Res Function(_OpenRouterModel) _then;

/// Create a copy of OpenRouterModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? contextLength = freezed,}) {
  return _then(_OpenRouterModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,contextLength: freezed == contextLength ? _self.contextLength : contextLength // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
