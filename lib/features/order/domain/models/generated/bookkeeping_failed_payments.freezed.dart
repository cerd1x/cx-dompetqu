// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../bookkeeping_failed_payments.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BookkeepingFailedPaymentsResult {

 String get month; List<BookkeepingFailedPayment> get payments; int get totalCount; int get retryableCount;
/// Create a copy of BookkeepingFailedPaymentsResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookkeepingFailedPaymentsResultCopyWith<BookkeepingFailedPaymentsResult> get copyWith => _$BookkeepingFailedPaymentsResultCopyWithImpl<BookkeepingFailedPaymentsResult>(this as BookkeepingFailedPaymentsResult, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BookkeepingFailedPaymentsResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookkeepingFailedPaymentsResult&&(identical(other.month, _this.month) || other.month == _this.month)&&const DeepCollectionEquality().equals(other.payments, _this.payments)&&(identical(other.totalCount, _this.totalCount) || other.totalCount == _this.totalCount)&&(identical(other.retryableCount, _this.retryableCount) || other.retryableCount == _this.retryableCount));
}


@override
int get hashCode {
  final _this = this as BookkeepingFailedPaymentsResult;
  return Object.hash(runtimeType,_this.month,const DeepCollectionEquality().hash(_this.payments),_this.totalCount,_this.retryableCount);
}

@override
String toString() {
  final _this = this as BookkeepingFailedPaymentsResult;
  return 'BookkeepingFailedPaymentsResult(month: ${_this.month}, payments: ${_this.payments}, totalCount: ${_this.totalCount}, retryableCount: ${_this.retryableCount})';
}


}

/// @nodoc
abstract mixin class $BookkeepingFailedPaymentsResultCopyWith<$Res>  {
  factory $BookkeepingFailedPaymentsResultCopyWith(BookkeepingFailedPaymentsResult value, $Res Function(BookkeepingFailedPaymentsResult) _then) = _$BookkeepingFailedPaymentsResultCopyWithImpl;
@useResult
$Res call({
 String month, List<BookkeepingFailedPayment> payments, int totalCount, int retryableCount
});




}
/// @nodoc
class _$BookkeepingFailedPaymentsResultCopyWithImpl<$Res>
    implements $BookkeepingFailedPaymentsResultCopyWith<$Res> {
  _$BookkeepingFailedPaymentsResultCopyWithImpl(this._self, this._then);

  final BookkeepingFailedPaymentsResult _self;
  final $Res Function(BookkeepingFailedPaymentsResult) _then;

/// Create a copy of BookkeepingFailedPaymentsResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? month = null,Object? payments = null,Object? totalCount = null,Object? retryableCount = null,}) {
  return _then(BookkeepingFailedPaymentsResult(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as String,payments: null == payments ? _self.payments : payments // ignore: cast_nullable_to_non_nullable
as List<BookkeepingFailedPayment>,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,retryableCount: null == retryableCount ? _self.retryableCount : retryableCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BookkeepingFailedPaymentsResult].
extension BookkeepingFailedPaymentsResultPatterns on BookkeepingFailedPaymentsResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookkeepingFailedPaymentsResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookkeepingFailedPaymentsResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookkeepingFailedPaymentsResult value)  $default,){
final _that = this;
switch (_that) {
case _BookkeepingFailedPaymentsResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookkeepingFailedPaymentsResult value)?  $default,){
final _that = this;
switch (_that) {
case _BookkeepingFailedPaymentsResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String month,  List<BookkeepingFailedPayment> payments,  int totalCount,  int retryableCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookkeepingFailedPaymentsResult() when $default != null:
return $default(_that.month,_that.payments,_that.totalCount,_that.retryableCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String month,  List<BookkeepingFailedPayment> payments,  int totalCount,  int retryableCount)  $default,) {final _that = this;
switch (_that) {
case _BookkeepingFailedPaymentsResult():
return $default(_that.month,_that.payments,_that.totalCount,_that.retryableCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String month,  List<BookkeepingFailedPayment> payments,  int totalCount,  int retryableCount)?  $default,) {final _that = this;
switch (_that) {
case _BookkeepingFailedPaymentsResult() when $default != null:
return $default(_that.month,_that.payments,_that.totalCount,_that.retryableCount);case _:
  return null;

}
}

}

/// @nodoc


class _BookkeepingFailedPaymentsResult implements BookkeepingFailedPaymentsResult {
  const _BookkeepingFailedPaymentsResult({required this.month, required  List<BookkeepingFailedPayment> payments, required this.totalCount, required this.retryableCount}): _payments = payments;
  

@override final  String month;
 final  List<BookkeepingFailedPayment> _payments;
@override List<BookkeepingFailedPayment> get payments {
  if (_payments is EqualUnmodifiableListView) return _payments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_payments);
}

@override final  int totalCount;
@override final  int retryableCount;

/// Create a copy of BookkeepingFailedPaymentsResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookkeepingFailedPaymentsResultCopyWith<_BookkeepingFailedPaymentsResult> get copyWith => __$BookkeepingFailedPaymentsResultCopyWithImpl<_BookkeepingFailedPaymentsResult>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookkeepingFailedPaymentsResult&&(identical(other.month, month) || other.month == month)&&const DeepCollectionEquality().equals(other.payments, _payments)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.retryableCount, retryableCount) || other.retryableCount == retryableCount));
}


