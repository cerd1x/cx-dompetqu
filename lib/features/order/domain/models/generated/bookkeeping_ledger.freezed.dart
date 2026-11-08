// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../bookkeeping_ledger.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BookkeepingLedger {

 String get month; BookkeepingFilter get filter; List<BookkeepingSummary> get summaries; List<BookkeepingDayGroup> get groups;
/// Create a copy of BookkeepingLedger
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookkeepingLedgerCopyWith<BookkeepingLedger> get copyWith => _$BookkeepingLedgerCopyWithImpl<BookkeepingLedger>(this as BookkeepingLedger, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BookkeepingLedger;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookkeepingLedger&&(identical(other.month, _this.month) || other.month == _this.month)&&(identical(other.filter, _this.filter) || other.filter == _this.filter)&&const DeepCollectionEquality().equals(other.summaries, _this.summaries)&&const DeepCollectionEquality().equals(other.groups, _this.groups));
}


@override
int get hashCode {
  final _this = this as BookkeepingLedger;
  return Object.hash(runtimeType,_this.month,_this.filter,const DeepCollectionEquality().hash(_this.summaries),const DeepCollectionEquality().hash(_this.groups));
}

@override
String toString() {
  final _this = this as BookkeepingLedger;
  return 'BookkeepingLedger(month: ${_this.month}, filter: ${_this.filter}, summaries: ${_this.summaries}, groups: ${_this.groups})';
}


}

/// @nodoc
abstract mixin class $BookkeepingLedgerCopyWith<$Res>  {
  factory $BookkeepingLedgerCopyWith(BookkeepingLedger value, $Res Function(BookkeepingLedger) _then) = _$BookkeepingLedgerCopyWithImpl;
@useResult
$Res call({
 String month, BookkeepingFilter filter, List<BookkeepingSummary> summaries, List<BookkeepingDayGroup> groups
});




}
/// @nodoc
class _$BookkeepingLedgerCopyWithImpl<$Res>
    implements $BookkeepingLedgerCopyWith<$Res> {
  _$BookkeepingLedgerCopyWithImpl(this._self, this._then);

  final BookkeepingLedger _self;
  final $Res Function(BookkeepingLedger) _then;

/// Create a copy of BookkeepingLedger
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? month = null,Object? filter = null,Object? summaries = null,Object? groups = null,}) {
  return _then(BookkeepingLedger(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as String,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as BookkeepingFilter,summaries: null == summaries ? _self.summaries : summaries // ignore: cast_nullable_to_non_nullable
as List<BookkeepingSummary>,groups: null == groups ? _self.groups : groups // ignore: cast_nullable_to_non_nullable
as List<BookkeepingDayGroup>,
  ));
}

}


/// Adds pattern-matching-related methods to [BookkeepingLedger].
extension BookkeepingLedgerPatterns on BookkeepingLedger {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookkeepingLedger value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookkeepingLedger() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookkeepingLedger value)  $default,){
final _that = this;
switch (_that) {
case _BookkeepingLedger():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookkeepingLedger value)?  $default,){
final _that = this;
switch (_that) {
case _BookkeepingLedger() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String month,  BookkeepingFilter filter,  List<BookkeepingSummary> summaries,  List<BookkeepingDayGroup> groups)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookkeepingLedger() when $default != null:
return $default(_that.month,_that.filter,_that.summaries,_that.groups);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String month,  BookkeepingFilter filter,  List<BookkeepingSummary> summaries,  List<BookkeepingDayGroup> groups)  $default,) {final _that = this;
switch (_that) {
case _BookkeepingLedger():
return $default(_that.month,_that.filter,_that.summaries,_that.groups);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String month,  BookkeepingFilter filter,  List<BookkeepingSummary> summaries,  List<BookkeepingDayGroup> groups)?  $default,) {final _that = this;
switch (_that) {
case _BookkeepingLedger() when $default != null:
return $default(_that.month,_that.filter,_that.summaries,_that.groups);case _:
  return null;

}
}

}

