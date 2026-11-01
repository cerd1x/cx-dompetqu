// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../ai_settings_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AiSettingsProfile {

 String get id; String get name; AiModelProvider get provider; String get apiKey; String get model; String get baseUrl; bool get includeCustomHeaders; Map<String, String> get customHeaders; bool get useCustomModel;
/// Create a copy of AiSettingsProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiSettingsProfileCopyWith<AiSettingsProfile> get copyWith => _$AiSettingsProfileCopyWithImpl<AiSettingsProfile>(this as AiSettingsProfile, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AiSettingsProfile;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiSettingsProfile&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.provider, _this.provider) || other.provider == _this.provider)&&(identical(other.apiKey, _this.apiKey) || other.apiKey == _this.apiKey)&&(identical(other.model, _this.model) || other.model == _this.model)&&(identical(other.baseUrl, _this.baseUrl) || other.baseUrl == _this.baseUrl)&&(identical(other.includeCustomHeaders, _this.includeCustomHeaders) || other.includeCustomHeaders == _this.includeCustomHeaders)&&const DeepCollectionEquality().equals(other.customHeaders, _this.customHeaders)&&(identical(other.useCustomModel, _this.useCustomModel) || other.useCustomModel == _this.useCustomModel));
}


@override
int get hashCode {
  final _this = this as AiSettingsProfile;
  return Object.hash(runtimeType,_this.id,_this.name,_this.provider,_this.apiKey,_this.model,_this.baseUrl,_this.includeCustomHeaders,const DeepCollectionEquality().hash(_this.customHeaders),_this.useCustomModel);
}

@override
String toString() {
  final _this = this as AiSettingsProfile;
  return 'AiSettingsProfile(id: ${_this.id}, name: ${_this.name}, provider: ${_this.provider}, apiKey: ${_this.apiKey}, model: ${_this.model}, baseUrl: ${_this.baseUrl}, includeCustomHeaders: ${_this.includeCustomHeaders}, customHeaders: ${_this.customHeaders}, useCustomModel: ${_this.useCustomModel})';
}


}

