// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../ai_skill.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AiSkill {

 String get id; String get name; String get instructions;
/// Create a copy of AiSkill
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiSkillCopyWith<AiSkill> get copyWith => _$AiSkillCopyWithImpl<AiSkill>(this as AiSkill, _$identity);

  /// Serializes this AiSkill to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AiSkill;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiSkill&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.instructions, _this.instructions) || other.instructions == _this.instructions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AiSkill;
  return Object.hash(runtimeType,_this.id,_this.name,_this.instructions);
}

@override
String toString() {
  final _this = this as AiSkill;
  return 'AiSkill(id: ${_this.id}, name: ${_this.name}, instructions: ${_this.instructions})';
}


}

/// @nodoc
abstract mixin class $AiSkillCopyWith<$Res>  {
  factory $AiSkillCopyWith(AiSkill value, $Res Function(AiSkill) _then) = _$AiSkillCopyWithImpl;
@useResult
$Res call({
 String id, String name, String instructions
});




}
/// @nodoc
class _$AiSkillCopyWithImpl<$Res>
    implements $AiSkillCopyWith<$Res> {
  _$AiSkillCopyWithImpl(this._self, this._then);

  final AiSkill _self;
  final $Res Function(AiSkill) _then;

/// Create a copy of AiSkill
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? instructions = null,}) {
  return _then(AiSkill(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,instructions: null == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AiSkill].
extension AiSkillPatterns on AiSkill {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiSkill value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiSkill() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiSkill value)  $default,){
final _that = this;
switch (_that) {
case _AiSkill():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiSkill value)?  $default,){
final _that = this;
switch (_that) {
case _AiSkill() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String instructions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiSkill() when $default != null:
return $default(_that.id,_that.name,_that.instructions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String instructions)  $default,) {final _that = this;
switch (_that) {
case _AiSkill():
return $default(_that.id,_that.name,_that.instructions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String instructions)?  $default,) {final _that = this;
switch (_that) {
case _AiSkill() when $default != null:
return $default(_that.id,_that.name,_that.instructions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiSkill implements AiSkill {
  const _AiSkill({required this.id, required this.name, required this.instructions});
  factory _AiSkill.fromJson(Map<String, dynamic> json) => _$AiSkillFromJson(json);

@override final  String id;
@override final  String name;
@override final  String instructions;

/// Create a copy of AiSkill
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiSkillCopyWith<_AiSkill> get copyWith => __$AiSkillCopyWithImpl<_AiSkill>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiSkillToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiSkill&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.instructions, instructions) || other.instructions == instructions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,instructions);
}

@override
String toString() {
    return 'AiSkill(id: $id, name: $name, instructions: $instructions)';
}


}

/// @nodoc
abstract mixin class _$AiSkillCopyWith<$Res> implements $AiSkillCopyWith<$Res> {
  factory _$AiSkillCopyWith(_AiSkill value, $Res Function(_AiSkill) _then) = __$AiSkillCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String instructions
});




}
/// @nodoc
class __$AiSkillCopyWithImpl<$Res>
    implements _$AiSkillCopyWith<$Res> {
  __$AiSkillCopyWithImpl(this._self, this._then);

  final _AiSkill _self;
  final $Res Function(_AiSkill) _then;

/// Create a copy of AiSkill
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? instructions = null,}) {
  return _then(_AiSkill(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,instructions: null == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