/// @nodoc


class _BookkeepingLedger implements BookkeepingLedger {
  const _BookkeepingLedger({required this.month, required this.filter, required  List<BookkeepingSummary> summaries, required  List<BookkeepingDayGroup> groups}): _summaries = summaries,_groups = groups;
  

@override final  String month;
@override final  BookkeepingFilter filter;
 final  List<BookkeepingSummary> _summaries;
@override List<BookkeepingSummary> get summaries {
  if (_summaries is EqualUnmodifiableListView) return _summaries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_summaries);
}

 final  List<BookkeepingDayGroup> _groups;
@override List<BookkeepingDayGroup> get groups {
  if (_groups is EqualUnmodifiableListView) return _groups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_groups);
}


/// Create a copy of BookkeepingLedger
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookkeepingLedgerCopyWith<_BookkeepingLedger> get copyWith => __$BookkeepingLedgerCopyWithImpl<_BookkeepingLedger>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookkeepingLedger&&(identical(other.month, month) || other.month == month)&&(identical(other.filter, filter) || other.filter == filter)&&const DeepCollectionEquality().equals(other.summaries, _summaries)&&const DeepCollectionEquality().equals(other.groups, _groups));
}


@override
int get hashCode {
    return Object.hash(runtimeType,month,filter,const DeepCollectionEquality().hash(_summaries),const DeepCollectionEquality().hash(_groups));
}

@override
String toString() {
    return 'BookkeepingLedger(month: $month, filter: $filter, summaries: $summaries, groups: $groups)';
}


}

/// @nodoc
abstract mixin class _$BookkeepingLedgerCopyWith<$Res> implements $BookkeepingLedgerCopyWith<$Res> {
  factory _$BookkeepingLedgerCopyWith(_BookkeepingLedger value, $Res Function(_BookkeepingLedger) _then) = __$BookkeepingLedgerCopyWithImpl;
@override @useResult
$Res call({
 String month, BookkeepingFilter filter, List<BookkeepingSummary> summaries, List<BookkeepingDayGroup> groups
});




}
/// @nodoc
class __$BookkeepingLedgerCopyWithImpl<$Res>
    implements _$BookkeepingLedgerCopyWith<$Res> {
  __$BookkeepingLedgerCopyWithImpl(this._self, this._then);

  final _BookkeepingLedger _self;
  final $Res Function(_BookkeepingLedger) _then;

/// Create a copy of BookkeepingLedger
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? month = null,Object? filter = null,Object? summaries = null,Object? groups = null,}) {
  return _then(_BookkeepingLedger(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as String,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as BookkeepingFilter,summaries: null == summaries ? _self._summaries : summaries // ignore: cast_nullable_to_non_nullable
as List<BookkeepingSummary>,groups: null == groups ? _self._groups : groups // ignore: cast_nullable_to_non_nullable
as List<BookkeepingDayGroup>,
  ));
}


}

/// @nodoc
mixin _$BookkeepingSummary {

 String get currency; String get income; String get expense; String get profit; int get transactionCount;
/// Create a copy of BookkeepingSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookkeepingSummaryCopyWith<BookkeepingSummary> get copyWith => _$BookkeepingSummaryCopyWithImpl<BookkeepingSummary>(this as BookkeepingSummary, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BookkeepingSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookkeepingSummary&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.income, _this.income) || other.income == _this.income)&&(identical(other.expense, _this.expense) || other.expense == _this.expense)&&(identical(other.profit, _this.profit) || other.profit == _this.profit)&&(identical(other.transactionCount, _this.transactionCount) || other.transactionCount == _this.transactionCount));
}


@override
int get hashCode {
  final _this = this as BookkeepingSummary;
  return Object.hash(runtimeType,_this.currency,_this.income,_this.expense,_this.profit,_this.transactionCount);
}

@override
String toString() {
  final _this = this as BookkeepingSummary;
  return 'BookkeepingSummary(currency: ${_this.currency}, income: ${_this.income}, expense: ${_this.expense}, profit: ${_this.profit}, transactionCount: ${_this.transactionCount})';
}


}

