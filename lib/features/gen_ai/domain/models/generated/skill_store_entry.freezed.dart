// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../skill_store_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SkillStoreEntry {

/// Id unik berformat `{source}/{slug}`. Sama dengan `id` di API skills.sh
/// sekaligus path halaman detailnya (`https://skills.sh/<id>`), jadi dipakai
/// untuk mengambil instruksi skill.
 String get id;/// Slug ramah URL, mis. `find-skills`.
 String get slug;/// Nama tampilan skill, mis. `Find Skills`.
 String get name;/// Repositori/sumber, format `owner/repo`, mis. `vercel-labs/skills`.
 String get source;/// Total pemasangan. Mode scrape hanya mendapat angka yang sudah dibulatkan
/// store (mis. `3.9M`), jadi nilainya perkiraan; `null` bila tidak tersedia.
 int? get installs;
/// Create a copy of SkillStoreEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SkillStoreEntryCopyWith<SkillStoreEntry> get copyWith => _$SkillStoreEntryCopyWithImpl<SkillStoreEntry>(this as SkillStoreEntry, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SkillStoreEntry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SkillStoreEntry&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.installs, _this.installs) || other.installs == _this.installs));
}


@override
int get hashCode {
  final _this = this as SkillStoreEntry;
  return Object.hash(runtimeType,_this.id,_this.slug,_this.name,_this.source,_this.installs);
}

@override
String toString() {
  final _this = this as SkillStoreEntry;
  return 'SkillStoreEntry(id: ${_this.id}, slug: ${_this.slug}, name: ${_this.name}, source: ${_this.source}, installs: ${_this.installs})';
}


}

/// @nodoc
abstract mixin class $SkillStoreEntryCopyWith<$Res>  {
  factory $SkillStoreEntryCopyWith(SkillStoreEntry value, $Res Function(SkillStoreEntry) _then) = _$SkillStoreEntryCopyWithImpl;
@useResult
$Res call({
 String id, String slug, String name, String source, int? installs
});




}
/// @nodoc
class _$SkillStoreEntryCopyWithImpl<$Res>
    implements $SkillStoreEntryCopyWith<$Res> {
  _$SkillStoreEntryCopyWithImpl(this._self, this._then);

  final SkillStoreEntry _self;
  final $Res Function(SkillStoreEntry) _then;

/// Create a copy of SkillStoreEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? slug = null,Object? name = null,Object? source = null,Object? installs = freezed,}) {
  return _then(SkillStoreEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,installs: freezed == installs ? _self.installs : installs // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [SkillStoreEntry].
extension SkillStoreEntryPatterns on SkillStoreEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SkillStoreEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SkillStoreEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SkillStoreEntry value)  $default,){
final _that = this;
switch (_that) {
case _SkillStoreEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SkillStoreEntry value)?  $default,){
final _that = this;
switch (_that) {
case _SkillStoreEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String slug,  String name,  String source,  int? installs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SkillStoreEntry() when $default != null:
return $default(_that.id,_that.slug,_that.name,_that.source,_that.installs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String slug,  String name,  String source,  int? installs)  $default,) {final _that = this;
switch (_that) {
case _SkillStoreEntry():
return $default(_that.id,_that.slug,_that.name,_that.source,_that.installs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String slug,  String name,  String source,  int? installs)?  $default,) {final _that = this;
switch (_that) {
case _SkillStoreEntry() when $default != null:
return $default(_that.id,_that.slug,_that.name,_that.source,_that.installs);case _:
  return null;

}
}

}

/// @nodoc


class _SkillStoreEntry extends SkillStoreEntry {
  const _SkillStoreEntry({required this.id, required this.slug, required this.name, required this.source, this.installs}): super._();
  

/// Id unik berformat `{source}/{slug}`. Sama dengan `id` di API skills.sh
/// sekaligus path halaman detailnya (`https://skills.sh/<id>`), jadi dipakai
/// untuk mengambil instruksi skill.
@override final  String id;
/// Slug ramah URL, mis. `find-skills`.
@override final  String slug;
/// Nama tampilan skill, mis. `Find Skills`.
@override final  String name;
/// Repositori/sumber, format `owner/repo`, mis. `vercel-labs/skills`.
@override final  String source;
/// Total pemasangan. Mode scrape hanya mendapat angka yang sudah dibulatkan
/// store (mis. `3.9M`), jadi nilainya perkiraan; `null` bila tidak tersedia.
@override final  int? installs;

/// Create a copy of SkillStoreEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SkillStoreEntryCopyWith<_SkillStoreEntry> get copyWith => __$SkillStoreEntryCopyWithImpl<_SkillStoreEntry>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SkillStoreEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.name, name) || other.name == name)&&(identical(other.source, source) || other.source == source)&&(identical(other.installs, installs) || other.installs == installs));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,slug,name,source,installs);
}

@override
String toString() {
    return 'SkillStoreEntry(id: $id, slug: $slug, name: $name, source: $source, installs: $installs)';
}


}

/// @nodoc
abstract mixin class _$SkillStoreEntryCopyWith<$Res> implements $SkillStoreEntryCopyWith<$Res> {
  factory _$SkillStoreEntryCopyWith(_SkillStoreEntry value, $Res Function(_SkillStoreEntry) _then) = __$SkillStoreEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, String slug, String name, String source, int? installs
});




}
/// @nodoc
class __$SkillStoreEntryCopyWithImpl<$Res>
    implements _$SkillStoreEntryCopyWith<$Res> {
  __$SkillStoreEntryCopyWithImpl(this._self, this._then);

  final _SkillStoreEntry _self;
  final $Res Function(_SkillStoreEntry) _then;

/// Create a copy of SkillStoreEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? slug = null,Object? name = null,Object? source = null,Object? installs = freezed,}) {
  return _then(_SkillStoreEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,installs: freezed == installs ? _self.installs : installs // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
