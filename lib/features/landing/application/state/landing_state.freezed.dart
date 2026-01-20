// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'landing_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LandingRoute {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LandingRoute);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LandingRoute()';
}


}

/// @nodoc
class $LandingRouteCopyWith<$Res>  {
$LandingRouteCopyWith(LandingRoute _, $Res Function(LandingRoute) __);
}


/// Adds pattern-matching-related methods to [LandingRoute].
extension LandingRoutePatterns on LandingRoute {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _LandingRouteDashboard value)?  dashboard,TResult Function( _LandingRouteClassroomDetail value)?  classroomDetail,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LandingRouteDashboard() when dashboard != null:
return dashboard(_that);case _LandingRouteClassroomDetail() when classroomDetail != null:
return classroomDetail(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _LandingRouteDashboard value)  dashboard,required TResult Function( _LandingRouteClassroomDetail value)  classroomDetail,}){
final _that = this;
switch (_that) {
case _LandingRouteDashboard():
return dashboard(_that);case _LandingRouteClassroomDetail():
return classroomDetail(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _LandingRouteDashboard value)?  dashboard,TResult? Function( _LandingRouteClassroomDetail value)?  classroomDetail,}){
final _that = this;
switch (_that) {
case _LandingRouteDashboard() when dashboard != null:
return dashboard(_that);case _LandingRouteClassroomDetail() when classroomDetail != null:
return classroomDetail(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  dashboard,TResult Function( String classroomId)?  classroomDetail,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LandingRouteDashboard() when dashboard != null:
return dashboard();case _LandingRouteClassroomDetail() when classroomDetail != null:
return classroomDetail(_that.classroomId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  dashboard,required TResult Function( String classroomId)  classroomDetail,}) {final _that = this;
switch (_that) {
case _LandingRouteDashboard():
return dashboard();case _LandingRouteClassroomDetail():
return classroomDetail(_that.classroomId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  dashboard,TResult? Function( String classroomId)?  classroomDetail,}) {final _that = this;
switch (_that) {
case _LandingRouteDashboard() when dashboard != null:
return dashboard();case _LandingRouteClassroomDetail() when classroomDetail != null:
return classroomDetail(_that.classroomId);case _:
  return null;

}
}

}

/// @nodoc


class _LandingRouteDashboard implements LandingRoute {
  const _LandingRouteDashboard();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LandingRouteDashboard);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LandingRoute.dashboard()';
}


}




/// @nodoc


class _LandingRouteClassroomDetail implements LandingRoute {
  const _LandingRouteClassroomDetail({required this.classroomId});
  

 final  String classroomId;

/// Create a copy of LandingRoute
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LandingRouteClassroomDetailCopyWith<_LandingRouteClassroomDetail> get copyWith => __$LandingRouteClassroomDetailCopyWithImpl<_LandingRouteClassroomDetail>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LandingRouteClassroomDetail&&(identical(other.classroomId, classroomId) || other.classroomId == classroomId));
}


@override
int get hashCode => Object.hash(runtimeType,classroomId);

@override
String toString() {
  return 'LandingRoute.classroomDetail(classroomId: $classroomId)';
}


}

/// @nodoc
abstract mixin class _$LandingRouteClassroomDetailCopyWith<$Res> implements $LandingRouteCopyWith<$Res> {
  factory _$LandingRouteClassroomDetailCopyWith(_LandingRouteClassroomDetail value, $Res Function(_LandingRouteClassroomDetail) _then) = __$LandingRouteClassroomDetailCopyWithImpl;
@useResult
$Res call({
 String classroomId
});




}
/// @nodoc
class __$LandingRouteClassroomDetailCopyWithImpl<$Res>
    implements _$LandingRouteClassroomDetailCopyWith<$Res> {
  __$LandingRouteClassroomDetailCopyWithImpl(this._self, this._then);

  final _LandingRouteClassroomDetail _self;
  final $Res Function(_LandingRouteClassroomDetail) _then;

/// Create a copy of LandingRoute
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? classroomId = null,}) {
  return _then(_LandingRouteClassroomDetail(
classroomId: null == classroomId ? _self.classroomId : classroomId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$LandingState {

 LandingStep get step; String? get message; String? get errorMessage; LandingRoute? get nextRoute;
/// Create a copy of LandingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LandingStateCopyWith<LandingState> get copyWith => _$LandingStateCopyWithImpl<LandingState>(this as LandingState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LandingState&&(identical(other.step, step) || other.step == step)&&(identical(other.message, message) || other.message == message)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.nextRoute, nextRoute) || other.nextRoute == nextRoute));
}


@override
int get hashCode => Object.hash(runtimeType,step,message,errorMessage,nextRoute);

@override
String toString() {
  return 'LandingState(step: $step, message: $message, errorMessage: $errorMessage, nextRoute: $nextRoute)';
}


}

/// @nodoc
abstract mixin class $LandingStateCopyWith<$Res>  {
  factory $LandingStateCopyWith(LandingState value, $Res Function(LandingState) _then) = _$LandingStateCopyWithImpl;
@useResult
$Res call({
 LandingStep step, String? message, String? errorMessage, LandingRoute? nextRoute
});


$LandingRouteCopyWith<$Res>? get nextRoute;

}
/// @nodoc
class _$LandingStateCopyWithImpl<$Res>
    implements $LandingStateCopyWith<$Res> {
  _$LandingStateCopyWithImpl(this._self, this._then);

  final LandingState _self;
  final $Res Function(LandingState) _then;

/// Create a copy of LandingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? step = null,Object? message = freezed,Object? errorMessage = freezed,Object? nextRoute = freezed,}) {
  return _then(_self.copyWith(
step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as LandingStep,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,nextRoute: freezed == nextRoute ? _self.nextRoute : nextRoute // ignore: cast_nullable_to_non_nullable
as LandingRoute?,
  ));
}
/// Create a copy of LandingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LandingRouteCopyWith<$Res>? get nextRoute {
    if (_self.nextRoute == null) {
    return null;
  }

  return $LandingRouteCopyWith<$Res>(_self.nextRoute!, (value) {
    return _then(_self.copyWith(nextRoute: value));
  });
}
}


