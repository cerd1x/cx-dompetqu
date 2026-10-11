// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AiState {

 List<AiMessage> get messages; bool get sending;
/// Create a copy of AiState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiStateCopyWith<AiState> get copyWith => _$AiStateCopyWithImpl<AiState>(this as AiState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AiState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiState&&const DeepCollectionEquality().equals(other.messages, _this.messages)&&(identical(other.sending, _this.sending) || other.sending == _this.sending));
}


@override
int get hashCode {
  final _this = this as AiState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.messages),_this.sending);
}

@override
String toString() {
  final _this = this as AiState;
  return 'AiState(messages: ${_this.messages}, sending: ${_this.sending})';
}


}

/// @nodoc
abstract mixin class $AiStateCopyWith<$Res>  {
  factory $AiStateCopyWith(AiState value, $Res Function(AiState) _then) = _$AiStateCopyWithImpl;
@useResult
$Res call({
 List<AiMessage> messages, bool sending
});




}
/// @nodoc
class _$AiStateCopyWithImpl<$Res>
    implements $AiStateCopyWith<$Res> {
  _$AiStateCopyWithImpl(this._self, this._then);

  final AiState _self;
  final $Res Function(AiState) _then;

/// Create a copy of AiState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? messages = null,Object? sending = null,}) {
  return _then(AiState(
messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<AiMessage>,sending: null == sending ? _self.sending : sending // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AiState].
extension AiStatePatterns on AiState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiState value)  $default,){
final _that = this;
switch (_that) {
case _AiState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiState value)?  $default,){
final _that = this;
switch (_that) {
case _AiState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<AiMessage> messages,  bool sending)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiState() when $default != null:
return $default(_that.messages,_that.sending);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<AiMessage> messages,  bool sending)  $default,) {final _that = this;
switch (_that) {
case _AiState():
return $default(_that.messages,_that.sending);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<AiMessage> messages,  bool sending)?  $default,) {final _that = this;
switch (_that) {
case _AiState() when $default != null:
return $default(_that.messages,_that.sending);case _:
  return null;

}
}

}

/// @nodoc


class _AiState implements AiState {
  const _AiState({ List<AiMessage> messages = const [], this.sending = false}): _messages = messages;
  

 final  List<AiMessage> _messages;
@override@JsonKey() List<AiMessage> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}

@override@JsonKey() final  bool sending;

/// Create a copy of AiState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiStateCopyWith<_AiState> get copyWith => __$AiStateCopyWithImpl<_AiState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiState&&const DeepCollectionEquality().equals(other.messages, _messages)&&(identical(other.sending, sending) || other.sending == sending));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_messages),sending);
}

@override
String toString() {
    return 'AiState(messages: $messages, sending: $sending)';
}


}

/// @nodoc
abstract mixin class _$AiStateCopyWith<$Res> implements $AiStateCopyWith<$Res> {
  factory _$AiStateCopyWith(_AiState value, $Res Function(_AiState) _then) = __$AiStateCopyWithImpl;
@override @useResult
$Res call({
 List<AiMessage> messages, bool sending
});




}
/// @nodoc
class __$AiStateCopyWithImpl<$Res>
    implements _$AiStateCopyWith<$Res> {
  __$AiStateCopyWithImpl(this._self, this._then);

  final _AiState _self;
  final $Res Function(_AiState) _then;

/// Create a copy of AiState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? messages = null,Object? sending = null,}) {
  return _then(_AiState(
messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<AiMessage>,sending: null == sending ? _self.sending : sending // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
