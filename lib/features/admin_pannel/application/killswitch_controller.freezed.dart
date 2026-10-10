// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'killswitch_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$KillswitchState {

/// Daftar operation yang sedang dimatikan.
 List<KillswitchEntry> get entries;/// `true` saat memuat daftar (pertama kali / refresh).
 bool get loading;/// `true` saat operasi disable/enable sedang berjalan.
 bool get mutating;/// Pesan error terakhir (untuk ditampilkan di UI).
 String? get error;
/// Create a copy of KillswitchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KillswitchStateCopyWith<KillswitchState> get copyWith => _$KillswitchStateCopyWithImpl<KillswitchState>(this as KillswitchState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as KillswitchState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KillswitchState&&const DeepCollectionEquality().equals(other.entries, _this.entries)&&(identical(other.loading, _this.loading) || other.loading == _this.loading)&&(identical(other.mutating, _this.mutating) || other.mutating == _this.mutating)&&(identical(other.error, _this.error) || other.error == _this.error));
}


@override
int get hashCode {
  final _this = this as KillswitchState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.entries),_this.loading,_this.mutating,_this.error);
}

@override
String toString() {
  final _this = this as KillswitchState;
  return 'KillswitchState(entries: ${_this.entries}, loading: ${_this.loading}, mutating: ${_this.mutating}, error: ${_this.error})';
}


}

/// @nodoc
abstract mixin class $KillswitchStateCopyWith<$Res>  {
  factory $KillswitchStateCopyWith(KillswitchState value, $Res Function(KillswitchState) _then) = _$KillswitchStateCopyWithImpl;
@useResult
$Res call({
 List<KillswitchEntry> entries, bool loading, bool mutating, String? error
});




}
/// @nodoc
class _$KillswitchStateCopyWithImpl<$Res>
    implements $KillswitchStateCopyWith<$Res> {
  _$KillswitchStateCopyWithImpl(this._self, this._then);

  final KillswitchState _self;
  final $Res Function(KillswitchState) _then;

/// Create a copy of KillswitchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? entries = null,Object? loading = null,Object? mutating = null,Object? error = freezed,}) {
  return _then(KillswitchState(
entries: null == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as List<KillswitchEntry>,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,mutating: null == mutating ? _self.mutating : mutating // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [KillswitchState].
extension KillswitchStatePatterns on KillswitchState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KillswitchState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KillswitchState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KillswitchState value)  $default,){
final _that = this;
switch (_that) {
case _KillswitchState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KillswitchState value)?  $default,){
final _that = this;
switch (_that) {
case _KillswitchState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<KillswitchEntry> entries,  bool loading,  bool mutating,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KillswitchState() when $default != null:
return $default(_that.entries,_that.loading,_that.mutating,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<KillswitchEntry> entries,  bool loading,  bool mutating,  String? error)  $default,) {final _that = this;
switch (_that) {
case _KillswitchState():
return $default(_that.entries,_that.loading,_that.mutating,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<KillswitchEntry> entries,  bool loading,  bool mutating,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _KillswitchState() when $default != null:
return $default(_that.entries,_that.loading,_that.mutating,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _KillswitchState implements KillswitchState {
  const _KillswitchState({ List<KillswitchEntry> entries = const [], this.loading = true, this.mutating = false, this.error}): _entries = entries;
  

/// Daftar operation yang sedang dimatikan.
 final  List<KillswitchEntry> _entries;
/// Daftar operation yang sedang dimatikan.
@override@JsonKey() List<KillswitchEntry> get entries {
  if (_entries is EqualUnmodifiableListView) return _entries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_entries);
}

/// `true` saat memuat daftar (pertama kali / refresh).
@override@JsonKey() final  bool loading;
/// `true` saat operasi disable/enable sedang berjalan.
@override@JsonKey() final  bool mutating;
/// Pesan error terakhir (untuk ditampilkan di UI).
@override final  String? error;

/// Create a copy of KillswitchState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KillswitchStateCopyWith<_KillswitchState> get copyWith => __$KillswitchStateCopyWithImpl<_KillswitchState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _KillswitchState&&const DeepCollectionEquality().equals(other.entries, _entries)&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.mutating, mutating) || other.mutating == mutating)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_entries),loading,mutating,error);
}

@override
String toString() {
    return 'KillswitchState(entries: $entries, loading: $loading, mutating: $mutating, error: $error)';
}


}

/// @nodoc
abstract mixin class _$KillswitchStateCopyWith<$Res> implements $KillswitchStateCopyWith<$Res> {
  factory _$KillswitchStateCopyWith(_KillswitchState value, $Res Function(_KillswitchState) _then) = __$KillswitchStateCopyWithImpl;
@override @useResult
$Res call({
 List<KillswitchEntry> entries, bool loading, bool mutating, String? error
});




}
/// @nodoc
class __$KillswitchStateCopyWithImpl<$Res>
    implements _$KillswitchStateCopyWith<$Res> {
  __$KillswitchStateCopyWithImpl(this._self, this._then);

  final _KillswitchState _self;
  final $Res Function(_KillswitchState) _then;

/// Create a copy of KillswitchState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? entries = null,Object? loading = null,Object? mutating = null,Object? error = freezed,}) {
  return _then(_KillswitchState(
entries: null == entries ? _self._entries : entries // ignore: cast_nullable_to_non_nullable
as List<KillswitchEntry>,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,mutating: null == mutating ? _self.mutating : mutating // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