/// Adds pattern-matching-related methods to [LandingState].
extension LandingStatePatterns on LandingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LandingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LandingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LandingState value)  $default,){
final _that = this;
switch (_that) {
case _LandingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LandingState value)?  $default,){
final _that = this;
switch (_that) {
case _LandingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LandingStep step,  String? message,  String? errorMessage,  LandingRoute? nextRoute)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LandingState() when $default != null:
return $default(_that.step,_that.message,_that.errorMessage,_that.nextRoute);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LandingStep step,  String? message,  String? errorMessage,  LandingRoute? nextRoute)  $default,) {final _that = this;
switch (_that) {
case _LandingState():
return $default(_that.step,_that.message,_that.errorMessage,_that.nextRoute);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LandingStep step,  String? message,  String? errorMessage,  LandingRoute? nextRoute)?  $default,) {final _that = this;
switch (_that) {
case _LandingState() when $default != null:
return $default(_that.step,_that.message,_that.errorMessage,_that.nextRoute);case _:
  return null;

}
}

}

/// @nodoc


class _LandingState extends LandingState {
  const _LandingState({this.step = LandingStep.checkingSession, this.message, this.errorMessage, this.nextRoute}): super._();
  

@override@JsonKey() final  LandingStep step;
@override final  String? message;
@override final  String? errorMessage;
@override final  LandingRoute? nextRoute;

/// Create a copy of LandingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LandingStateCopyWith<_LandingState> get copyWith => __$LandingStateCopyWithImpl<_LandingState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LandingState&&(identical(other.step, step) || other.step == step)&&(identical(other.message, message) || other.message == message)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.nextRoute, nextRoute) || other.nextRoute == nextRoute));
}


@override
int get hashCode => Object.hash(runtimeType,step,message,errorMessage,nextRoute);

@override
String toString() {
  return 'LandingState(step: $step, message: $message, errorMessage: $errorMessage, nextRoute: $nextRoute)';
}


}

/// @nodoc
abstract mixin class _$LandingStateCopyWith<$Res> implements $LandingStateCopyWith<$Res> {
  factory _$LandingStateCopyWith(_LandingState value, $Res Function(_LandingState) _then) = __$LandingStateCopyWithImpl;
@override @useResult
$Res call({
 LandingStep step, String? message, String? errorMessage, LandingRoute? nextRoute
});


@override $LandingRouteCopyWith<$Res>? get nextRoute;

}
/// @nodoc
class __$LandingStateCopyWithImpl<$Res>
    implements _$LandingStateCopyWith<$Res> {
  __$LandingStateCopyWithImpl(this._self, this._then);

  final _LandingState _self;
  final $Res Function(_LandingState) _then;

/// Create a copy of LandingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? step = null,Object? message = freezed,Object? errorMessage = freezed,Object? nextRoute = freezed,}) {
  return _then(_LandingState(
step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as LandingStep,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,nextRoute: freezed == nextRoute ? _self.nextRoute : nextRoute // ignore: cast_nullable_to_non_nullable
as LandingRoute?,
  ));
}

/// Create a copy of LandingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LandingRouteCopyWith<$Res>? get nextRoute {
    if (_self.nextRoute == null) {
    return null;
  }

  return $LandingRouteCopyWith<$Res>(_self.nextRoute!, (value) {
    return _then(_self.copyWith(nextRoute: value));
  });
}
}

// dart format on