/// @nodoc
abstract mixin class $BookkeepingSummaryCopyWith<$Res>  {
  factory $BookkeepingSummaryCopyWith(BookkeepingSummary value, $Res Function(BookkeepingSummary) _then) = _$BookkeepingSummaryCopyWithImpl;
@useResult
$Res call({
 String currency, String income, String expense, String profit, int transactionCount
});




}
/// @nodoc
class _$BookkeepingSummaryCopyWithImpl<$Res>
    implements $BookkeepingSummaryCopyWith<$Res> {
  _$BookkeepingSummaryCopyWithImpl(this._self, this._then);

  final BookkeepingSummary _self;
  final $Res Function(BookkeepingSummary) _then;

/// Create a copy of BookkeepingSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currency = null,Object? income = null,Object? expense = null,Object? profit = null,Object? transactionCount = null,}) {
  return _then(BookkeepingSummary(
currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,income: null == income ? _self.income : income // ignore: cast_nullable_to_non_nullable
as String,expense: null == expense ? _self.expense : expense // ignore: cast_nullable_to_non_nullable
as String,profit: null == profit ? _self.profit : profit // ignore: cast_nullable_to_non_nullable
as String,transactionCount: null == transactionCount ? _self.transactionCount : transactionCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BookkeepingSummary].
extension BookkeepingSummaryPatterns on BookkeepingSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookkeepingSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookkeepingSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookkeepingSummary value)  $default,){
final _that = this;
switch (_that) {
case _BookkeepingSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookkeepingSummary value)?  $default,){
final _that = this;
switch (_that) {
case _BookkeepingSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String currency,  String income,  String expense,  String profit,  int transactionCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookkeepingSummary() when $default != null:
return $default(_that.currency,_that.income,_that.expense,_that.profit,_that.transactionCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String currency,  String income,  String expense,  String profit,  int transactionCount)  $default,) {final _that = this;
switch (_that) {
case _BookkeepingSummary():
return $default(_that.currency,_that.income,_that.expense,_that.profit,_that.transactionCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String currency,  String income,  String expense,  String profit,  int transactionCount)?  $default,) {final _that = this;
switch (_that) {
case _BookkeepingSummary() when $default != null:
return $default(_that.currency,_that.income,_that.expense,_that.profit,_that.transactionCount);case _:
  return null;

}
}

}

/// @nodoc


class _BookkeepingSummary implements BookkeepingSummary {
  const _BookkeepingSummary({required this.currency, required this.income, required this.expense, required this.profit, required this.transactionCount});
  

@override final  String currency;
@override final  String income;
@override final  String expense;
@override final  String profit;
@override final  int transactionCount;

/// Create a copy of BookkeepingSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookkeepingSummaryCopyWith<_BookkeepingSummary> get copyWith => __$BookkeepingSummaryCopyWithImpl<_BookkeepingSummary>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookkeepingSummary&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.income, income) || other.income == income)&&(identical(other.expense, expense) || other.expense == expense)&&(identical(other.profit, profit) || other.profit == profit)&&(identical(other.transactionCount, transactionCount) || other.transactionCount == transactionCount));
}


@override
int get hashCode {
    return Object.hash(runtimeType,currency,income,expense,profit,transactionCount);
}

@override
String toString() {
    return 'BookkeepingSummary(currency: $currency, income: $income, expense: $expense, profit: $profit, transactionCount: $transactionCount)';
}


}

