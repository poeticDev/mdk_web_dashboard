// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'classroom_timetable_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ClassroomTimetableState {

 String get classroomId; List<LectureEntity> get lectures; TimetableDateRange? get visibleRange; LectureType? get filterType; String? get departmentId; String? get instructorId; bool get isLoading; bool get isRefreshing; String? get errorMessage;
/// Create a copy of ClassroomTimetableState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClassroomTimetableStateCopyWith<ClassroomTimetableState> get copyWith => _$ClassroomTimetableStateCopyWithImpl<ClassroomTimetableState>(this as ClassroomTimetableState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClassroomTimetableState&&(identical(other.classroomId, classroomId) || other.classroomId == classroomId)&&const DeepCollectionEquality().equals(other.lectures, lectures)&&(identical(other.visibleRange, visibleRange) || other.visibleRange == visibleRange)&&(identical(other.filterType, filterType) || other.filterType == filterType)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.instructorId, instructorId) || other.instructorId == instructorId)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isRefreshing, isRefreshing) || other.isRefreshing == isRefreshing)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,classroomId,const DeepCollectionEquality().hash(lectures),visibleRange,filterType,departmentId,instructorId,isLoading,isRefreshing,errorMessage);

@override
String toString() {
  return 'ClassroomTimetableState(classroomId: $classroomId, lectures: $lectures, visibleRange: $visibleRange, filterType: $filterType, departmentId: $departmentId, instructorId: $instructorId, isLoading: $isLoading, isRefreshing: $isRefreshing, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $ClassroomTimetableStateCopyWith<$Res>  {
  factory $ClassroomTimetableStateCopyWith(ClassroomTimetableState value, $Res Function(ClassroomTimetableState) _then) = _$ClassroomTimetableStateCopyWithImpl;
@useResult
$Res call({
 String classroomId, List<LectureEntity> lectures, TimetableDateRange? visibleRange, LectureType? filterType, String? departmentId, String? instructorId, bool isLoading, bool isRefreshing, String? errorMessage
});


$TimetableDateRangeCopyWith<$Res>? get visibleRange;

}
/// @nodoc
class _$ClassroomTimetableStateCopyWithImpl<$Res>
    implements $ClassroomTimetableStateCopyWith<$Res> {
  _$ClassroomTimetableStateCopyWithImpl(this._self, this._then);

  final ClassroomTimetableState _self;
  final $Res Function(ClassroomTimetableState) _then;

/// Create a copy of ClassroomTimetableState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? classroomId = null,Object? lectures = null,Object? visibleRange = freezed,Object? filterType = freezed,Object? departmentId = freezed,Object? instructorId = freezed,Object? isLoading = null,Object? isRefreshing = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
classroomId: null == classroomId ? _self.classroomId : classroomId // ignore: cast_nullable_to_non_nullable
as String,lectures: null == lectures ? _self.lectures : lectures // ignore: cast_nullable_to_non_nullable
as List<LectureEntity>,visibleRange: freezed == visibleRange ? _self.visibleRange : visibleRange // ignore: cast_nullable_to_non_nullable
as TimetableDateRange?,filterType: freezed == filterType ? _self.filterType : filterType // ignore: cast_nullable_to_non_nullable
as LectureType?,departmentId: freezed == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String?,instructorId: freezed == instructorId ? _self.instructorId : instructorId // ignore: cast_nullable_to_non_nullable
as String?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isRefreshing: null == isRefreshing ? _self.isRefreshing : isRefreshing // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of ClassroomTimetableState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimetableDateRangeCopyWith<$Res>? get visibleRange {
    if (_self.visibleRange == null) {
    return null;
  }

  return $TimetableDateRangeCopyWith<$Res>(_self.visibleRange!, (value) {
    return _then(_self.copyWith(visibleRange: value));
  });
}
}


