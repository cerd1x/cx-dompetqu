// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../finance_overview_store.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FinanceOverviewState implements DiagnosticableTreeMixin {

 List<Transaction> get transactions; List<Payment> get payments; bool get loading; String? get error;
/// Create a copy of FinanceOverviewState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FinanceOverviewStateCopyWith<FinanceOverviewState> get copyWith => _$FinanceOverviewStateCopyWithImpl<FinanceOverviewState>(this as FinanceOverviewState, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  final _this = this as FinanceOverviewState;
  properties
    ..add(DiagnosticsProperty('type', 'FinanceOverviewState'))
    ..add(DiagnosticsProperty('transactions', _this.transactions))..add(DiagnosticsProperty('payments', _this.payments))..add(DiagnosticsProperty('loading', _this.loading))..add(DiagnosticsProperty('error', _this.error));
}

@override
bool operator ==(Object other) {
  final _this = this as FinanceOverviewState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FinanceOverviewState&&const DeepCollectionEquality().equals(other.transactions, _this.transactions)&&const DeepCollectionEquality().equals(other.payments, _this.payments)&&(identical(other.loading, _this.loading) || other.loading == _this.loading)&&(identical(other.error, _this.error) || other.error == _this.error));
}


@override
int get hashCode {
  final _this = this as FinanceOverviewState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.transactions),const DeepCollectionEquality().hash(_this.payments),_this.loading,_this.error);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  final _this = this as FinanceOverviewState;
  return 'FinanceOverviewState(transactions: ${_this.transactions}, payments: ${_this.payments}, loading: ${_this.loading}, error: ${_this.error})';
}


}

/// @nodoc
abstract mixin class $FinanceOverviewStateCopyWith<$Res>  {
  factory $FinanceOverviewStateCopyWith(FinanceOverviewState value, $Res Function(FinanceOverviewState) _then) = _$FinanceOverviewStateCopyWithImpl;
@useResult
$Res call({
 List<Transaction> transactions, List<Payment> payments, bool loading, String? error
});




}
/// @nodoc
class _$FinanceOverviewStateCopyWithImpl<$Res>
    implements $FinanceOverviewStateCopyWith<$Res> {
  _$FinanceOverviewStateCopyWithImpl(this._self, this._then);

  final FinanceOverviewState _self;
  final $Res Function(FinanceOverviewState) _then;

/// Create a copy of FinanceOverviewState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? transactions = null,Object? payments = null,Object? loading = null,Object? error = freezed,}) {
  return _then(FinanceOverviewState(
transactions: null == transactions ? _self.transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<Transaction>,payments: null == payments ? _self.payments : payments // ignore: cast_nullable_to_non_nullable
as List<Payment>,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FinanceOverviewState].
extension FinanceOverviewStatePatterns on FinanceOverviewState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FinanceOverviewState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FinanceOverviewState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FinanceOverviewState value)  $default,){
final _that = this;
switch (_that) {
case _FinanceOverviewState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FinanceOverviewState value)?  $default,){
final _that = this;
switch (_that) {
case _FinanceOverviewState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Transaction> transactions,  List<Payment> payments,  bool loading,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FinanceOverviewState() when $default != null:
return $default(_that.transactions,_that.payments,_that.loading,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Transaction> transactions,  List<Payment> payments,  bool loading,  String? error)  $default,) {final _that = this;
switch (_that) {
case _FinanceOverviewState():
return $default(_that.transactions,_that.payments,_that.loading,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Transaction> transactions,  List<Payment> payments,  bool loading,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _FinanceOverviewState() when $default != null:
return $default(_that.transactions,_that.payments,_that.loading,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _FinanceOverviewState with DiagnosticableTreeMixin implements FinanceOverviewState {
  const _FinanceOverviewState({ List<Transaction> transactions = const [],  List<Payment> payments = const [], this.loading = true, this.error}): _transactions = transactions,_payments = payments;
  

 final  List<Transaction> _transactions;
@override@JsonKey() List<Transaction> get transactions {
  if (_transactions is EqualUnmodifiableListView) return _transactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_transactions);
}

 final  List<Payment> _payments;
@override@JsonKey() List<Payment> get payments {
  if (_payments is EqualUnmodifiableListView) return _payments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_payments);
}

@override@JsonKey() final  bool loading;
@override final  String? error;

/// Create a copy of FinanceOverviewState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FinanceOverviewStateCopyWith<_FinanceOverviewState> get copyWith => __$FinanceOverviewStateCopyWithImpl<_FinanceOverviewState>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'FinanceOverviewState'))
    ..add(DiagnosticsProperty('transactions', transactions))..add(DiagnosticsProperty('payments', payments))..add(DiagnosticsProperty('loading', loading))..add(DiagnosticsProperty('error', error));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FinanceOverviewState&&const DeepCollectionEquality().equals(other.transactions, _transactions)&&const DeepCollectionEquality().equals(other.payments, _payments)&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_transactions),const DeepCollectionEquality().hash(_payments),loading,error);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'FinanceOverviewState(transactions: $transactions, payments: $payments, loading: $loading, error: $error)';
}


}

/// @nodoc
abstract mixin class _$FinanceOverviewStateCopyWith<$Res> implements $FinanceOverviewStateCopyWith<$Res> {
  factory _$FinanceOverviewStateCopyWith(_FinanceOverviewState value, $Res Function(_FinanceOverviewState) _then) = __$FinanceOverviewStateCopyWithImpl;
@override @useResult
$Res call({
 List<Transaction> transactions, List<Payment> payments, bool loading, String? error
});




}
/// @nodoc
class __$FinanceOverviewStateCopyWithImpl<$Res>
    implements _$FinanceOverviewStateCopyWith<$Res> {
  __$FinanceOverviewStateCopyWithImpl(this._self, this._then);

  final _FinanceOverviewState _self;
  final $Res Function(_FinanceOverviewState) _then;

/// Create a copy of FinanceOverviewState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? transactions = null,Object? payments = null,Object? loading = null,Object? error = freezed,}) {
  return _then(_FinanceOverviewState(
transactions: null == transactions ? _self._transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<Transaction>,payments: null == payments ? _self._payments : payments // ignore: cast_nullable_to_non_nullable
as List<Payment>,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
