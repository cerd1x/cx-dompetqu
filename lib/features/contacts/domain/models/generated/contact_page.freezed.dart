// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../contact_page.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ContactPage {

 List<Contact> get items; bool get hasNextPage; String? get nextCursor;
/// Create a copy of ContactPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContactPageCopyWith<ContactPage> get copyWith => _$ContactPageCopyWithImpl<ContactPage>(this as ContactPage, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ContactPage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContactPage&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.hasNextPage, _this.hasNextPage) || other.hasNextPage == _this.hasNextPage)&&(identical(other.nextCursor, _this.nextCursor) || other.nextCursor == _this.nextCursor));
}


@override
int get hashCode {
  final _this = this as ContactPage;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items),_this.hasNextPage,_this.nextCursor);
}

@override
String toString() {
  final _this = this as ContactPage;
  return 'ContactPage(items: ${_this.items}, hasNextPage: ${_this.hasNextPage}, nextCursor: ${_this.nextCursor})';
}


}

/// @nodoc
abstract mixin class $ContactPageCopyWith<$Res>  {
  factory $ContactPageCopyWith(ContactPage value, $Res Function(ContactPage) _then) = _$ContactPageCopyWithImpl;
@useResult
$Res call({
 List<Contact> items, bool hasNextPage, String? nextCursor
});




}
/// @nodoc
class _$ContactPageCopyWithImpl<$Res>
    implements $ContactPageCopyWith<$Res> {
  _$ContactPageCopyWithImpl(this._self, this._then);

  final ContactPage _self;
  final $Res Function(ContactPage) _then;

/// Create a copy of ContactPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? hasNextPage = null,Object? nextCursor = freezed,}) {
  return _then(ContactPage(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<Contact>,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ContactPage].
extension ContactPagePatterns on ContactPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContactPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContactPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContactPage value)  $default,){
final _that = this;
switch (_that) {
case _ContactPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContactPage value)?  $default,){
final _that = this;
switch (_that) {
case _ContactPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Contact> items,  bool hasNextPage,  String? nextCursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContactPage() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Contact> items,  bool hasNextPage,  String? nextCursor)  $default,) {final _that = this;
switch (_that) {
case _ContactPage():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Contact> items,  bool hasNextPage,  String? nextCursor)?  $default,) {final _that = this;
switch (_that) {
case _ContactPage() when $default != null:
return $default(_that.items,_that.hasNextPage,_that.nextCursor);case _:
  return null;

}
}

}

/// @nodoc


class _ContactPage extends ContactPage {
  const _ContactPage({required  List<Contact> items, required this.hasNextPage, required this.nextCursor}): _items = items,super._();
  

 final  List<Contact> _items;
@override List<Contact> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  bool hasNextPage;
@override final  String? nextCursor;

/// Create a copy of ContactPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContactPageCopyWith<_ContactPage> get copyWith => __$ContactPageCopyWithImpl<_ContactPage>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContactPage&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),hasNextPage,nextCursor);
}

@override
String toString() {
    return 'ContactPage(items: $items, hasNextPage: $hasNextPage, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$ContactPageCopyWith<$Res> implements $ContactPageCopyWith<$Res> {
  factory _$ContactPageCopyWith(_ContactPage value, $Res Function(_ContactPage) _then) = __$ContactPageCopyWithImpl;
@override @useResult
$Res call({
 List<Contact> items, bool hasNextPage, String? nextCursor
});




}
/// @nodoc
class __$ContactPageCopyWithImpl<$Res>
    implements _$ContactPageCopyWith<$Res> {
  __$ContactPageCopyWithImpl(this._self, this._then);

  final _ContactPage _self;
  final $Res Function(_ContactPage) _then;

/// Create a copy of ContactPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? hasNextPage = null,Object? nextCursor = freezed,}) {
  return _then(_ContactPage(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Contact>,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