/// Adds pattern-matching-related methods to [ClassroomTimetableState].
extension ClassroomTimetableStatePatterns on ClassroomTimetableState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClassroomTimetableState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClassroomTimetableState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClassroomTimetableState value)  $default,){
final _that = this;
switch (_that) {
case _ClassroomTimetableState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClassroomTimetableState value)?  $default,){
final _that = this;
switch (_that) {
case _ClassroomTimetableState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String classroomId,  List<LectureEntity> lectures,  TimetableDateRange? visibleRange,  LectureType? filterType,  String? departmentId,  String? instructorId,  bool isLoading,  bool isRefreshing,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClassroomTimetableState() when $default != null:
return $default(_that.classroomId,_that.lectures,_that.visibleRange,_that.filterType,_that.departmentId,_that.instructorId,_that.isLoading,_that.isRefreshing,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String classroomId,  List<LectureEntity> lectures,  TimetableDateRange? visibleRange,  LectureType? filterType,  String? departmentId,  String? instructorId,  bool isLoading,  bool isRefreshing,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _ClassroomTimetableState():
return $default(_that.classroomId,_that.lectures,_that.visibleRange,_that.filterType,_that.departmentId,_that.instructorId,_that.isLoading,_that.isRefreshing,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String classroomId,  List<LectureEntity> lectures,  TimetableDateRange? visibleRange,  LectureType? filterType,  String? departmentId,  String? instructorId,  bool isLoading,  bool isRefreshing,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _ClassroomTimetableState() when $default != null:
return $default(_that.classroomId,_that.lectures,_that.visibleRange,_that.filterType,_that.departmentId,_that.instructorId,_that.isLoading,_that.isRefreshing,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _ClassroomTimetableState extends ClassroomTimetableState {
  const _ClassroomTimetableState({required this.classroomId, final  List<LectureEntity> lectures = const <LectureEntity>[], this.visibleRange, this.filterType, this.departmentId, this.instructorId, this.isLoading = false, this.isRefreshing = false, this.errorMessage}): _lectures = lectures,super._();
  

@override final  String classroomId;
 final  List<LectureEntity> _lectures;
@override@JsonKey() List<LectureEntity> get lectures {
  if (_lectures is EqualUnmodifiableListView) return _lectures;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lectures);
}

@override final  TimetableDateRange? visibleRange;
@override final  LectureType? filterType;
@override final  String? departmentId;
@override final  String? instructorId;
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isRefreshing;
@override final  String? errorMessage;

/// Create a copy of ClassroomTimetableState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClassroomTimetableStateCopyWith<_ClassroomTimetableState> get copyWith => __$ClassroomTimetableStateCopyWithImpl<_ClassroomTimetableState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClassroomTimetableState&&(identical(other.classroomId, classroomId) || other.classroomId == classroomId)&&const DeepCollectionEquality().equals(other._lectures, _lectures)&&(identical(other.visibleRange, visibleRange) || other.visibleRange == visibleRange)&&(identical(other.filterType, filterType) || other.filterType == filterType)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.instructorId, instructorId) || other.instructorId == instructorId)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isRefreshing, isRefreshing) || other.isRefreshing == isRefreshing)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,classroomId,const DeepCollectionEquality().hash(_lectures),visibleRange,filterType,departmentId,instructorId,isLoading,isRefreshing,errorMessage);

@override
String toString() {
  return 'ClassroomTimetableState(classroomId: $classroomId, lectures: $lectures, visibleRange: $visibleRange, filterType: $filterType, departmentId: $departmentId, instructorId: $instructorId, isLoading: $isLoading, isRefreshing: $isRefreshing, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$ClassroomTimetableStateCopyWith<$Res> implements $ClassroomTimetableStateCopyWith<$Res> {
  factory _$ClassroomTimetableStateCopyWith(_ClassroomTimetableState value, $Res Function(_ClassroomTimetableState) _then) = __$ClassroomTimetableStateCopyWithImpl;
@override @useResult
$Res call({
 String classroomId, List<LectureEntity> lectures, TimetableDateRange? visibleRange, LectureType? filterType, String? departmentId, String? instructorId, bool isLoading, bool isRefreshing, String? errorMessage
});


@override $TimetableDateRangeCopyWith<$Res>? get visibleRange;

}
/// @nodoc
class __$ClassroomTimetableStateCopyWithImpl<$Res>
    implements _$ClassroomTimetableStateCopyWith<$Res> {
  __$ClassroomTimetableStateCopyWithImpl(this._self, this._then);

  final _ClassroomTimetableState _self;
  final $Res Function(_ClassroomTimetableState) _then;

/// Create a copy of ClassroomTimetableState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? classroomId = null,Object? lectures = null,Object? visibleRange = freezed,Object? filterType = freezed,Object? departmentId = freezed,Object? instructorId = freezed,Object? isLoading = null,Object? isRefreshing = null,Object? errorMessage = freezed,}) {
  return _then(_ClassroomTimetableState(
classroomId: null == classroomId ? _self.classroomId : classroomId // ignore: cast_nullable_to_non_nullable
as String,lectures: null == lectures ? _self._lectures : lectures // ignore: cast_nullable_to_non_nullable
as List<LectureEntity>,visibleRange: freezed == visibleRange ? _self.visibleRange : visibleRange // ignore: cast_nullable_to_non_nullable
as TimetableDateRange?,filterType: freezed == filterType ? _self.filterType : filterType // ignore: cast_nullable_to_non_nullable
as LectureType?,departmentId: freezed == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String?,instructorId: freezed == instructorId ? _self.instructorId : instructorId // ignore: cast_nullable_to_non_nullable
as String?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isRefreshing: null == isRefreshing ? _self.isRefreshing : isRefreshing // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of ClassroomTimetableState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimetableDateRangeCopyWith<$Res>? get visibleRange {
    if (_self.visibleRange == null) {
    return null;
  }

  return $TimetableDateRangeCopyWith<$Res>(_self.visibleRange!, (value) {
    return _then(_self.copyWith(visibleRange: value));
  });
}
}

/// @nodoc
mixin _$TimetableDateRange {

 DateTime get from; DateTime get to;
/// Create a copy of TimetableDateRange
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimetableDateRangeCopyWith<TimetableDateRange> get copyWith => _$TimetableDateRangeCopyWithImpl<TimetableDateRange>(this as TimetableDateRange, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimetableDateRange&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to));
}


@override
int get hashCode => Object.hash(runtimeType,from,to);

@override
String toString() {
  return 'TimetableDateRange(from: $from, to: $to)';
}


}

/// @nodoc
abstract mixin class $TimetableDateRangeCopyWith<$Res>  {
  factory $TimetableDateRangeCopyWith(TimetableDateRange value, $Res Function(TimetableDateRange) _then) = _$TimetableDateRangeCopyWithImpl;
@useResult
$Res call({
 DateTime from, DateTime to
});




}
/// @nodoc
class _$TimetableDateRangeCopyWithImpl<$Res>
    implements $TimetableDateRangeCopyWith<$Res> {
  _$TimetableDateRangeCopyWithImpl(this._self, this._then);

  final TimetableDateRange _self;
  final $Res Function(TimetableDateRange) _then;

/// Create a copy of TimetableDateRange
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? from = null,Object? to = null,}) {
  return _then(_self.copyWith(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as DateTime,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TimetableDateRange].
extension TimetableDateRangePatterns on TimetableDateRange {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimetableDateRange value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimetableDateRange() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimetableDateRange value)  $default,){
final _that = this;
switch (_that) {
case _TimetableDateRange():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimetableDateRange value)?  $default,){
final _that = this;
switch (_that) {
case _TimetableDateRange() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime from,  DateTime to)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimetableDateRange() when $default != null:
return $default(_that.from,_that.to);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime from,  DateTime to)  $default,) {final _that = this;
switch (_that) {
case _TimetableDateRange():
return $default(_that.from,_that.to);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime from,  DateTime to)?  $default,) {final _that = this;
switch (_that) {
case _TimetableDateRange() when $default != null:
return $default(_that.from,_that.to);case _:
  return null;

}
}

}

/// @nodoc


class _TimetableDateRange extends TimetableDateRange {
  const _TimetableDateRange({required this.from, required this.to}): super._();
  

@override final  DateTime from;
@override final  DateTime to;

/// Create a copy of TimetableDateRange
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimetableDateRangeCopyWith<_TimetableDateRange> get copyWith => __$TimetableDateRangeCopyWithImpl<_TimetableDateRange>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimetableDateRange&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to));
}


@override
int get hashCode => Object.hash(runtimeType,from,to);

@override
String toString() {
  return 'TimetableDateRange(from: $from, to: $to)';
}


}

/// @nodoc
abstract mixin class _$TimetableDateRangeCopyWith<$Res> implements $TimetableDateRangeCopyWith<$Res> {
  factory _$TimetableDateRangeCopyWith(_TimetableDateRange value, $Res Function(_TimetableDateRange) _then) = __$TimetableDateRangeCopyWithImpl;
@override @useResult
$Res call({
 DateTime from, DateTime to
});




}
/// @nodoc
class __$TimetableDateRangeCopyWithImpl<$Res>
    implements _$TimetableDateRangeCopyWith<$Res> {
  __$TimetableDateRangeCopyWithImpl(this._self, this._then);

  final _TimetableDateRange _self;
  final $Res Function(_TimetableDateRange) _then;

/// Create a copy of TimetableDateRange
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? from = null,Object? to = null,}) {
  return _then(_TimetableDateRange(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as DateTime,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
