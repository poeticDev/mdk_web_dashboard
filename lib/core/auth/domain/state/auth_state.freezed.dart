// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthState {

 AuthUser? get currentUser; bool get isAuthenticated; bool get isLoadingMe; String? get errorMessage;
/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthStateCopyWith<AuthState> get copyWith => _$AuthStateCopyWithImpl<AuthState>(this as AuthState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthState&&(identical(other.currentUser, currentUser) || other.currentUser == currentUser)&&(identical(other.isAuthenticated, isAuthenticated) || other.isAuthenticated == isAuthenticated)&&(identical(other.isLoadingMe, isLoadingMe) || other.isLoadingMe == isLoadingMe)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,currentUser,isAuthenticated,isLoadingMe,errorMessage);

@override
String toString() {
  return 'AuthState(currentUser: $currentUser, isAuthenticated: $isAuthenticated, isLoadingMe: $isLoadingMe, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $AuthStateCopyWith<$Res>  {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) _then) = _$AuthStateCopyWithImpl;
@useResult
$Res call({
 AuthUser? currentUser, bool isAuthenticated, bool isLoadingMe, String? errorMessage
});


$AuthUserCopyWith<$Res>? get currentUser;

}
/// @nodoc
class _$AuthStateCopyWithImpl<$Res>
    implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._self, this._then);

  final AuthState _self;
  final $Res Function(AuthState) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentUser = freezed,Object? isAuthenticated = null,Object? isLoadingMe = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
currentUser: freezed == currentUser ? _self.currentUser : currentUser // ignore: cast_nullable_to_non_nullable
as AuthUser?,isAuthenticated: null == isAuthenticated ? _self.isAuthenticated : isAuthenticated // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMe: null == isLoadingMe ? _self.isLoadingMe : isLoadingMe // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthUserCopyWith<$Res>? get currentUser {
    if (_self.currentUser == null) {
    return null;
  }

  return $AuthUserCopyWith<$Res>(_self.currentUser!, (value) {
    return _then(_self.copyWith(currentUser: value));
  });
}
}


/// Adds pattern-matching-related methods to [AuthState].
extension AuthStatePatterns on AuthState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthState value)  $default,){
final _that = this;
switch (_that) {
case _AuthState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthState value)?  $default,){
final _that = this;
switch (_that) {
case _AuthState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AuthUser? currentUser,  bool isAuthenticated,  bool isLoadingMe,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthState() when $default != null:
return $default(_that.currentUser,_that.isAuthenticated,_that.isLoadingMe,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AuthUser? currentUser,  bool isAuthenticated,  bool isLoadingMe,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _AuthState():
return $default(_that.currentUser,_that.isAuthenticated,_that.isLoadingMe,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AuthUser? currentUser,  bool isAuthenticated,  bool isLoadingMe,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _AuthState() when $default != null:
return $default(_that.currentUser,_that.isAuthenticated,_that.isLoadingMe,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _AuthState extends AuthState {
  const _AuthState({this.currentUser, this.isAuthenticated = false, this.isLoadingMe = false, this.errorMessage}): super._();
  

@override final  AuthUser? currentUser;
@override@JsonKey() final  bool isAuthenticated;
@override@JsonKey() final  bool isLoadingMe;
@override final  String? errorMessage;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthStateCopyWith<_AuthState> get copyWith => __$AuthStateCopyWithImpl<_AuthState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthState&&(identical(other.currentUser, currentUser) || other.currentUser == currentUser)&&(identical(other.isAuthenticated, isAuthenticated) || other.isAuthenticated == isAuthenticated)&&(identical(other.isLoadingMe, isLoadingMe) || other.isLoadingMe == isLoadingMe)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,currentUser,isAuthenticated,isLoadingMe,errorMessage);

@override
String toString() {
  return 'AuthState(currentUser: $currentUser, isAuthenticated: $isAuthenticated, isLoadingMe: $isLoadingMe, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$AuthStateCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$AuthStateCopyWith(_AuthState value, $Res Function(_AuthState) _then) = __$AuthStateCopyWithImpl;
@override @useResult
$Res call({
 AuthUser? currentUser, bool isAuthenticated, bool isLoadingMe, String? errorMessage
});


@override $AuthUserCopyWith<$Res>? get currentUser;

}
/// @nodoc
class __$AuthStateCopyWithImpl<$Res>
    implements _$AuthStateCopyWith<$Res> {
  __$AuthStateCopyWithImpl(this._self, this._then);

  final _AuthState _self;
  final $Res Function(_AuthState) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentUser = freezed,Object? isAuthenticated = null,Object? isLoadingMe = null,Object? errorMessage = freezed,}) {
  return _then(_AuthState(
currentUser: freezed == currentUser ? _self.currentUser : currentUser // ignore: cast_nullable_to_non_nullable
as AuthUser?,isAuthenticated: null == isAuthenticated ? _self.isAuthenticated : isAuthenticated // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMe: null == isLoadingMe ? _self.isLoadingMe : isLoadingMe // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthUserCopyWith<$Res>? get currentUser {
    if (_self.currentUser == null) {
    return null;
  }

  return $AuthUserCopyWith<$Res>(_self.currentUser!, (value) {
    return _then(_self.copyWith(currentUser: value));
  });
}
}

// dart format on