/// @nodoc
abstract mixin class _$BookkeepingSummaryCopyWith<$Res> implements $BookkeepingSummaryCopyWith<$Res> {
  factory _$BookkeepingSummaryCopyWith(_BookkeepingSummary value, $Res Function(_BookkeepingSummary) _then) = __$BookkeepingSummaryCopyWithImpl;
@override @useResult
$Res call({
 String currency, String income, String expense, String profit, int transactionCount
});




}
/// @nodoc
class __$BookkeepingSummaryCopyWithImpl<$Res>
    implements _$BookkeepingSummaryCopyWith<$Res> {
  __$BookkeepingSummaryCopyWithImpl(this._self, this._then);

  final _BookkeepingSummary _self;
  final $Res Function(_BookkeepingSummary) _then;

/// Create a copy of BookkeepingSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currency = null,Object? income = null,Object? expense = null,Object? profit = null,Object? transactionCount = null,}) {
  return _then(_BookkeepingSummary(
currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,income: null == income ? _self.income : income // ignore: cast_nullable_to_non_nullable
as String,expense: null == expense ? _self.expense : expense // ignore: cast_nullable_to_non_nullable
as String,profit: null == profit ? _self.profit : profit // ignore: cast_nullable_to_non_nullable
as String,transactionCount: null == transactionCount ? _self.transactionCount : transactionCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$BookkeepingDayGroup {

 String get date; int get transactionCount; List<BookkeepingEntry> get entries;
/// Create a copy of BookkeepingDayGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookkeepingDayGroupCopyWith<BookkeepingDayGroup> get copyWith => _$BookkeepingDayGroupCopyWithImpl<BookkeepingDayGroup>(this as BookkeepingDayGroup, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BookkeepingDayGroup;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookkeepingDayGroup&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.transactionCount, _this.transactionCount) || other.transactionCount == _this.transactionCount)&&const DeepCollectionEquality().equals(other.entries, _this.entries));
}


@override
int get hashCode {
  final _this = this as BookkeepingDayGroup;
  return Object.hash(runtimeType,_this.date,_this.transactionCount,const DeepCollectionEquality().hash(_this.entries));
}

@override
String toString() {
  final _this = this as BookkeepingDayGroup;
  return 'BookkeepingDayGroup(date: ${_this.date}, transactionCount: ${_this.transactionCount}, entries: ${_this.entries})';
}


}

/// @nodoc
abstract mixin class $BookkeepingDayGroupCopyWith<$Res>  {
  factory $BookkeepingDayGroupCopyWith(BookkeepingDayGroup value, $Res Function(BookkeepingDayGroup) _then) = _$BookkeepingDayGroupCopyWithImpl;
@useResult
$Res call({
 String date, int transactionCount, List<BookkeepingEntry> entries
});




}
/// @nodoc
class _$BookkeepingDayGroupCopyWithImpl<$Res>
    implements $BookkeepingDayGroupCopyWith<$Res> {
  _$BookkeepingDayGroupCopyWithImpl(this._self, this._then);

  final BookkeepingDayGroup _self;
  final $Res Function(BookkeepingDayGroup) _then;

/// Create a copy of BookkeepingDayGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? transactionCount = null,Object? entries = null,}) {
  return _then(BookkeepingDayGroup(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,transactionCount: null == transactionCount ? _self.transactionCount : transactionCount // ignore: cast_nullable_to_non_nullable
as int,entries: null == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as List<BookkeepingEntry>,
  ));
}

}


/// Adds pattern-matching-related methods to [BookkeepingDayGroup].
extension BookkeepingDayGroupPatterns on BookkeepingDayGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookkeepingDayGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookkeepingDayGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookkeepingDayGroup value)  $default,){
final _that = this;
switch (_that) {
case _BookkeepingDayGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookkeepingDayGroup value)?  $default,){
final _that = this;
switch (_that) {
case _BookkeepingDayGroup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String date,  int transactionCount,  List<BookkeepingEntry> entries)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookkeepingDayGroup() when $default != null:
return $default(_that.date,_that.transactionCount,_that.entries);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String date,  int transactionCount,  List<BookkeepingEntry> entries)  $default,) {final _that = this;
switch (_that) {
case _BookkeepingDayGroup():
return $default(_that.date,_that.transactionCount,_that.entries);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String date,  int transactionCount,  List<BookkeepingEntry> entries)?  $default,) {final _that = this;
switch (_that) {
case _BookkeepingDayGroup() when $default != null:
return $default(_that.date,_that.transactionCount,_that.entries);case _:
  return null;

}
}

}

