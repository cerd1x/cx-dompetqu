// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../asset_mutation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AssetMutation {

 String get id; String get type; String get amount; String get currency; String get balanceBefore; String get balanceAfter; String? get description; DateTime? get createdAt;
/// Create a copy of AssetMutation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssetMutationCopyWith<AssetMutation> get copyWith => _$AssetMutationCopyWithImpl<AssetMutation>(this as AssetMutation, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AssetMutation;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssetMutation&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.balanceBefore, _this.balanceBefore) || other.balanceBefore == _this.balanceBefore)&&(identical(other.balanceAfter, _this.balanceAfter) || other.balanceAfter == _this.balanceAfter)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}


@override
int get hashCode {
  final _this = this as AssetMutation;
  return Object.hash(runtimeType,_this.id,_this.type,_this.amount,_this.currency,_this.balanceBefore,_this.balanceAfter,_this.description,_this.createdAt);
}

@override
String toString() {
  final _this = this as AssetMutation;
  return 'AssetMutation(id: ${_this.id}, type: ${_this.type}, amount: ${_this.amount}, currency: ${_this.currency}, balanceBefore: ${_this.balanceBefore}, balanceAfter: ${_this.balanceAfter}, description: ${_this.description}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $AssetMutationCopyWith<$Res>  {
  factory $AssetMutationCopyWith(AssetMutation value, $Res Function(AssetMutation) _then) = _$AssetMutationCopyWithImpl;
@useResult
$Res call({
 String id, String type, String amount, String currency, String balanceBefore, String balanceAfter, String? description, DateTime? createdAt
});




}
/// @nodoc
class _$AssetMutationCopyWithImpl<$Res>
    implements $AssetMutationCopyWith<$Res> {
  _$AssetMutationCopyWithImpl(this._self, this._then);

  final AssetMutation _self;
  final $Res Function(AssetMutation) _then;

/// Create a copy of AssetMutation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? amount = null,Object? currency = null,Object? balanceBefore = null,Object? balanceAfter = null,Object? description = freezed,Object? createdAt = freezed,}) {
  return _then(AssetMutation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,balanceBefore: null == balanceBefore ? _self.balanceBefore : balanceBefore // ignore: cast_nullable_to_non_nullable
as String,balanceAfter: null == balanceAfter ? _self.balanceAfter : balanceAfter // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AssetMutation].
extension AssetMutationPatterns on AssetMutation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssetMutation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssetMutation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssetMutation value)  $default,){
final _that = this;
switch (_that) {
case _AssetMutation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssetMutation value)?  $default,){
final _that = this;
switch (_that) {
case _AssetMutation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String type,  String amount,  String currency,  String balanceBefore,  String balanceAfter,  String? description,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssetMutation() when $default != null:
return $default(_that.id,_that.type,_that.amount,_that.currency,_that.balanceBefore,_that.balanceAfter,_that.description,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String type,  String amount,  String currency,  String balanceBefore,  String balanceAfter,  String? description,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _AssetMutation():
return $default(_that.id,_that.type,_that.amount,_that.currency,_that.balanceBefore,_that.balanceAfter,_that.description,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String type,  String amount,  String currency,  String balanceBefore,  String balanceAfter,  String? description,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _AssetMutation() when $default != null:
return $default(_that.id,_that.type,_that.amount,_that.currency,_that.balanceBefore,_that.balanceAfter,_that.description,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _AssetMutation extends AssetMutation {
  const _AssetMutation({required this.id, required this.type, required this.amount, required this.currency, required this.balanceBefore, required this.balanceAfter, required this.description, required this.createdAt}): super._();
  

@override final  String id;
@override final  String type;
@override final  String amount;
@override final  String currency;
@override final  String balanceBefore;
@override final  String balanceAfter;
@override final  String? description;
@override final  DateTime? createdAt;

/// Create a copy of AssetMutation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssetMutationCopyWith<_AssetMutation> get copyWith => __$AssetMutationCopyWithImpl<_AssetMutation>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssetMutation&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.balanceBefore, balanceBefore) || other.balanceBefore == balanceBefore)&&(identical(other.balanceAfter, balanceAfter) || other.balanceAfter == balanceAfter)&&(identical(other.description, description) || other.description == description)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,type,amount,currency,balanceBefore,balanceAfter,description,createdAt);
}

@override
String toString() {
    return 'AssetMutation(id: $id, type: $type, amount: $amount, currency: $currency, balanceBefore: $balanceBefore, balanceAfter: $balanceAfter, description: $description, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$AssetMutationCopyWith<$Res> implements $AssetMutationCopyWith<$Res> {
  factory _$AssetMutationCopyWith(_AssetMutation value, $Res Function(_AssetMutation) _then) = __$AssetMutationCopyWithImpl;
@override @useResult
$Res call({
 String id, String type, String amount, String currency, String balanceBefore, String balanceAfter, String? description, DateTime? createdAt
});




}
/// @nodoc
class __$AssetMutationCopyWithImpl<$Res>
    implements _$AssetMutationCopyWith<$Res> {
  __$AssetMutationCopyWithImpl(this._self, this._then);

  final _AssetMutation _self;
  final $Res Function(_AssetMutation) _then;

/// Create a copy of AssetMutation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? amount = null,Object? currency = null,Object? balanceBefore = null,Object? balanceAfter = null,Object? description = freezed,Object? createdAt = freezed,}) {
  return _then(_AssetMutation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,balanceBefore: null == balanceBefore ? _self.balanceBefore : balanceBefore // ignore: cast_nullable_to_non_nullable
as String,balanceAfter: null == balanceAfter ? _self.balanceAfter : balanceAfter // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
