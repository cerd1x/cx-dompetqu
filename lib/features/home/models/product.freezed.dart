// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Product {

@JsonKey(fromJson: _toId) String? get id; String get name; String? get description; num get price; num? get capital; num? get margin; String get currency;@JsonKey(fromJson: _stockFromJson) int get stock; bool get trackStock;@JsonKey(fromJson: _date) DateTime? get createdAt;@JsonKey(fromJson: _date) DateTime? get updatedAt;
/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductCopyWith<Product> get copyWith => _$ProductCopyWithImpl<Product>(this as Product, _$identity);

  /// Serializes this Product to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Product;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Product&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.price, _this.price) || other.price == _this.price)&&(identical(other.capital, _this.capital) || other.capital == _this.capital)&&(identical(other.margin, _this.margin) || other.margin == _this.margin)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.stock, _this.stock) || other.stock == _this.stock)&&(identical(other.trackStock, _this.trackStock) || other.trackStock == _this.trackStock)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Product;
  return Object.hash(runtimeType,_this.id,_this.name,_this.description,_this.price,_this.capital,_this.margin,_this.currency,_this.stock,_this.trackStock,_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as Product;
  return 'Product(id: ${_this.id}, name: ${_this.name}, description: ${_this.description}, price: ${_this.price}, capital: ${_this.capital}, margin: ${_this.margin}, currency: ${_this.currency}, stock: ${_this.stock}, trackStock: ${_this.trackStock}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $ProductCopyWith<$Res>  {
  factory $ProductCopyWith(Product value, $Res Function(Product) _then) = _$ProductCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _toId) String? id, String name, String? description, num price, num? capital, num? margin, String currency,@JsonKey(fromJson: _stockFromJson) int stock, bool trackStock,@JsonKey(fromJson: _date) DateTime? createdAt,@JsonKey(fromJson: _date) DateTime? updatedAt
});




}
/// @nodoc
class _$ProductCopyWithImpl<$Res>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._self, this._then);

  final Product _self;
  final $Res Function(Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = null,Object? description = freezed,Object? price = null,Object? capital = freezed,Object? margin = freezed,Object? currency = null,Object? stock = null,Object? trackStock = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(Product(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as num,capital: freezed == capital ? _self.capital : capital // ignore: cast_nullable_to_non_nullable
as num?,margin: freezed == margin ? _self.margin : margin // ignore: cast_nullable_to_non_nullable
as num?,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as int,trackStock: null == trackStock ? _self.trackStock : trackStock // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Product].
extension ProductPatterns on Product {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Product value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Product() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Product value)  $default,){
final _that = this;
switch (_that) {
case _Product():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Product value)?  $default,){
final _that = this;
switch (_that) {
case _Product() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _toId)  String? id,  String name,  String? description,  num price,  num? capital,  num? margin,  String currency, @JsonKey(fromJson: _stockFromJson)  int stock,  bool trackStock, @JsonKey(fromJson: _date)  DateTime? createdAt, @JsonKey(fromJson: _date)  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.price,_that.capital,_that.margin,_that.currency,_that.stock,_that.trackStock,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _toId)  String? id,  String name,  String? description,  num price,  num? capital,  num? margin,  String currency, @JsonKey(fromJson: _stockFromJson)  int stock,  bool trackStock, @JsonKey(fromJson: _date)  DateTime? createdAt, @JsonKey(fromJson: _date)  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Product():
return $default(_that.id,_that.name,_that.description,_that.price,_that.capital,_that.margin,_that.currency,_that.stock,_that.trackStock,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _toId)  String? id,  String name,  String? description,  num price,  num? capital,  num? margin,  String currency, @JsonKey(fromJson: _stockFromJson)  int stock,  bool trackStock, @JsonKey(fromJson: _date)  DateTime? createdAt, @JsonKey(fromJson: _date)  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.price,_that.capital,_that.margin,_that.currency,_that.stock,_that.trackStock,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Product extends Product {
  const _Product({@JsonKey(fromJson: _toId) this.id, required this.name, this.description, this.price = 0, this.capital, this.margin, this.currency = 'IDR', @JsonKey(fromJson: _stockFromJson) this.stock = 0, this.trackStock = false, @JsonKey(fromJson: _date) this.createdAt, @JsonKey(fromJson: _date) this.updatedAt}): super._();
  factory _Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

@override@JsonKey(fromJson: _toId) final  String? id;
@override final  String name;
@override final  String? description;
@override@JsonKey() final  num price;
@override final  num? capital;
@override final  num? margin;
@override@JsonKey() final  String currency;
@override@JsonKey(fromJson: _stockFromJson) final  int stock;
@override@JsonKey() final  bool trackStock;
@override@JsonKey(fromJson: _date) final  DateTime? createdAt;
@override@JsonKey(fromJson: _date) final  DateTime? updatedAt;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductCopyWith<_Product> get copyWith => __$ProductCopyWithImpl<_Product>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Product&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.price, price) || other.price == price)&&(identical(other.capital, capital) || other.capital == capital)&&(identical(other.margin, margin) || other.margin == margin)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.trackStock, trackStock) || other.trackStock == trackStock)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,description,price,capital,margin,currency,stock,trackStock,createdAt,updatedAt);
}

@override
String toString() {
    return 'Product(id: $id, name: $name, description: $description, price: $price, capital: $capital, margin: $margin, currency: $currency, stock: $stock, trackStock: $trackStock, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ProductCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$ProductCopyWith(_Product value, $Res Function(_Product) _then) = __$ProductCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _toId) String? id, String name, String? description, num price, num? capital, num? margin, String currency,@JsonKey(fromJson: _stockFromJson) int stock, bool trackStock,@JsonKey(fromJson: _date) DateTime? createdAt,@JsonKey(fromJson: _date) DateTime? updatedAt
});




}
/// @nodoc
class __$ProductCopyWithImpl<$Res>
    implements _$ProductCopyWith<$Res> {
  __$ProductCopyWithImpl(this._self, this._then);

  final _Product _self;
  final $Res Function(_Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = null,Object? description = freezed,Object? price = null,Object? capital = freezed,Object? margin = freezed,Object? currency = null,Object? stock = null,Object? trackStock = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Product(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as num,capital: freezed == capital ? _self.capital : capital // ignore: cast_nullable_to_non_nullable
as num?,margin: freezed == margin ? _self.margin : margin // ignore: cast_nullable_to_non_nullable
as num?,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as int,trackStock: null == trackStock ? _self.trackStock : trackStock // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