@override
int get hashCode {
    return Object.hash(runtimeType,month,const DeepCollectionEquality().hash(_payments),totalCount,retryableCount);
}

@override
String toString() {
    return 'BookkeepingFailedPaymentsResult(month: $month, payments: $payments, totalCount: $totalCount, retryableCount: $retryableCount)';
}


}

/// @nodoc
abstract mixin class _$BookkeepingFailedPaymentsResultCopyWith<$Res> implements $BookkeepingFailedPaymentsResultCopyWith<$Res> {
  factory _$BookkeepingFailedPaymentsResultCopyWith(_BookkeepingFailedPaymentsResult value, $Res Function(_BookkeepingFailedPaymentsResult) _then) = __$BookkeepingFailedPaymentsResultCopyWithImpl;
@override @useResult
$Res call({
 String month, List<BookkeepingFailedPayment> payments, int totalCount, int retryableCount
});




}
/// @nodoc
class __$BookkeepingFailedPaymentsResultCopyWithImpl<$Res>
    implements _$BookkeepingFailedPaymentsResultCopyWith<$Res> {
  __$BookkeepingFailedPaymentsResultCopyWithImpl(this._self, this._then);

  final _BookkeepingFailedPaymentsResult _self;
  final $Res Function(_BookkeepingFailedPaymentsResult) _then;

/// Create a copy of BookkeepingFailedPaymentsResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? month = null,Object? payments = null,Object? totalCount = null,Object? retryableCount = null,}) {
  return _then(_BookkeepingFailedPaymentsResult(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as String,payments: null == payments ? _self._payments : payments // ignore: cast_nullable_to_non_nullable
as List<BookkeepingFailedPayment>,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,retryableCount: null == retryableCount ? _self.retryableCount : retryableCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$BookkeepingFailedPayment {

 String get id; String get amount; String get method; String get status; String? get gatewayRef; String? get description; int get retryCount; int get maxRetries; bool get canRetry; String? get lastError; DateTime get createdAt; DateTime? get updatedAt;
/// Create a copy of BookkeepingFailedPayment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookkeepingFailedPaymentCopyWith<BookkeepingFailedPayment> get copyWith => _$BookkeepingFailedPaymentCopyWithImpl<BookkeepingFailedPayment>(this as BookkeepingFailedPayment, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BookkeepingFailedPayment;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookkeepingFailedPayment&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.method, _this.method) || other.method == _this.method)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.gatewayRef, _this.gatewayRef) || other.gatewayRef == _this.gatewayRef)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.retryCount, _this.retryCount) || other.retryCount == _this.retryCount)&&(identical(other.maxRetries, _this.maxRetries) || other.maxRetries == _this.maxRetries)&&(identical(other.canRetry, _this.canRetry) || other.canRetry == _this.canRetry)&&(identical(other.lastError, _this.lastError) || other.lastError == _this.lastError)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}


@override
int get hashCode {
  final _this = this as BookkeepingFailedPayment;
  return Object.hash(runtimeType,_this.id,_this.amount,_this.method,_this.status,_this.gatewayRef,_this.description,_this.retryCount,_this.maxRetries,_this.canRetry,_this.lastError,_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as BookkeepingFailedPayment;
  return 'BookkeepingFailedPayment(id: ${_this.id}, amount: ${_this.amount}, method: ${_this.method}, status: ${_this.status}, gatewayRef: ${_this.gatewayRef}, description: ${_this.description}, retryCount: ${_this.retryCount}, maxRetries: ${_this.maxRetries}, canRetry: ${_this.canRetry}, lastError: ${_this.lastError}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $BookkeepingFailedPaymentCopyWith<$Res>  {
  factory $BookkeepingFailedPaymentCopyWith(BookkeepingFailedPayment value, $Res Function(BookkeepingFailedPayment) _then) = _$BookkeepingFailedPaymentCopyWithImpl;
@useResult
$Res call({
 String id, String amount, String method, String status, String? gatewayRef, String? description, int retryCount, int maxRetries, bool canRetry, String? lastError, DateTime createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$BookkeepingFailedPaymentCopyWithImpl<$Res>
    implements $BookkeepingFailedPaymentCopyWith<$Res> {
  _$BookkeepingFailedPaymentCopyWithImpl(this._self, this._then);

  final BookkeepingFailedPayment _self;
  final $Res Function(BookkeepingFailedPayment) _then;

/// Create a copy of BookkeepingFailedPayment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? amount = null,Object? method = null,Object? status = null,Object? gatewayRef = freezed,Object? description = freezed,Object? retryCount = null,Object? maxRetries = null,Object? canRetry = null,Object? lastError = freezed,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(BookkeepingFailedPayment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,gatewayRef: freezed == gatewayRef ? _self.gatewayRef : gatewayRef // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,retryCount: null == retryCount ? _self.retryCount : retryCount // ignore: cast_nullable_to_non_nullable
as int,maxRetries: null == maxRetries ? _self.maxRetries : maxRetries // ignore: cast_nullable_to_non_nullable
as int,canRetry: null == canRetry ? _self.canRetry : canRetry // ignore: cast_nullable_to_non_nullable
as bool,lastError: freezed == lastError ? _self.lastError : lastError // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [BookkeepingFailedPayment].
extension BookkeepingFailedPaymentPatterns on BookkeepingFailedPayment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookkeepingFailedPayment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookkeepingFailedPayment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookkeepingFailedPayment value)  $default,){
final _that = this;
switch (_that) {
case _BookkeepingFailedPayment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookkeepingFailedPayment value)?  $default,){
final _that = this;
switch (_that) {
case _BookkeepingFailedPayment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String amount,  String method,  String status,  String? gatewayRef,  String? description,  int retryCount,  int maxRetries,  bool canRetry,  String? lastError,  DateTime createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookkeepingFailedPayment() when $default != null:
return $default(_that.id,_that.amount,_that.method,_that.status,_that.gatewayRef,_that.description,_that.retryCount,_that.maxRetries,_that.canRetry,_that.lastError,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String amount,  String method,  String status,  String? gatewayRef,  String? description,  int retryCount,  int maxRetries,  bool canRetry,  String? lastError,  DateTime createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _BookkeepingFailedPayment():
return $default(_that.id,_that.amount,_that.method,_that.status,_that.gatewayRef,_that.description,_that.retryCount,_that.maxRetries,_that.canRetry,_that.lastError,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String amount,  String method,  String status,  String? gatewayRef,  String? description,  int retryCount,  int maxRetries,  bool canRetry,  String? lastError,  DateTime createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _BookkeepingFailedPayment() when $default != null:
return $default(_that.id,_that.amount,_that.method,_that.status,_that.gatewayRef,_that.description,_that.retryCount,_that.maxRetries,_that.canRetry,_that.lastError,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _BookkeepingFailedPayment implements BookkeepingFailedPayment {
  const _BookkeepingFailedPayment({required this.id, required this.amount, required this.method, required this.status, this.gatewayRef, this.description, required this.retryCount, required this.maxRetries, required this.canRetry, this.lastError, required this.createdAt, this.updatedAt});
  

@override final  String id;
@override final  String amount;
@override final  String method;
@override final  String status;
@override final  String? gatewayRef;
@override final  String? description;
@override final  int retryCount;
@override final  int maxRetries;
@override final  bool canRetry;
@override final  String? lastError;
@override final  DateTime createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of BookkeepingFailedPayment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookkeepingFailedPaymentCopyWith<_BookkeepingFailedPayment> get copyWith => __$BookkeepingFailedPaymentCopyWithImpl<_BookkeepingFailedPayment>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookkeepingFailedPayment&&(identical(other.id, id) || other.id == id)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.method, method) || other.method == method)&&(identical(other.status, status) || other.status == status)&&(identical(other.gatewayRef, gatewayRef) || other.gatewayRef == gatewayRef)&&(identical(other.description, description) || other.description == description)&&(identical(other.retryCount, retryCount) || other.retryCount == retryCount)&&(identical(other.maxRetries, maxRetries) || other.maxRetries == maxRetries)&&(identical(other.canRetry, canRetry) || other.canRetry == canRetry)&&(identical(other.lastError, lastError) || other.lastError == lastError)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,amount,method,status,gatewayRef,description,retryCount,maxRetries,canRetry,lastError,createdAt,updatedAt);
}

@override
String toString() {
    return 'BookkeepingFailedPayment(id: $id, amount: $amount, method: $method, status: $status, gatewayRef: $gatewayRef, description: $description, retryCount: $retryCount, maxRetries: $maxRetries, canRetry: $canRetry, lastError: $lastError, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$BookkeepingFailedPaymentCopyWith<$Res> implements $BookkeepingFailedPaymentCopyWith<$Res> {
  factory _$BookkeepingFailedPaymentCopyWith(_BookkeepingFailedPayment value, $Res Function(_BookkeepingFailedPayment) _then) = __$BookkeepingFailedPaymentCopyWithImpl;
@override @useResult
$Res call({
 String id, String amount, String method, String status, String? gatewayRef, String? description, int retryCount, int maxRetries, bool canRetry, String? lastError, DateTime createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$BookkeepingFailedPaymentCopyWithImpl<$Res>
    implements _$BookkeepingFailedPaymentCopyWith<$Res> {
  __$BookkeepingFailedPaymentCopyWithImpl(this._self, this._then);

  final _BookkeepingFailedPayment _self;
  final $Res Function(_BookkeepingFailedPayment) _then;

/// Create a copy of BookkeepingFailedPayment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? amount = null,Object? method = null,Object? status = null,Object? gatewayRef = freezed,Object? description = freezed,Object? retryCount = null,Object? maxRetries = null,Object? canRetry = null,Object? lastError = freezed,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_BookkeepingFailedPayment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,gatewayRef: freezed == gatewayRef ? _self.gatewayRef : gatewayRef // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,retryCount: null == retryCount ? _self.retryCount : retryCount // ignore: cast_nullable_to_non_nullable
as int,maxRetries: null == maxRetries ? _self.maxRetries : maxRetries // ignore: cast_nullable_to_non_nullable
as int,canRetry: null == canRetry ? _self.canRetry : canRetry // ignore: cast_nullable_to_non_nullable
as bool,lastError: freezed == lastError ? _self.lastError : lastError // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
