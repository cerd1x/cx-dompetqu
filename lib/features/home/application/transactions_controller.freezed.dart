// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transactions_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TransactionsState {

 List<Transaction> get items; bool get loading; String? get error; int get pageSize; String? get nextCursor; bool get hasMore; bool get loadingMore;
/// Create a copy of TransactionsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionsStateCopyWith<TransactionsState> get copyWith => _$TransactionsStateCopyWithImpl<TransactionsState>(this as TransactionsState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TransactionsState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionsState&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.loading, _this.loading) || other.loading == _this.loading)&&(identical(other.error, _this.error) || other.error == _this.error)&&(identical(other.pageSize, _this.pageSize) || other.pageSize == _this.pageSize)&&(identical(other.nextCursor, _this.nextCursor) || other.nextCursor == _this.nextCursor)&&(identical(other.hasMore, _this.hasMore) || other.hasMore == _this.hasMore)&&(identical(other.loadingMore, _this.loadingMore) || other.loadingMore == _this.loadingMore));
}


@override
int get hashCode {
  final _this = this as TransactionsState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items),_this.loading,_this.error,_this.pageSize,_this.nextCursor,_this.hasMore,_this.loadingMore);
}

@override
String toString() {
  final _this = this as TransactionsState;
  return 'TransactionsState(items: ${_this.items}, loading: ${_this.loading}, error: ${_this.error}, pageSize: ${_this.pageSize}, nextCursor: ${_this.nextCursor}, hasMore: ${_this.hasMore}, loadingMore: ${_this.loadingMore})';
}


}

/// @nodoc
abstract mixin class $TransactionsStateCopyWith<$Res>  {
  factory $TransactionsStateCopyWith(TransactionsState value, $Res Function(TransactionsState) _then) = _$TransactionsStateCopyWithImpl;
@useResult
$Res call({
 List<Transaction> items, bool loading, String? error, int pageSize, String? nextCursor, bool hasMore, bool loadingMore
});




}
/// @nodoc
class _$TransactionsStateCopyWithImpl<$Res>
    implements $TransactionsStateCopyWith<$Res> {
  _$TransactionsStateCopyWithImpl(this._self, this._then);

  final TransactionsState _self;
  final $Res Function(TransactionsState) _then;

/// Create a copy of TransactionsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? loading = null,Object? error = freezed,Object? pageSize = null,Object? nextCursor = freezed,Object? hasMore = null,Object? loadingMore = null,}) {
  return _then(TransactionsState(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<Transaction>,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,loadingMore: null == loadingMore ? _self.loadingMore : loadingMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionsState].
extension TransactionsStatePatterns on TransactionsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionsState value)  $default,){
final _that = this;
switch (_that) {
case _TransactionsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionsState value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Transaction> items,  bool loading,  String? error,  int pageSize,  String? nextCursor,  bool hasMore,  bool loadingMore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionsState() when $default != null:
return $default(_that.items,_that.loading,_that.error,_that.pageSize,_that.nextCursor,_that.hasMore,_that.loadingMore);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Transaction> items,  bool loading,  String? error,  int pageSize,  String? nextCursor,  bool hasMore,  bool loadingMore)  $default,) {final _that = this;
switch (_that) {
case _TransactionsState():
return $default(_that.items,_that.loading,_that.error,_that.pageSize,_that.nextCursor,_that.hasMore,_that.loadingMore);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Transaction> items,  bool loading,  String? error,  int pageSize,  String? nextCursor,  bool hasMore,  bool loadingMore)?  $default,) {final _that = this;
switch (_that) {
case _TransactionsState() when $default != null:
return $default(_that.items,_that.loading,_that.error,_that.pageSize,_that.nextCursor,_that.hasMore,_that.loadingMore);case _:
  return null;

}
}

}

/// @nodoc


class _TransactionsState implements TransactionsState {
  const _TransactionsState({ List<Transaction> items = const [], this.loading = true, this.error, this.pageSize = kTransactionsPageSize, this.nextCursor, this.hasMore = false, this.loadingMore = false}): _items = items;
  

 final  List<Transaction> _items;
@override@JsonKey() List<Transaction> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  bool loading;
@override final  String? error;
@override@JsonKey() final  int pageSize;
@override final  String? nextCursor;
@override@JsonKey() final  bool hasMore;
@override@JsonKey() final  bool loadingMore;

/// Create a copy of TransactionsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionsStateCopyWith<_TransactionsState> get copyWith => __$TransactionsStateCopyWithImpl<_TransactionsState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionsState&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.error, error) || other.error == error)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.loadingMore, loadingMore) || other.loadingMore == loadingMore));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),loading,error,pageSize,nextCursor,hasMore,loadingMore);
}

@override
String toString() {
    return 'TransactionsState(items: $items, loading: $loading, error: $error, pageSize: $pageSize, nextCursor: $nextCursor, hasMore: $hasMore, loadingMore: $loadingMore)';
}


}

/// @nodoc
abstract mixin class _$TransactionsStateCopyWith<$Res> implements $TransactionsStateCopyWith<$Res> {
  factory _$TransactionsStateCopyWith(_TransactionsState value, $Res Function(_TransactionsState) _then) = __$TransactionsStateCopyWithImpl;
@override @useResult
$Res call({
 List<Transaction> items, bool loading, String? error, int pageSize, String? nextCursor, bool hasMore, bool loadingMore
});




}
/// @nodoc
class __$TransactionsStateCopyWithImpl<$Res>
    implements _$TransactionsStateCopyWith<$Res> {
  __$TransactionsStateCopyWithImpl(this._self, this._then);

  final _TransactionsState _self;
  final $Res Function(_TransactionsState) _then;

/// Create a copy of TransactionsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? loading = null,Object? error = freezed,Object? pageSize = null,Object? nextCursor = freezed,Object? hasMore = null,Object? loadingMore = null,}) {
  return _then(_TransactionsState(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Transaction>,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,loadingMore: null == loadingMore ? _self.loadingMore : loadingMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
