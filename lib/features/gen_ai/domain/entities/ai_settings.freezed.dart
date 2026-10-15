// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AiSettings {

 AiModelProvider get provider; String get apiKey; String get model; String get baseUrl; bool get showAiBubble; bool get includeCustomHeaders; Map<String, String> get customHeaders; bool get useCustomModel;
/// Create a copy of AiSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiSettingsCopyWith<AiSettings> get copyWith => _$AiSettingsCopyWithImpl<AiSettings>(this as AiSettings, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AiSettings;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiSettings&&(identical(other.provider, _this.provider) || other.provider == _this.provider)&&(identical(other.apiKey, _this.apiKey) || other.apiKey == _this.apiKey)&&(identical(other.model, _this.model) || other.model == _this.model)&&(identical(other.baseUrl, _this.baseUrl) || other.baseUrl == _this.baseUrl)&&(identical(other.showAiBubble, _this.showAiBubble) || other.showAiBubble == _this.showAiBubble)&&(identical(other.includeCustomHeaders, _this.includeCustomHeaders) || other.includeCustomHeaders == _this.includeCustomHeaders)&&const DeepCollectionEquality().equals(other.customHeaders, _this.customHeaders)&&(identical(other.useCustomModel, _this.useCustomModel) || other.useCustomModel == _this.useCustomModel));
}


@override
int get hashCode {
  final _this = this as AiSettings;
  return Object.hash(runtimeType,_this.provider,_this.apiKey,_this.model,_this.baseUrl,_this.showAiBubble,_this.includeCustomHeaders,const DeepCollectionEquality().hash(_this.customHeaders),_this.useCustomModel);
}

@override
String toString() {
  final _this = this as AiSettings;
  return 'AiSettings(provider: ${_this.provider}, apiKey: ${_this.apiKey}, model: ${_this.model}, baseUrl: ${_this.baseUrl}, showAiBubble: ${_this.showAiBubble}, includeCustomHeaders: ${_this.includeCustomHeaders}, customHeaders: ${_this.customHeaders}, useCustomModel: ${_this.useCustomModel})';
}


}

/// @nodoc
abstract mixin class $AiSettingsCopyWith<$Res>  {
  factory $AiSettingsCopyWith(AiSettings value, $Res Function(AiSettings) _then) = _$AiSettingsCopyWithImpl;
@useResult
$Res call({
 AiModelProvider provider, String apiKey, String model, String baseUrl, bool showAiBubble, bool includeCustomHeaders, Map<String, String> customHeaders, bool useCustomModel
});




}
/// @nodoc
class _$AiSettingsCopyWithImpl<$Res>
    implements $AiSettingsCopyWith<$Res> {
  _$AiSettingsCopyWithImpl(this._self, this._then);

  final AiSettings _self;
  final $Res Function(AiSettings) _then;

/// Create a copy of AiSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? provider = null,Object? apiKey = null,Object? model = null,Object? baseUrl = null,Object? showAiBubble = null,Object? includeCustomHeaders = null,Object? customHeaders = null,Object? useCustomModel = null,}) {
  return _then(AiSettings(
provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as AiModelProvider,apiKey: null == apiKey ? _self.apiKey : apiKey // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,baseUrl: null == baseUrl ? _self.baseUrl : baseUrl // ignore: cast_nullable_to_non_nullable
as String,showAiBubble: null == showAiBubble ? _self.showAiBubble : showAiBubble // ignore: cast_nullable_to_non_nullable
as bool,includeCustomHeaders: null == includeCustomHeaders ? _self.includeCustomHeaders : includeCustomHeaders // ignore: cast_nullable_to_non_nullable
as bool,customHeaders: null == customHeaders ? _self.customHeaders : customHeaders // ignore: cast_nullable_to_non_nullable
as Map<String, String>,useCustomModel: null == useCustomModel ? _self.useCustomModel : useCustomModel // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AiSettings].
extension AiSettingsPatterns on AiSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiSettings value)  $default,){
final _that = this;
switch (_that) {
case _AiSettings():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiSettings value)?  $default,){
final _that = this;
switch (_that) {
case _AiSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AiModelProvider provider,  String apiKey,  String model,  String baseUrl,  bool showAiBubble,  bool includeCustomHeaders,  Map<String, String> customHeaders,  bool useCustomModel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiSettings() when $default != null:
return $default(_that.provider,_that.apiKey,_that.model,_that.baseUrl,_that.showAiBubble,_that.includeCustomHeaders,_that.customHeaders,_that.useCustomModel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AiModelProvider provider,  String apiKey,  String model,  String baseUrl,  bool showAiBubble,  bool includeCustomHeaders,  Map<String, String> customHeaders,  bool useCustomModel)  $default,) {final _that = this;
switch (_that) {
case _AiSettings():
return $default(_that.provider,_that.apiKey,_that.model,_that.baseUrl,_that.showAiBubble,_that.includeCustomHeaders,_that.customHeaders,_that.useCustomModel);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AiModelProvider provider,  String apiKey,  String model,  String baseUrl,  bool showAiBubble,  bool includeCustomHeaders,  Map<String, String> customHeaders,  bool useCustomModel)?  $default,) {final _that = this;
switch (_that) {
case _AiSettings() when $default != null:
return $default(_that.provider,_that.apiKey,_that.model,_that.baseUrl,_that.showAiBubble,_that.includeCustomHeaders,_that.customHeaders,_that.useCustomModel);case _:
  return null;

}
}

}

/// @nodoc


class _AiSettings implements AiSettings {
  const _AiSettings({this.provider = AiModelProvider.googleAi, this.apiKey = '', this.model = kDefaultAiModel, this.baseUrl = 'https://generativelanguage.googleapis.com', this.showAiBubble = true, this.includeCustomHeaders = false,  Map<String, String> customHeaders = const <String, String>{}, this.useCustomModel = false}): _customHeaders = customHeaders;
  

@override@JsonKey() final  AiModelProvider provider;
@override@JsonKey() final  String apiKey;
@override@JsonKey() final  String model;
@override@JsonKey() final  String baseUrl;
@override@JsonKey() final  bool showAiBubble;
@override@JsonKey() final  bool includeCustomHeaders;
 final  Map<String, String> _customHeaders;
@override@JsonKey() Map<String, String> get customHeaders {
  if (_customHeaders is EqualUnmodifiableMapView) return _customHeaders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_customHeaders);
}

@override@JsonKey() final  bool useCustomModel;

/// Create a copy of AiSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiSettingsCopyWith<_AiSettings> get copyWith => __$AiSettingsCopyWithImpl<_AiSettings>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiSettings&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.apiKey, apiKey) || other.apiKey == apiKey)&&(identical(other.model, model) || other.model == model)&&(identical(other.baseUrl, baseUrl) || other.baseUrl == baseUrl)&&(identical(other.showAiBubble, showAiBubble) || other.showAiBubble == showAiBubble)&&(identical(other.includeCustomHeaders, includeCustomHeaders) || other.includeCustomHeaders == includeCustomHeaders)&&const DeepCollectionEquality().equals(other.customHeaders, _customHeaders)&&(identical(other.useCustomModel, useCustomModel) || other.useCustomModel == useCustomModel));
}


