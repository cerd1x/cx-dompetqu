// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../ai_settings_profile_collection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AiSettingsProfileCollection {

 List<AiSettingsProfile> get profiles; String? get activeProfileId;
/// Create a copy of AiSettingsProfileCollection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiSettingsProfileCollectionCopyWith<AiSettingsProfileCollection> get copyWith => _$AiSettingsProfileCollectionCopyWithImpl<AiSettingsProfileCollection>(this as AiSettingsProfileCollection, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AiSettingsProfileCollection;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiSettingsProfileCollection&&const DeepCollectionEquality().equals(other.profiles, _this.profiles)&&(identical(other.activeProfileId, _this.activeProfileId) || other.activeProfileId == _this.activeProfileId));
}


@override
int get hashCode {
  final _this = this as AiSettingsProfileCollection;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.profiles),_this.activeProfileId);
}

@override
String toString() {
  final _this = this as AiSettingsProfileCollection;
  return 'AiSettingsProfileCollection(profiles: ${_this.profiles}, activeProfileId: ${_this.activeProfileId})';
}


}

/// @nodoc
abstract mixin class $AiSettingsProfileCollectionCopyWith<$Res>  {
  factory $AiSettingsProfileCollectionCopyWith(AiSettingsProfileCollection value, $Res Function(AiSettingsProfileCollection) _then) = _$AiSettingsProfileCollectionCopyWithImpl;
@useResult
$Res call({
 List<AiSettingsProfile> profiles, String? activeProfileId
});




}
/// @nodoc
class _$AiSettingsProfileCollectionCopyWithImpl<$Res>
    implements $AiSettingsProfileCollectionCopyWith<$Res> {
  _$AiSettingsProfileCollectionCopyWithImpl(this._self, this._then);

  final AiSettingsProfileCollection _self;
  final $Res Function(AiSettingsProfileCollection) _then;

/// Create a copy of AiSettingsProfileCollection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? profiles = null,Object? activeProfileId = freezed,}) {
  return _then(AiSettingsProfileCollection(
profiles: null == profiles ? _self.profiles : profiles // ignore: cast_nullable_to_non_nullable
as List<AiSettingsProfile>,activeProfileId: freezed == activeProfileId ? _self.activeProfileId : activeProfileId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AiSettingsProfileCollection].
extension AiSettingsProfileCollectionPatterns on AiSettingsProfileCollection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiSettingsProfileCollection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiSettingsProfileCollection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiSettingsProfileCollection value)  $default,){
final _that = this;
switch (_that) {
case _AiSettingsProfileCollection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiSettingsProfileCollection value)?  $default,){
final _that = this;
switch (_that) {
case _AiSettingsProfileCollection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<AiSettingsProfile> profiles,  String? activeProfileId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiSettingsProfileCollection() when $default != null:
return $default(_that.profiles,_that.activeProfileId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<AiSettingsProfile> profiles,  String? activeProfileId)  $default,) {final _that = this;
switch (_that) {
case _AiSettingsProfileCollection():
return $default(_that.profiles,_that.activeProfileId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<AiSettingsProfile> profiles,  String? activeProfileId)?  $default,) {final _that = this;
switch (_that) {
case _AiSettingsProfileCollection() when $default != null:
return $default(_that.profiles,_that.activeProfileId);case _:
  return null;

}
}

}

/// @nodoc


class _AiSettingsProfileCollection extends AiSettingsProfileCollection {
  const _AiSettingsProfileCollection({required  List<AiSettingsProfile> profiles, required this.activeProfileId}): _profiles = profiles,super._();
  

 final  List<AiSettingsProfile> _profiles;
@override List<AiSettingsProfile> get profiles {
  if (_profiles is EqualUnmodifiableListView) return _profiles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_profiles);
}

@override final  String? activeProfileId;

/// Create a copy of AiSettingsProfileCollection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiSettingsProfileCollectionCopyWith<_AiSettingsProfileCollection> get copyWith => __$AiSettingsProfileCollectionCopyWithImpl<_AiSettingsProfileCollection>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiSettingsProfileCollection&&const DeepCollectionEquality().equals(other.profiles, _profiles)&&(identical(other.activeProfileId, activeProfileId) || other.activeProfileId == activeProfileId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_profiles),activeProfileId);
}

@override
String toString() {
    return 'AiSettingsProfileCollection(profiles: $profiles, activeProfileId: $activeProfileId)';
}


}

/// @nodoc
abstract mixin class _$AiSettingsProfileCollectionCopyWith<$Res> implements $AiSettingsProfileCollectionCopyWith<$Res> {
  factory _$AiSettingsProfileCollectionCopyWith(_AiSettingsProfileCollection value, $Res Function(_AiSettingsProfileCollection) _then) = __$AiSettingsProfileCollectionCopyWithImpl;
@override @useResult
$Res call({
 List<AiSettingsProfile> profiles, String? activeProfileId
});




}
/// @nodoc
class __$AiSettingsProfileCollectionCopyWithImpl<$Res>
    implements _$AiSettingsProfileCollectionCopyWith<$Res> {
  __$AiSettingsProfileCollectionCopyWithImpl(this._self, this._then);

  final _AiSettingsProfileCollection _self;
  final $Res Function(_AiSettingsProfileCollection) _then;

/// Create a copy of AiSettingsProfileCollection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? profiles = null,Object? activeProfileId = freezed,}) {
  return _then(_AiSettingsProfileCollection(
profiles: null == profiles ? _self._profiles : profiles // ignore: cast_nullable_to_non_nullable
as List<AiSettingsProfile>,activeProfileId: freezed == activeProfileId ? _self.activeProfileId : activeProfileId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