/// @nodoc


class _BookkeepingDayGroup implements BookkeepingDayGroup {
  const _BookkeepingDayGroup({required this.date, required this.transactionCount, required  List<BookkeepingEntry> entries}): _entries = entries;
  

@override final  String date;
@override final  int transactionCount;
 final  List<BookkeepingEntry> _entries;
@override List<BookkeepingEntry> get entries {
  if (_entries is EqualUnmodifiableListView) return _entries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_entries);
}


/// Create a copy of BookkeepingDayGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookkeepingDayGroupCopyWith<_BookkeepingDayGroup> get copyWith => __$BookkeepingDayGroupCopyWithImpl<_BookkeepingDayGroup>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookkeepingDayGroup&&(identical(other.date, date) || other.date == date)&&(identical(other.transactionCount, transactionCount) || other.transactionCount == transactionCount)&&const DeepCollectionEquality().equals(other.entries, _entries));
}


@override
int get hashCode {
    return Object.hash(runtimeType,date,transactionCount,const DeepCollectionEquality().hash(_entries));
}

@override
String toString() {
    return 'BookkeepingDayGroup(date: $date, transactionCount: $transactionCount, entries: $entries)';
}


}

/// @nodoc
abstract mixin class _$BookkeepingDayGroupCopyWith<$Res> implements $BookkeepingDayGroupCopyWith<$Res> {
  factory _$BookkeepingDayGroupCopyWith(_BookkeepingDayGroup value, $Res Function(_BookkeepingDayGroup) _then) = __$BookkeepingDayGroupCopyWithImpl;
@override @useResult
$Res call({
 String date, int transactionCount, List<BookkeepingEntry> entries
});




}
/// @nodoc
class __$BookkeepingDayGroupCopyWithImpl<$Res>
    implements _$BookkeepingDayGroupCopyWith<$Res> {
  __$BookkeepingDayGroupCopyWithImpl(this._self, this._then);

  final _BookkeepingDayGroup _self;
  final $Res Function(_BookkeepingDayGroup) _then;

/// Create a copy of BookkeepingDayGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? transactionCount = null,Object? entries = null,}) {
  return _then(_BookkeepingDayGroup(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,transactionCount: null == transactionCount ? _self.transactionCount : transactionCount // ignore: cast_nullable_to_non_nullable
as int,entries: null == entries ? _self._entries : entries // ignore: cast_nullable_to_non_nullable
as List<BookkeepingEntry>,
  ));
}


}

/// @nodoc
mixin _$BookkeepingEntry {

 Transaction get transaction; String get runningBalance;
/// Create a copy of BookkeepingEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookkeepingEntryCopyWith<BookkeepingEntry> get copyWith => _$BookkeepingEntryCopyWithImpl<BookkeepingEntry>(this as BookkeepingEntry, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BookkeepingEntry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookkeepingEntry&&(identical(other.transaction, _this.transaction) || other.transaction == _this.transaction)&&(identical(other.runningBalance, _this.runningBalance) || other.runningBalance == _this.runningBalance));
}


@override
int get hashCode {
  final _this = this as BookkeepingEntry;
  return Object.hash(runtimeType,_this.transaction,_this.runningBalance);
}

@override
String toString() {
  final _this = this as BookkeepingEntry;
  return 'BookkeepingEntry(transaction: ${_this.transaction}, runningBalance: ${_this.runningBalance})';
}


}

