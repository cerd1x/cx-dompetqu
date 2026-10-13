// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'statistics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Statistics {

 num get totalIncome; num get totalExpense; num get totalProfit; num get totalLoan; num get totalCash; num get totalAsset;
/// Create a copy of Statistics
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StatisticsCopyWith<Statistics> get copyWith => _$StatisticsCopyWithImpl<Statistics>(this as Statistics, _$identity);

  /// Serializes this Statistics to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Statistics;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Statistics&&(identical(other.totalIncome, _this.totalIncome) || other.totalIncome == _this.totalIncome)&&(identical(other.totalExpense, _this.totalExpense) || other.totalExpense == _this.totalExpense)&&(identical(other.totalProfit, _this.totalProfit) || other.totalProfit == _this.totalProfit)&&(identical(other.totalLoan, _this.totalLoan) || other.totalLoan == _this.totalLoan)&&(identical(other.totalCash, _this.totalCash) || other.totalCash == _this.totalCash)&&(identical(other.totalAsset, _this.totalAsset) || other.totalAsset == _this.totalAsset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Statistics;
  return Object.hash(runtimeType,_this.totalIncome,_this.totalExpense,_this.totalProfit,_this.totalLoan,_this.totalCash,_this.totalAsset);
}

@override
String toString() {
  final _this = this as Statistics;
  return 'Statistics(totalIncome: ${_this.totalIncome}, totalExpense: ${_this.totalExpense}, totalProfit: ${_this.totalProfit}, totalLoan: ${_this.totalLoan}, totalCash: ${_this.totalCash}, totalAsset: ${_this.totalAsset})';
}


}

/// @nodoc
abstract mixin class $StatisticsCopyWith<$Res>  {
  factory $StatisticsCopyWith(Statistics value, $Res Function(Statistics) _then) = _$StatisticsCopyWithImpl;
@useResult
$Res call({
 num totalIncome, num totalExpense, num totalProfit, num totalLoan, num totalCash, num totalAsset
});




}
/// @nodoc
class _$StatisticsCopyWithImpl<$Res>
    implements $StatisticsCopyWith<$Res> {
  _$StatisticsCopyWithImpl(this._self, this._then);

  final Statistics _self;
  final $Res Function(Statistics) _then;

/// Create a copy of Statistics
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalIncome = null,Object? totalExpense = null,Object? totalProfit = null,Object? totalLoan = null,Object? totalCash = null,Object? totalAsset = null,}) {
  return _then(Statistics(
totalIncome: null == totalIncome ? _self.totalIncome : totalIncome // ignore: cast_nullable_to_non_nullable
as num,totalExpense: null == totalExpense ? _self.totalExpense : totalExpense // ignore: cast_nullable_to_non_nullable
as num,totalProfit: null == totalProfit ? _self.totalProfit : totalProfit // ignore: cast_nullable_to_non_nullable
as num,totalLoan: null == totalLoan ? _self.totalLoan : totalLoan // ignore: cast_nullable_to_non_nullable
as num,totalCash: null == totalCash ? _self.totalCash : totalCash // ignore: cast_nullable_to_non_nullable
as num,totalAsset: null == totalAsset ? _self.totalAsset : totalAsset // ignore: cast_nullable_to_non_nullable
as num,
  ));
}

}


