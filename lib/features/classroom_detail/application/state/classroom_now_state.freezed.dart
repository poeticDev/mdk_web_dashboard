// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'classroom_now_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ClassroomNowState {

 bool get isLoading; bool get isStreaming; bool get isInSession; String? get currentCourseName; String? get instructorName; DateTime? get startTime; DateTime? get endTime; String? get errorMessage;
/// Create a copy of ClassroomNowState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClassroomNowStateCopyWith<ClassroomNowState> get copyWith => _$ClassroomNowStateCopyWithImpl<ClassroomNowState>(this as ClassroomNowState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClassroomNowState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isStreaming, isStreaming) || other.isStreaming == isStreaming)&&(identical(other.isInSession, isInSession) || other.isInSession == isInSession)&&(identical(other.currentCourseName, currentCourseName) || other.currentCourseName == currentCourseName)&&(identical(other.instructorName, instructorName) || other.instructorName == instructorName)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,isStreaming,isInSession,currentCourseName,instructorName,startTime,endTime,errorMessage);

@override
String toString() {
  return 'ClassroomNowState(isLoading: $isLoading, isStreaming: $isStreaming, isInSession: $isInSession, currentCourseName: $currentCourseName, instructorName: $instructorName, startTime: $startTime, endTime: $endTime, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $ClassroomNowStateCopyWith<$Res>  {
  factory $ClassroomNowStateCopyWith(ClassroomNowState value, $Res Function(ClassroomNowState) _then) = _$ClassroomNowStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool isStreaming, bool isInSession, String? currentCourseName, String? instructorName, DateTime? startTime, DateTime? endTime, String? errorMessage
});




}
/// @nodoc
class _$ClassroomNowStateCopyWithImpl<$Res>
    implements $ClassroomNowStateCopyWith<$Res> {
  _$ClassroomNowStateCopyWithImpl(this._self, this._then);

  final ClassroomNowState _self;
  final $Res Function(ClassroomNowState) _then;

/// Create a copy of ClassroomNowState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? isStreaming = null,Object? isInSession = null,Object? currentCourseName = freezed,Object? instructorName = freezed,Object? startTime = freezed,Object? endTime = freezed,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isStreaming: null == isStreaming ? _self.isStreaming : isStreaming // ignore: cast_nullable_to_non_nullable
as bool,isInSession: null == isInSession ? _self.isInSession : isInSession // ignore: cast_nullable_to_non_nullable
as bool,currentCourseName: freezed == currentCourseName ? _self.currentCourseName : currentCourseName // ignore: cast_nullable_to_non_nullable
as String?,instructorName: freezed == instructorName ? _self.instructorName : instructorName // ignore: cast_nullable_to_non_nullable
as String?,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime?,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ClassroomNowState].
extension ClassroomNowStatePatterns on ClassroomNowState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClassroomNowState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClassroomNowState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClassroomNowState value)  $default,){
final _that = this;
switch (_that) {
case _ClassroomNowState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClassroomNowState value)?  $default,){
final _that = this;
switch (_that) {
case _ClassroomNowState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool isStreaming,  bool isInSession,  String? currentCourseName,  String? instructorName,  DateTime? startTime,  DateTime? endTime,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClassroomNowState() when $default != null:
return $default(_that.isLoading,_that.isStreaming,_that.isInSession,_that.currentCourseName,_that.instructorName,_that.startTime,_that.endTime,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool isStreaming,  bool isInSession,  String? currentCourseName,  String? instructorName,  DateTime? startTime,  DateTime? endTime,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _ClassroomNowState():
return $default(_that.isLoading,_that.isStreaming,_that.isInSession,_that.currentCourseName,_that.instructorName,_that.startTime,_that.endTime,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool isStreaming,  bool isInSession,  String? currentCourseName,  String? instructorName,  DateTime? startTime,  DateTime? endTime,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _ClassroomNowState() when $default != null:
return $default(_that.isLoading,_that.isStreaming,_that.isInSession,_that.currentCourseName,_that.instructorName,_that.startTime,_that.endTime,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _ClassroomNowState extends ClassroomNowState {
  const _ClassroomNowState({this.isLoading = false, this.isStreaming = false, this.isInSession = false, this.currentCourseName, this.instructorName, this.startTime, this.endTime, this.errorMessage}): super._();
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isStreaming;
@override@JsonKey() final  bool isInSession;
@override final  String? currentCourseName;
@override final  String? instructorName;
@override final  DateTime? startTime;
@override final  DateTime? endTime;
@override final  String? errorMessage;

/// Create a copy of ClassroomNowState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClassroomNowStateCopyWith<_ClassroomNowState> get copyWith => __$ClassroomNowStateCopyWithImpl<_ClassroomNowState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClassroomNowState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isStreaming, isStreaming) || other.isStreaming == isStreaming)&&(identical(other.isInSession, isInSession) || other.isInSession == isInSession)&&(identical(other.currentCourseName, currentCourseName) || other.currentCourseName == currentCourseName)&&(identical(other.instructorName, instructorName) || other.instructorName == instructorName)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,isStreaming,isInSession,currentCourseName,instructorName,startTime,endTime,errorMessage);

@override
String toString() {
  return 'ClassroomNowState(isLoading: $isLoading, isStreaming: $isStreaming, isInSession: $isInSession, currentCourseName: $currentCourseName, instructorName: $instructorName, startTime: $startTime, endTime: $endTime, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$ClassroomNowStateCopyWith<$Res> implements $ClassroomNowStateCopyWith<$Res> {
  factory _$ClassroomNowStateCopyWith(_ClassroomNowState value, $Res Function(_ClassroomNowState) _then) = __$ClassroomNowStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool isStreaming, bool isInSession, String? currentCourseName, String? instructorName, DateTime? startTime, DateTime? endTime, String? errorMessage
});




}
/// @nodoc
class __$ClassroomNowStateCopyWithImpl<$Res>
    implements _$ClassroomNowStateCopyWith<$Res> {
  __$ClassroomNowStateCopyWithImpl(this._self, this._then);

  final _ClassroomNowState _self;
  final $Res Function(_ClassroomNowState) _then;

/// Create a copy of ClassroomNowState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? isStreaming = null,Object? isInSession = null,Object? currentCourseName = freezed,Object? instructorName = freezed,Object? startTime = freezed,Object? endTime = freezed,Object? errorMessage = freezed,}) {
  return _then(_ClassroomNowState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isStreaming: null == isStreaming ? _self.isStreaming : isStreaming // ignore: cast_nullable_to_non_nullable
as bool,isInSession: null == isInSession ? _self.isInSession : isInSession // ignore: cast_nullable_to_non_nullable
as bool,currentCourseName: freezed == currentCourseName ? _self.currentCourseName : currentCourseName // ignore: cast_nullable_to_non_nullable
as String?,instructorName: freezed == instructorName ? _self.instructorName : instructorName // ignore: cast_nullable_to_non_nullable
as String?,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime?,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