/// @nodoc
abstract mixin class $AiSettingsProfileCopyWith<$Res>  {
  factory $AiSettingsProfileCopyWith(AiSettingsProfile value, $Res Function(AiSettingsProfile) _then) = _$AiSettingsProfileCopyWithImpl;
@useResult
$Res call({
 String id, String name, AiModelProvider provider, String apiKey, String model, String baseUrl, bool includeCustomHeaders, Map<String, String> customHeaders, bool useCustomModel
});




}
/// @nodoc
class _$AiSettingsProfileCopyWithImpl<$Res>
    implements $AiSettingsProfileCopyWith<$Res> {
  _$AiSettingsProfileCopyWithImpl(this._self, this._then);

  final AiSettingsProfile _self;
  final $Res Function(AiSettingsProfile) _then;

/// Create a copy of AiSettingsProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? provider = null,Object? apiKey = null,Object? model = null,Object? baseUrl = null,Object? includeCustomHeaders = null,Object? customHeaders = null,Object? useCustomModel = null,}) {
  return _then(AiSettingsProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as AiModelProvider,apiKey: null == apiKey ? _self.apiKey : apiKey // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,baseUrl: null == baseUrl ? _self.baseUrl : baseUrl // ignore: cast_nullable_to_non_nullable
as String,includeCustomHeaders: null == includeCustomHeaders ? _self.includeCustomHeaders : includeCustomHeaders // ignore: cast_nullable_to_non_nullable
as bool,customHeaders: null == customHeaders ? _self.customHeaders : customHeaders // ignore: cast_nullable_to_non_nullable
as Map<String, String>,useCustomModel: null == useCustomModel ? _self.useCustomModel : useCustomModel // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AiSettingsProfile].
extension AiSettingsProfilePatterns on AiSettingsProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiSettingsProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiSettingsProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiSettingsProfile value)  $default,){
final _that = this;
switch (_that) {
case _AiSettingsProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiSettingsProfile value)?  $default,){
final _that = this;
switch (_that) {
case _AiSettingsProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  AiModelProvider provider,  String apiKey,  String model,  String baseUrl,  bool includeCustomHeaders,  Map<String, String> customHeaders,  bool useCustomModel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiSettingsProfile() when $default != null:
return $default(_that.id,_that.name,_that.provider,_that.apiKey,_that.model,_that.baseUrl,_that.includeCustomHeaders,_that.customHeaders,_that.useCustomModel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  AiModelProvider provider,  String apiKey,  String model,  String baseUrl,  bool includeCustomHeaders,  Map<String, String> customHeaders,  bool useCustomModel)  $default,) {final _that = this;
switch (_that) {
case _AiSettingsProfile():
return $default(_that.id,_that.name,_that.provider,_that.apiKey,_that.model,_that.baseUrl,_that.includeCustomHeaders,_that.customHeaders,_that.useCustomModel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  AiModelProvider provider,  String apiKey,  String model,  String baseUrl,  bool includeCustomHeaders,  Map<String, String> customHeaders,  bool useCustomModel)?  $default,) {final _that = this;
switch (_that) {
case _AiSettingsProfile() when $default != null:
return $default(_that.id,_that.name,_that.provider,_that.apiKey,_that.model,_that.baseUrl,_that.includeCustomHeaders,_that.customHeaders,_that.useCustomModel);case _:
  return null;

}
}

}

/// @nodoc


class _AiSettingsProfile extends AiSettingsProfile {
  const _AiSettingsProfile({required this.id, required this.name, required this.provider, required this.apiKey, required this.model, required this.baseUrl, required this.includeCustomHeaders, required  Map<String, String> customHeaders, required this.useCustomModel}): _customHeaders = customHeaders,super._();
  

@override final  String id;
@override final  String name;
@override final  AiModelProvider provider;
@override final  String apiKey;
@override final  String model;
@override final  String baseUrl;
@override final  bool includeCustomHeaders;
 final  Map<String, String> _customHeaders;
@override Map<String, String> get customHeaders {
  if (_customHeaders is EqualUnmodifiableMapView) return _customHeaders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_customHeaders);
}

@override final  bool useCustomModel;

/// Create a copy of AiSettingsProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiSettingsProfileCopyWith<_AiSettingsProfile> get copyWith => __$AiSettingsProfileCopyWithImpl<_AiSettingsProfile>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiSettingsProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.apiKey, apiKey) || other.apiKey == apiKey)&&(identical(other.model, model) || other.model == model)&&(identical(other.baseUrl, baseUrl) || other.baseUrl == baseUrl)&&(identical(other.includeCustomHeaders, includeCustomHeaders) || other.includeCustomHeaders == includeCustomHeaders)&&const DeepCollectionEquality().equals(other.customHeaders, _customHeaders)&&(identical(other.useCustomModel, useCustomModel) || other.useCustomModel == useCustomModel));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,provider,apiKey,model,baseUrl,includeCustomHeaders,const DeepCollectionEquality().hash(_customHeaders),useCustomModel);
}

@override
String toString() {
    return 'AiSettingsProfile(id: $id, name: $name, provider: $provider, apiKey: $apiKey, model: $model, baseUrl: $baseUrl, includeCustomHeaders: $includeCustomHeaders, customHeaders: $customHeaders, useCustomModel: $useCustomModel)';
}


}

/// @nodoc
abstract mixin class _$AiSettingsProfileCopyWith<$Res> implements $AiSettingsProfileCopyWith<$Res> {
  factory _$AiSettingsProfileCopyWith(_AiSettingsProfile value, $Res Function(_AiSettingsProfile) _then) = __$AiSettingsProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, AiModelProvider provider, String apiKey, String model, String baseUrl, bool includeCustomHeaders, Map<String, String> customHeaders, bool useCustomModel
});




}
/// @nodoc
class __$AiSettingsProfileCopyWithImpl<$Res>
    implements _$AiSettingsProfileCopyWith<$Res> {
  __$AiSettingsProfileCopyWithImpl(this._self, this._then);

  final _AiSettingsProfile _self;
  final $Res Function(_AiSettingsProfile) _then;

/// Create a copy of AiSettingsProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? provider = null,Object? apiKey = null,Object? model = null,Object? baseUrl = null,Object? includeCustomHeaders = null,Object? customHeaders = null,Object? useCustomModel = null,}) {
  return _then(_AiSettingsProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as AiModelProvider,apiKey: null == apiKey ? _self.apiKey : apiKey // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,baseUrl: null == baseUrl ? _self.baseUrl : baseUrl // ignore: cast_nullable_to_non_nullable
as String,includeCustomHeaders: null == includeCustomHeaders ? _self.includeCustomHeaders : includeCustomHeaders // ignore: cast_nullable_to_non_nullable
as bool,customHeaders: null == customHeaders ? _self._customHeaders : customHeaders // ignore: cast_nullable_to_non_nullable
as Map<String, String>,useCustomModel: null == useCustomModel ? _self.useCustomModel : useCustomModel // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