@override
int get hashCode {
    return Object.hash(runtimeType,provider,apiKey,model,baseUrl,showAiBubble,includeCustomHeaders,const DeepCollectionEquality().hash(_customHeaders),useCustomModel);
}

@override
String toString() {
    return 'AiSettings(provider: $provider, apiKey: $apiKey, model: $model, baseUrl: $baseUrl, showAiBubble: $showAiBubble, includeCustomHeaders: $includeCustomHeaders, customHeaders: $customHeaders, useCustomModel: $useCustomModel)';
}


}

/// @nodoc
abstract mixin class _$AiSettingsCopyWith<$Res> implements $AiSettingsCopyWith<$Res> {
  factory _$AiSettingsCopyWith(_AiSettings value, $Res Function(_AiSettings) _then) = __$AiSettingsCopyWithImpl;
@override @useResult
$Res call({
 AiModelProvider provider, String apiKey, String model, String baseUrl, bool showAiBubble, bool includeCustomHeaders, Map<String, String> customHeaders, bool useCustomModel
});




}
/// @nodoc
class __$AiSettingsCopyWithImpl<$Res>
    implements _$AiSettingsCopyWith<$Res> {
  __$AiSettingsCopyWithImpl(this._self, this._then);

  final _AiSettings _self;
  final $Res Function(_AiSettings) _then;

/// Create a copy of AiSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? provider = null,Object? apiKey = null,Object? model = null,Object? baseUrl = null,Object? showAiBubble = null,Object? includeCustomHeaders = null,Object? customHeaders = null,Object? useCustomModel = null,}) {
  return _then(_AiSettings(
provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as AiModelProvider,apiKey: null == apiKey ? _self.apiKey : apiKey // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,baseUrl: null == baseUrl ? _self.baseUrl : baseUrl // ignore: cast_nullable_to_non_nullable
as String,showAiBubble: null == showAiBubble ? _self.showAiBubble : showAiBubble // ignore: cast_nullable_to_non_nullable
as bool,includeCustomHeaders: null == includeCustomHeaders ? _self.includeCustomHeaders : includeCustomHeaders // ignore: cast_nullable_to_non_nullable
as bool,customHeaders: null == customHeaders ? _self._customHeaders : customHeaders // ignore: cast_nullable_to_non_nullable
as Map<String, String>,useCustomModel: null == useCustomModel ? _self.useCustomModel : useCustomModel // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
