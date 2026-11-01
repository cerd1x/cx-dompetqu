// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../transaction_page.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TransactionPage {

 List<Transaction> get items; bool get hasNextPage; String? get nextCursor;
/// Create a copy of TransactionPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionPageCopyWith<TransactionPage> get copyWith => _$TransactionPageCopyWithImpl<TransactionPage>(this as TransactionPage, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TransactionPage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionPage&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.hasNextPage, _this.hasNextPage) || other.hasNextPage == _this.hasNextPage)&&(identical(other.nextCursor, _this.nextCursor) || other.nextCursor == _this.nextCursor));
}


@override
int get hashCode {
  final _this = this as TransactionPage;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items),_this.hasNextPage,_this.nextCursor);
}

@override
String toString() {
  final _this = this as TransactionPage;
  return 'TransactionPage(items: ${_this.items}, hasNextPage: ${_this.hasNextPage}, nextCursor: ${_this.nextCursor})';
}


}

/// @nodoc
abstract mixin class $TransactionPageCopyWith<$Res>  {
  factory $TransactionPageCopyWith(TransactionPage value, $Res Function(TransactionPage) _then) = _$TransactionPageCopyWithImpl;
@useResult
$Res call({
 List<Transaction> items, bool hasNextPage, String? nextCursor
});




}
/// @nodoc
class _$TransactionPageCopyWithImpl<$Res>
    implements $TransactionPageCopyWith<$Res> {
  _$TransactionPageCopyWithImpl(this._self, this._then);

  final TransactionPage _self;
  final $Res Function(TransactionPage) _then;

/// Create a copy of TransactionPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? hasNextPage = null,Object? nextCursor = freezed,}) {
  return _then(TransactionPage(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<Transaction>,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionPage].
extension TransactionPagePatterns on TransactionPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionPage value)  $default,){
final _that = this;
switch (_that) {
case _TransactionPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionPage value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Transaction> items,  bool hasNextPage,  String? nextCursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionPage() when $default != null:
return $default(_that.items,_that.hasNextPage,_that.nextCursor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Transaction> items,  bool hasNextPage,  String? nextCursor)  $default,) {final _that = this;
switch (_that) {
case _TransactionPage():
return $default(_that.items,_that.hasNextPage,_that.nextCursor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Transaction> items,  bool hasNextPage,  String? nextCursor)?  $default,) {final _that = this;
switch (_that) {
case _TransactionPage() when $default != null:
return $default(_that.items,_that.hasNextPage,_that.nextCursor);case _:
  return null;

}
}

}

/// @nodoc


class _TransactionPage extends TransactionPage {
  const _TransactionPage({required  List<Transaction> items, required this.hasNextPage, required this.nextCursor}): _items = items,super._();
  

 final  List<Transaction> _items;
@override List<Transaction> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  bool hasNextPage;
@override final  String? nextCursor;

/// Create a copy of TransactionPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionPageCopyWith<_TransactionPage> get copyWith => __$TransactionPageCopyWithImpl<_TransactionPage>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionPage&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),hasNextPage,nextCursor);
}

@override
String toString() {
    return 'TransactionPage(items: $items, hasNextPage: $hasNextPage, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$TransactionPageCopyWith<$Res> implements $TransactionPageCopyWith<$Res> {
  factory _$TransactionPageCopyWith(_TransactionPage value, $Res Function(_TransactionPage) _then) = __$TransactionPageCopyWithImpl;
@override @useResult
$Res call({
 List<Transaction> items, bool hasNextPage, String? nextCursor
});




}
/// @nodoc
class __$TransactionPageCopyWithImpl<$Res>
    implements _$TransactionPageCopyWith<$Res> {
  __$TransactionPageCopyWithImpl(this._self, this._then);

  final _TransactionPage _self;
  final $Res Function(_TransactionPage) _then;

/// Create a copy of TransactionPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? hasNextPage = null,Object? nextCursor = freezed,}) {
  return _then(_TransactionPage(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Transaction>,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