/// Adds pattern-matching-related methods to [Statistics].
extension StatisticsPatterns on Statistics {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Statistics value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Statistics() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Statistics value)  $default,){
final _that = this;
switch (_that) {
case _Statistics():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Statistics value)?  $default,){
final _that = this;
switch (_that) {
case _Statistics() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( num totalIncome,  num totalExpense,  num totalProfit,  num totalLoan,  num totalCash,  num totalAsset)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Statistics() when $default != null:
return $default(_that.totalIncome,_that.totalExpense,_that.totalProfit,_that.totalLoan,_that.totalCash,_that.totalAsset);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( num totalIncome,  num totalExpense,  num totalProfit,  num totalLoan,  num totalCash,  num totalAsset)  $default,) {final _that = this;
switch (_that) {
case _Statistics():
return $default(_that.totalIncome,_that.totalExpense,_that.totalProfit,_that.totalLoan,_that.totalCash,_that.totalAsset);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( num totalIncome,  num totalExpense,  num totalProfit,  num totalLoan,  num totalCash,  num totalAsset)?  $default,) {final _that = this;
switch (_that) {
case _Statistics() when $default != null:
return $default(_that.totalIncome,_that.totalExpense,_that.totalProfit,_that.totalLoan,_that.totalCash,_that.totalAsset);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Statistics implements Statistics {
  const _Statistics({this.totalIncome = 0, this.totalExpense = 0, this.totalProfit = 0, this.totalLoan = 0, this.totalCash = 0, this.totalAsset = 0});
  factory _Statistics.fromJson(Map<String, dynamic> json) => _$StatisticsFromJson(json);

@override@JsonKey() final  num totalIncome;
@override@JsonKey() final  num totalExpense;
@override@JsonKey() final  num totalProfit;
@override@JsonKey() final  num totalLoan;
@override@JsonKey() final  num totalCash;
@override@JsonKey() final  num totalAsset;

/// Create a copy of Statistics
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StatisticsCopyWith<_Statistics> get copyWith => __$StatisticsCopyWithImpl<_Statistics>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StatisticsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Statistics&&(identical(other.totalIncome, totalIncome) || other.totalIncome == totalIncome)&&(identical(other.totalExpense, totalExpense) || other.totalExpense == totalExpense)&&(identical(other.totalProfit, totalProfit) || other.totalProfit == totalProfit)&&(identical(other.totalLoan, totalLoan) || other.totalLoan == totalLoan)&&(identical(other.totalCash, totalCash) || other.totalCash == totalCash)&&(identical(other.totalAsset, totalAsset) || other.totalAsset == totalAsset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,totalIncome,totalExpense,totalProfit,totalLoan,totalCash,totalAsset);
}

@override
String toString() {
    return 'Statistics(totalIncome: $totalIncome, totalExpense: $totalExpense, totalProfit: $totalProfit, totalLoan: $totalLoan, totalCash: $totalCash, totalAsset: $totalAsset)';
}


}

/// @nodoc
abstract mixin class _$StatisticsCopyWith<$Res> implements $StatisticsCopyWith<$Res> {
  factory _$StatisticsCopyWith(_Statistics value, $Res Function(_Statistics) _then) = __$StatisticsCopyWithImpl;
@override @useResult
$Res call({
 num totalIncome, num totalExpense, num totalProfit, num totalLoan, num totalCash, num totalAsset
});




}
/// @nodoc
class __$StatisticsCopyWithImpl<$Res>
    implements _$StatisticsCopyWith<$Res> {
  __$StatisticsCopyWithImpl(this._self, this._then);

  final _Statistics _self;
  final $Res Function(_Statistics) _then;

/// Create a copy of Statistics
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalIncome = null,Object? totalExpense = null,Object? totalProfit = null,Object? totalLoan = null,Object? totalCash = null,Object? totalAsset = null,}) {
  return _then(_Statistics(
totalIncome: null == totalIncome ? _self.totalIncome : totalIncome // ignore: cast_nullable_to_non_nullable
as num,totalExpense: null == totalExpense ? _self.totalExpense : totalExpense // ignore: cast_nullable_to_non_nullable
as num,totalProfit: null == totalProfit ? _self.totalProfit : totalProfit // ignore: cast_nullable_to_non_nullable
as num,totalLoan: null == totalLoan ? _self.totalLoan : totalLoan // ignore: cast_nullable_to_non_nullable
as num,totalCash: null == totalCash ? _self.totalCash : totalCash // ignore: cast_nullable_to_non_nullable
as num,totalAsset: null == totalAsset ? _self.totalAsset : totalAsset // ignore: cast_nullable_to_non_nullable
as num,
  ));
}


}

// dart format on
