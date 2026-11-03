// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../payment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Payment {

 String get id; String? get invoiceId; double get amount; String get currency; String get method; String get status; String? get gatewayRef; String? get description; int get retryCount; int get maxRetries; PaymentMetadata? get metadata; DateTime get createdAt; DateTime? get updatedAt;
/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentCopyWith<Payment> get copyWith => _$PaymentCopyWithImpl<Payment>(this as Payment, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Payment;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Payment&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.invoiceId, _this.invoiceId) || other.invoiceId == _this.invoiceId)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.method, _this.method) || other.method == _this.method)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.gatewayRef, _this.gatewayRef) || other.gatewayRef == _this.gatewayRef)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.retryCount, _this.retryCount) || other.retryCount == _this.retryCount)&&(identical(other.maxRetries, _this.maxRetries) || other.maxRetries == _this.maxRetries)&&(identical(other.metadata, _this.metadata) || other.metadata == _this.metadata)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}


@override
int get hashCode {
  final _this = this as Payment;
  return Object.hash(runtimeType,_this.id,_this.invoiceId,_this.amount,_this.currency,_this.method,_this.status,_this.gatewayRef,_this.description,_this.retryCount,_this.maxRetries,_this.metadata,_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as Payment;
  return 'Payment(id: ${_this.id}, invoiceId: ${_this.invoiceId}, amount: ${_this.amount}, currency: ${_this.currency}, method: ${_this.method}, status: ${_this.status}, gatewayRef: ${_this.gatewayRef}, description: ${_this.description}, retryCount: ${_this.retryCount}, maxRetries: ${_this.maxRetries}, metadata: ${_this.metadata}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $PaymentCopyWith<$Res>  {
  factory $PaymentCopyWith(Payment value, $Res Function(Payment) _then) = _$PaymentCopyWithImpl;
@useResult
$Res call({
 String id, String? invoiceId, double amount, String currency, String method, String status, String? gatewayRef, String? description, int retryCount, int maxRetries, PaymentMetadata? metadata, DateTime createdAt, DateTime? updatedAt
});


$PaymentMetadataCopyWith<$Res>? get metadata;

}
/// @nodoc
class _$PaymentCopyWithImpl<$Res>
    implements $PaymentCopyWith<$Res> {
  _$PaymentCopyWithImpl(this._self, this._then);

  final Payment _self;
  final $Res Function(Payment) _then;

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? invoiceId = freezed,Object? amount = null,Object? currency = null,Object? method = null,Object? status = null,Object? gatewayRef = freezed,Object? description = freezed,Object? retryCount = null,Object? maxRetries = null,Object? metadata = freezed,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(Payment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,invoiceId: freezed == invoiceId ? _self.invoiceId : invoiceId // ignore: cast_nullable_to_non_nullable
as String?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,gatewayRef: freezed == gatewayRef ? _self.gatewayRef : gatewayRef // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,retryCount: null == retryCount ? _self.retryCount : retryCount // ignore: cast_nullable_to_non_nullable
as int,maxRetries: null == maxRetries ? _self.maxRetries : maxRetries // ignore: cast_nullable_to_non_nullable
as int,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as PaymentMetadata?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaymentMetadataCopyWith<$Res>? get metadata {
    if (_self.metadata == null) {
    return null;
  }

  return $PaymentMetadataCopyWith<$Res>(_self.metadata!, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}


/// Adds pattern-matching-related methods to [Payment].
extension PaymentPatterns on Payment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Payment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Payment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Payment value)  $default,){
final _that = this;
switch (_that) {
case _Payment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Payment value)?  $default,){
final _that = this;
switch (_that) {
case _Payment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? invoiceId,  double amount,  String currency,  String method,  String status,  String? gatewayRef,  String? description,  int retryCount,  int maxRetries,  PaymentMetadata? metadata,  DateTime createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Payment() when $default != null:
return $default(_that.id,_that.invoiceId,_that.amount,_that.currency,_that.method,_that.status,_that.gatewayRef,_that.description,_that.retryCount,_that.maxRetries,_that.metadata,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? invoiceId,  double amount,  String currency,  String method,  String status,  String? gatewayRef,  String? description,  int retryCount,  int maxRetries,  PaymentMetadata? metadata,  DateTime createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Payment():
return $default(_that.id,_that.invoiceId,_that.amount,_that.currency,_that.method,_that.status,_that.gatewayRef,_that.description,_that.retryCount,_that.maxRetries,_that.metadata,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? invoiceId,  double amount,  String currency,  String method,  String status,  String? gatewayRef,  String? description,  int retryCount,  int maxRetries,  PaymentMetadata? metadata,  DateTime createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Payment() when $default != null:
return $default(_that.id,_that.invoiceId,_that.amount,_that.currency,_that.method,_that.status,_that.gatewayRef,_that.description,_that.retryCount,_that.maxRetries,_that.metadata,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _Payment extends Payment {
  const _Payment({required this.id, this.invoiceId, required this.amount, this.currency = 'IDR', this.method = 'cash', this.status = 'pending', this.gatewayRef, this.description, this.retryCount = 0, this.maxRetries = 3, this.metadata, required this.createdAt, this.updatedAt}): super._();
  

@override final  String id;
@override final  String? invoiceId;
@override final  double amount;
@override@JsonKey() final  String currency;
@override@JsonKey() final  String method;
@override@JsonKey() final  String status;
@override final  String? gatewayRef;
@override final  String? description;
@override@JsonKey() final  int retryCount;
@override@JsonKey() final  int maxRetries;
@override final  PaymentMetadata? metadata;
@override final  DateTime createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentCopyWith<_Payment> get copyWith => __$PaymentCopyWithImpl<_Payment>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Payment&&(identical(other.id, id) || other.id == id)&&(identical(other.invoiceId, invoiceId) || other.invoiceId == invoiceId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.method, method) || other.method == method)&&(identical(other.status, status) || other.status == status)&&(identical(other.gatewayRef, gatewayRef) || other.gatewayRef == gatewayRef)&&(identical(other.description, description) || other.description == description)&&(identical(other.retryCount, retryCount) || other.retryCount == retryCount)&&(identical(other.maxRetries, maxRetries) || other.maxRetries == maxRetries)&&(identical(other.metadata, metadata) || other.metadata == metadata)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,invoiceId,amount,currency,method,status,gatewayRef,description,retryCount,maxRetries,metadata,createdAt,updatedAt);
}

@override
String toString() {
    return 'Payment(id: $id, invoiceId: $invoiceId, amount: $amount, currency: $currency, method: $method, status: $status, gatewayRef: $gatewayRef, description: $description, retryCount: $retryCount, maxRetries: $maxRetries, metadata: $metadata, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$PaymentCopyWith<$Res> implements $PaymentCopyWith<$Res> {
  factory _$PaymentCopyWith(_Payment value, $Res Function(_Payment) _then) = __$PaymentCopyWithImpl;
@override @useResult
$Res call({
 String id, String? invoiceId, double amount, String currency, String method, String status, String? gatewayRef, String? description, int retryCount, int maxRetries, PaymentMetadata? metadata, DateTime createdAt, DateTime? updatedAt
});


@override $PaymentMetadataCopyWith<$Res>? get metadata;

}
/// @nodoc
class __$PaymentCopyWithImpl<$Res>
    implements _$PaymentCopyWith<$Res> {
  __$PaymentCopyWithImpl(this._self, this._then);

  final _Payment _self;
  final $Res Function(_Payment) _then;

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? invoiceId = freezed,Object? amount = null,Object? currency = null,Object? method = null,Object? status = null,Object? gatewayRef = freezed,Object? description = freezed,Object? retryCount = null,Object? maxRetries = null,Object? metadata = freezed,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_Payment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,invoiceId: freezed == invoiceId ? _self.invoiceId : invoiceId // ignore: cast_nullable_to_non_nullable
as String?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,gatewayRef: freezed == gatewayRef ? _self.gatewayRef : gatewayRef // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,retryCount: null == retryCount ? _self.retryCount : retryCount // ignore: cast_nullable_to_non_nullable
as int,maxRetries: null == maxRetries ? _self.maxRetries : maxRetries // ignore: cast_nullable_to_non_nullable
as int,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as PaymentMetadata?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaymentMetadataCopyWith<$Res>? get metadata {
    if (_self.metadata == null) {
    return null;
  }

  return $PaymentMetadataCopyWith<$Res>(_self.metadata!, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}

/// @nodoc
mixin _$PaymentMetadata {

/// Jenis proses pembayaran (`general`/`OrderProductSale`).
 String? get paymentType;/// Asset yang di-charge pada proses pembayaran (Float di GraphQL).
 double? get assetId;/// Pesan kegagalan dari gateway — dipakai layar detail untuk penyebab.
 String? get lastError;/// Jeda sebelum retry berikutnya (backoff `retry-policy.vo.ts`).
 double? get nextRetryDelayMs;
/// Create a copy of PaymentMetadata
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentMetadataCopyWith<PaymentMetadata> get copyWith => _$PaymentMetadataCopyWithImpl<PaymentMetadata>(this as PaymentMetadata, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PaymentMetadata;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentMetadata&&(identical(other.paymentType, _this.paymentType) || other.paymentType == _this.paymentType)&&(identical(other.assetId, _this.assetId) || other.assetId == _this.assetId)&&(identical(other.lastError, _this.lastError) || other.lastError == _this.lastError)&&(identical(other.nextRetryDelayMs, _this.nextRetryDelayMs) || other.nextRetryDelayMs == _this.nextRetryDelayMs));
}


@override
int get hashCode {
  final _this = this as PaymentMetadata;
  return Object.hash(runtimeType,_this.paymentType,_this.assetId,_this.lastError,_this.nextRetryDelayMs);
}

@override
String toString() {
  final _this = this as PaymentMetadata;
  return 'PaymentMetadata(paymentType: ${_this.paymentType}, assetId: ${_this.assetId}, lastError: ${_this.lastError}, nextRetryDelayMs: ${_this.nextRetryDelayMs})';
}


}

/// @nodoc
abstract mixin class $PaymentMetadataCopyWith<$Res>  {
  factory $PaymentMetadataCopyWith(PaymentMetadata value, $Res Function(PaymentMetadata) _then) = _$PaymentMetadataCopyWithImpl;
@useResult
$Res call({
 String? paymentType, double? assetId, String? lastError, double? nextRetryDelayMs
});




}
/// @nodoc
class _$PaymentMetadataCopyWithImpl<$Res>
    implements $PaymentMetadataCopyWith<$Res> {
  _$PaymentMetadataCopyWithImpl(this._self, this._then);

  final PaymentMetadata _self;
  final $Res Function(PaymentMetadata) _then;

/// Create a copy of PaymentMetadata
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? paymentType = freezed,Object? assetId = freezed,Object? lastError = freezed,Object? nextRetryDelayMs = freezed,}) {
  return _then(PaymentMetadata(
paymentType: freezed == paymentType ? _self.paymentType : paymentType // ignore: cast_nullable_to_non_nullable
as String?,assetId: freezed == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as double?,lastError: freezed == lastError ? _self.lastError : lastError // ignore: cast_nullable_to_non_nullable
as String?,nextRetryDelayMs: freezed == nextRetryDelayMs ? _self.nextRetryDelayMs : nextRetryDelayMs // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentMetadata].
extension PaymentMetadataPatterns on PaymentMetadata {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentMetadata value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentMetadata() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentMetadata value)  $default,){
final _that = this;
switch (_that) {
case _PaymentMetadata():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentMetadata value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentMetadata() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? paymentType,  double? assetId,  String? lastError,  double? nextRetryDelayMs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentMetadata() when $default != null:
return $default(_that.paymentType,_that.assetId,_that.lastError,_that.nextRetryDelayMs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? paymentType,  double? assetId,  String? lastError,  double? nextRetryDelayMs)  $default,) {final _that = this;
switch (_that) {
case _PaymentMetadata():
return $default(_that.paymentType,_that.assetId,_that.lastError,_that.nextRetryDelayMs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? paymentType,  double? assetId,  String? lastError,  double? nextRetryDelayMs)?  $default,) {final _that = this;
switch (_that) {
case _PaymentMetadata() when $default != null:
return $default(_that.paymentType,_that.assetId,_that.lastError,_that.nextRetryDelayMs);case _:
  return null;

}
}

}

/// @nodoc


class _PaymentMetadata implements PaymentMetadata {
  const _PaymentMetadata({this.paymentType, this.assetId, this.lastError, this.nextRetryDelayMs});
  

/// Jenis proses pembayaran (`general`/`OrderProductSale`).
@override final  String? paymentType;
/// Asset yang di-charge pada proses pembayaran (Float di GraphQL).
@override final  double? assetId;
/// Pesan kegagalan dari gateway — dipakai layar detail untuk penyebab.
@override final  String? lastError;
/// Jeda sebelum retry berikutnya (backoff `retry-policy.vo.ts`).
@override final  double? nextRetryDelayMs;

/// Create a copy of PaymentMetadata
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentMetadataCopyWith<_PaymentMetadata> get copyWith => __$PaymentMetadataCopyWithImpl<_PaymentMetadata>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentMetadata&&(identical(other.paymentType, paymentType) || other.paymentType == paymentType)&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.lastError, lastError) || other.lastError == lastError)&&(identical(other.nextRetryDelayMs, nextRetryDelayMs) || other.nextRetryDelayMs == nextRetryDelayMs));
}


@override
int get hashCode {
    return Object.hash(runtimeType,paymentType,assetId,lastError,nextRetryDelayMs);
}

@override
String toString() {
    return 'PaymentMetadata(paymentType: $paymentType, assetId: $assetId, lastError: $lastError, nextRetryDelayMs: $nextRetryDelayMs)';
}


}

/// @nodoc
abstract mixin class _$PaymentMetadataCopyWith<$Res> implements $PaymentMetadataCopyWith<$Res> {
  factory _$PaymentMetadataCopyWith(_PaymentMetadata value, $Res Function(_PaymentMetadata) _then) = __$PaymentMetadataCopyWithImpl;
@override @useResult
$Res call({
 String? paymentType, double? assetId, String? lastError, double? nextRetryDelayMs
});




}
/// @nodoc
class __$PaymentMetadataCopyWithImpl<$Res>
    implements _$PaymentMetadataCopyWith<$Res> {
  __$PaymentMetadataCopyWithImpl(this._self, this._then);

  final _PaymentMetadata _self;
  final $Res Function(_PaymentMetadata) _then;

/// Create a copy of PaymentMetadata
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? paymentType = freezed,Object? assetId = freezed,Object? lastError = freezed,Object? nextRetryDelayMs = freezed,}) {
  return _then(_PaymentMetadata(
paymentType: freezed == paymentType ? _self.paymentType : paymentType // ignore: cast_nullable_to_non_nullable
as String?,assetId: freezed == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as double?,lastError: freezed == lastError ? _self.lastError : lastError // ignore: cast_nullable_to_non_nullable
as String?,nextRetryDelayMs: freezed == nextRetryDelayMs ? _self.nextRetryDelayMs : nextRetryDelayMs // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