/// @nodoc
abstract mixin class $BookkeepingEntryCopyWith<$Res>  {
  factory $BookkeepingEntryCopyWith(BookkeepingEntry value, $Res Function(BookkeepingEntry) _then) = _$BookkeepingEntryCopyWithImpl;
@useResult
$Res call({
 Transaction transaction, String runningBalance
});


$TransactionCopyWith<$Res> get transaction;

}
/// @nodoc
class _$BookkeepingEntryCopyWithImpl<$Res>
    implements $BookkeepingEntryCopyWith<$Res> {
  _$BookkeepingEntryCopyWithImpl(this._self, this._then);

  final BookkeepingEntry _self;
  final $Res Function(BookkeepingEntry) _then;

/// Create a copy of BookkeepingEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? transaction = null,Object? runningBalance = null,}) {
  return _then(BookkeepingEntry(
transaction: null == transaction ? _self.transaction : transaction // ignore: cast_nullable_to_non_nullable
as Transaction,runningBalance: null == runningBalance ? _self.runningBalance : runningBalance // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of BookkeepingEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionCopyWith<$Res> get transaction {
  
  return $TransactionCopyWith<$Res>(_self.transaction, (value) {
    return _then(_self.copyWith(transaction: value));
  });
}
}


/// Adds pattern-matching-related methods to [BookkeepingEntry].
extension BookkeepingEntryPatterns on BookkeepingEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookkeepingEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookkeepingEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookkeepingEntry value)  $default,){
final _that = this;
switch (_that) {
case _BookkeepingEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookkeepingEntry value)?  $default,){
final _that = this;
switch (_that) {
case _BookkeepingEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Transaction transaction,  String runningBalance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookkeepingEntry() when $default != null:
return $default(_that.transaction,_that.runningBalance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Transaction transaction,  String runningBalance)  $default,) {final _that = this;
switch (_that) {
case _BookkeepingEntry():
return $default(_that.transaction,_that.runningBalance);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Transaction transaction,  String runningBalance)?  $default,) {final _that = this;
switch (_that) {
case _BookkeepingEntry() when $default != null:
return $default(_that.transaction,_that.runningBalance);case _:
  return null;

}
}

}

/// @nodoc


class _BookkeepingEntry implements BookkeepingEntry {
  const _BookkeepingEntry({required this.transaction, required this.runningBalance});
  

@override final  Transaction transaction;
@override final  String runningBalance;

/// Create a copy of BookkeepingEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookkeepingEntryCopyWith<_BookkeepingEntry> get copyWith => __$BookkeepingEntryCopyWithImpl<_BookkeepingEntry>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookkeepingEntry&&(identical(other.transaction, transaction) || other.transaction == transaction)&&(identical(other.runningBalance, runningBalance) || other.runningBalance == runningBalance));
}


@override
int get hashCode {
    return Object.hash(runtimeType,transaction,runningBalance);
}

@override
String toString() {
    return 'BookkeepingEntry(transaction: $transaction, runningBalance: $runningBalance)';
}


}

/// @nodoc
abstract mixin class _$BookkeepingEntryCopyWith<$Res> implements $BookkeepingEntryCopyWith<$Res> {
  factory _$BookkeepingEntryCopyWith(_BookkeepingEntry value, $Res Function(_BookkeepingEntry) _then) = __$BookkeepingEntryCopyWithImpl;
@override @useResult
$Res call({
 Transaction transaction, String runningBalance
});


@override $TransactionCopyWith<$Res> get transaction;

}
/// @nodoc
class __$BookkeepingEntryCopyWithImpl<$Res>
    implements _$BookkeepingEntryCopyWith<$Res> {
  __$BookkeepingEntryCopyWithImpl(this._self, this._then);

  final _BookkeepingEntry _self;
  final $Res Function(_BookkeepingEntry) _then;

/// Create a copy of BookkeepingEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? transaction = null,Object? runningBalance = null,}) {
  return _then(_BookkeepingEntry(
transaction: null == transaction ? _self.transaction : transaction // ignore: cast_nullable_to_non_nullable
as Transaction,runningBalance: null == runningBalance ? _self.runningBalance : runningBalance // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of BookkeepingEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionCopyWith<$Res> get transaction {
  
  return $TransactionCopyWith<$Res>(_self.transaction, (value) {
    return _then(_self.copyWith(transaction: value));
  });
}
}

// dart format on
