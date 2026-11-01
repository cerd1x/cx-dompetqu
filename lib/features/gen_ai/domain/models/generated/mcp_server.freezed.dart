// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../mcp_server.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$McpServer {

 String get id; String get name; String get url;
/// Create a copy of McpServer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$McpServerCopyWith<McpServer> get copyWith => _$McpServerCopyWithImpl<McpServer>(this as McpServer, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as McpServer;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is McpServer&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.url, _this.url) || other.url == _this.url));
}


@override
int get hashCode {
  final _this = this as McpServer;
  return Object.hash(runtimeType,_this.id,_this.name,_this.url);
}

@override
String toString() {
  final _this = this as McpServer;
  return 'McpServer(id: ${_this.id}, name: ${_this.name}, url: ${_this.url})';
}


}

/// @nodoc
abstract mixin class $McpServerCopyWith<$Res>  {
  factory $McpServerCopyWith(McpServer value, $Res Function(McpServer) _then) = _$McpServerCopyWithImpl;
@useResult
$Res call({
 String id, String name, String url
});




}
/// @nodoc
class _$McpServerCopyWithImpl<$Res>
    implements $McpServerCopyWith<$Res> {
  _$McpServerCopyWithImpl(this._self, this._then);

  final McpServer _self;
  final $Res Function(McpServer) _then;

/// Create a copy of McpServer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? url = null,}) {
  return _then(McpServer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [McpServer].
extension McpServerPatterns on McpServer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _McpServer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _McpServer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _McpServer value)  $default,){
final _that = this;
switch (_that) {
case _McpServer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _McpServer value)?  $default,){
final _that = this;
switch (_that) {
case _McpServer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String url)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _McpServer() when $default != null:
return $default(_that.id,_that.name,_that.url);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String url)  $default,) {final _that = this;
switch (_that) {
case _McpServer():
return $default(_that.id,_that.name,_that.url);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String url)?  $default,) {final _that = this;
switch (_that) {
case _McpServer() when $default != null:
return $default(_that.id,_that.name,_that.url);case _:
  return null;

}
}

}

/// @nodoc


class _McpServer extends McpServer {
  const _McpServer({required this.id, required this.name, required this.url}): super._();
  

@override final  String id;
@override final  String name;
@override final  String url;

/// Create a copy of McpServer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$McpServerCopyWith<_McpServer> get copyWith => __$McpServerCopyWithImpl<_McpServer>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _McpServer&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.url, url) || other.url == url));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,url);
}

@override
String toString() {
    return 'McpServer(id: $id, name: $name, url: $url)';
}


}

/// @nodoc
abstract mixin class _$McpServerCopyWith<$Res> implements $McpServerCopyWith<$Res> {
  factory _$McpServerCopyWith(_McpServer value, $Res Function(_McpServer) _then) = __$McpServerCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String url
});




}
/// @nodoc
class __$McpServerCopyWithImpl<$Res>
    implements _$McpServerCopyWith<$Res> {
  __$McpServerCopyWithImpl(this._self, this._then);

  final _McpServer _self;
  final $Res Function(_McpServer) _then;

/// Create a copy of McpServer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? url = null,}) {
  return _then(_McpServer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
