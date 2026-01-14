// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DashboardFilterState {

 String get query; DashboardActivityStatus? get activityStatus; DashboardLinkStatus? get linkStatus; Set<String> get departmentIds; Set<String> get buildingIds;
/// Create a copy of DashboardFilterState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardFilterStateCopyWith<DashboardFilterState> get copyWith => _$DashboardFilterStateCopyWithImpl<DashboardFilterState>(this as DashboardFilterState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardFilterState&&(identical(other.query, query) || other.query == query)&&(identical(other.activityStatus, activityStatus) || other.activityStatus == activityStatus)&&(identical(other.linkStatus, linkStatus) || other.linkStatus == linkStatus)&&const DeepCollectionEquality().equals(other.departmentIds, departmentIds)&&const DeepCollectionEquality().equals(other.buildingIds, buildingIds));
}


@override
int get hashCode => Object.hash(runtimeType,query,activityStatus,linkStatus,const DeepCollectionEquality().hash(departmentIds),const DeepCollectionEquality().hash(buildingIds));

@override
String toString() {
  return 'DashboardFilterState(query: $query, activityStatus: $activityStatus, linkStatus: $linkStatus, departmentIds: $departmentIds, buildingIds: $buildingIds)';
}


}

/// @nodoc
abstract mixin class $DashboardFilterStateCopyWith<$Res>  {
  factory $DashboardFilterStateCopyWith(DashboardFilterState value, $Res Function(DashboardFilterState) _then) = _$DashboardFilterStateCopyWithImpl;
@useResult
$Res call({
 String query, DashboardActivityStatus? activityStatus, DashboardLinkStatus? linkStatus, Set<String> departmentIds, Set<String> buildingIds
});




}
/// @nodoc
class _$DashboardFilterStateCopyWithImpl<$Res>
    implements $DashboardFilterStateCopyWith<$Res> {
  _$DashboardFilterStateCopyWithImpl(this._self, this._then);

  final DashboardFilterState _self;
  final $Res Function(DashboardFilterState) _then;

/// Create a copy of DashboardFilterState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? query = null,Object? activityStatus = freezed,Object? linkStatus = freezed,Object? departmentIds = null,Object? buildingIds = null,}) {
  return _then(_self.copyWith(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,activityStatus: freezed == activityStatus ? _self.activityStatus : activityStatus // ignore: cast_nullable_to_non_nullable
as DashboardActivityStatus?,linkStatus: freezed == linkStatus ? _self.linkStatus : linkStatus // ignore: cast_nullable_to_non_nullable
as DashboardLinkStatus?,departmentIds: null == departmentIds ? _self.departmentIds : departmentIds // ignore: cast_nullable_to_non_nullable
as Set<String>,buildingIds: null == buildingIds ? _self.buildingIds : buildingIds // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardFilterState].
extension DashboardFilterStatePatterns on DashboardFilterState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardFilterState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardFilterState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardFilterState value)  $default,){
final _that = this;
switch (_that) {
case _DashboardFilterState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardFilterState value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardFilterState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String query,  DashboardActivityStatus? activityStatus,  DashboardLinkStatus? linkStatus,  Set<String> departmentIds,  Set<String> buildingIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardFilterState() when $default != null:
return $default(_that.query,_that.activityStatus,_that.linkStatus,_that.departmentIds,_that.buildingIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String query,  DashboardActivityStatus? activityStatus,  DashboardLinkStatus? linkStatus,  Set<String> departmentIds,  Set<String> buildingIds)  $default,) {final _that = this;
switch (_that) {
case _DashboardFilterState():
return $default(_that.query,_that.activityStatus,_that.linkStatus,_that.departmentIds,_that.buildingIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String query,  DashboardActivityStatus? activityStatus,  DashboardLinkStatus? linkStatus,  Set<String> departmentIds,  Set<String> buildingIds)?  $default,) {final _that = this;
switch (_that) {
case _DashboardFilterState() when $default != null:
return $default(_that.query,_that.activityStatus,_that.linkStatus,_that.departmentIds,_that.buildingIds);case _:
  return null;

}
}

}

/// @nodoc


class _DashboardFilterState extends DashboardFilterState {
  const _DashboardFilterState({this.query = _emptyQuery, this.activityStatus, this.linkStatus, final  Set<String> departmentIds = const <String>{}, final  Set<String> buildingIds = const <String>{}}): _departmentIds = departmentIds,_buildingIds = buildingIds,super._();
  

@override@JsonKey() final  String query;
@override final  DashboardActivityStatus? activityStatus;
@override final  DashboardLinkStatus? linkStatus;
 final  Set<String> _departmentIds;
@override@JsonKey() Set<String> get departmentIds {
  if (_departmentIds is EqualUnmodifiableSetView) return _departmentIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_departmentIds);
}

 final  Set<String> _buildingIds;
@override@JsonKey() Set<String> get buildingIds {
  if (_buildingIds is EqualUnmodifiableSetView) return _buildingIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_buildingIds);
}


/// Create a copy of DashboardFilterState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardFilterStateCopyWith<_DashboardFilterState> get copyWith => __$DashboardFilterStateCopyWithImpl<_DashboardFilterState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardFilterState&&(identical(other.query, query) || other.query == query)&&(identical(other.activityStatus, activityStatus) || other.activityStatus == activityStatus)&&(identical(other.linkStatus, linkStatus) || other.linkStatus == linkStatus)&&const DeepCollectionEquality().equals(other._departmentIds, _departmentIds)&&const DeepCollectionEquality().equals(other._buildingIds, _buildingIds));
}


@override
int get hashCode => Object.hash(runtimeType,query,activityStatus,linkStatus,const DeepCollectionEquality().hash(_departmentIds),const DeepCollectionEquality().hash(_buildingIds));

@override
String toString() {
  return 'DashboardFilterState(query: $query, activityStatus: $activityStatus, linkStatus: $linkStatus, departmentIds: $departmentIds, buildingIds: $buildingIds)';
}


}

/// @nodoc
abstract mixin class _$DashboardFilterStateCopyWith<$Res> implements $DashboardFilterStateCopyWith<$Res> {
  factory _$DashboardFilterStateCopyWith(_DashboardFilterState value, $Res Function(_DashboardFilterState) _then) = __$DashboardFilterStateCopyWithImpl;
@override @useResult
$Res call({
 String query, DashboardActivityStatus? activityStatus, DashboardLinkStatus? linkStatus, Set<String> departmentIds, Set<String> buildingIds
});




}
/// @nodoc
class __$DashboardFilterStateCopyWithImpl<$Res>
    implements _$DashboardFilterStateCopyWith<$Res> {
  __$DashboardFilterStateCopyWithImpl(this._self, this._then);

  final _DashboardFilterState _self;
  final $Res Function(_DashboardFilterState) _then;

/// Create a copy of DashboardFilterState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? query = null,Object? activityStatus = freezed,Object? linkStatus = freezed,Object? departmentIds = null,Object? buildingIds = null,}) {
  return _then(_DashboardFilterState(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,activityStatus: freezed == activityStatus ? _self.activityStatus : activityStatus // ignore: cast_nullable_to_non_nullable
as DashboardActivityStatus?,linkStatus: freezed == linkStatus ? _self.linkStatus : linkStatus // ignore: cast_nullable_to_non_nullable
as DashboardLinkStatus?,departmentIds: null == departmentIds ? _self._departmentIds : departmentIds // ignore: cast_nullable_to_non_nullable
as Set<String>,buildingIds: null == buildingIds ? _self._buildingIds : buildingIds // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}


}

/// @nodoc
mixin _$DashboardState {

 List<DashboardClassroomCardViewModel> get cards; DashboardMetricsViewModel? get metrics; DashboardFilterState get filters; bool get isLoading; bool get isStreaming; DateTime? get lastUpdatedAt; String? get errorMessage;
/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardStateCopyWith<DashboardState> get copyWith => _$DashboardStateCopyWithImpl<DashboardState>(this as DashboardState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardState&&const DeepCollectionEquality().equals(other.cards, cards)&&(identical(other.metrics, metrics) || other.metrics == metrics)&&(identical(other.filters, filters) || other.filters == filters)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isStreaming, isStreaming) || other.isStreaming == isStreaming)&&(identical(other.lastUpdatedAt, lastUpdatedAt) || other.lastUpdatedAt == lastUpdatedAt)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(cards),metrics,filters,isLoading,isStreaming,lastUpdatedAt,errorMessage);

@override
String toString() {
  return 'DashboardState(cards: $cards, metrics: $metrics, filters: $filters, isLoading: $isLoading, isStreaming: $isStreaming, lastUpdatedAt: $lastUpdatedAt, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $DashboardStateCopyWith<$Res>  {
  factory $DashboardStateCopyWith(DashboardState value, $Res Function(DashboardState) _then) = _$DashboardStateCopyWithImpl;
@useResult
$Res call({
 List<DashboardClassroomCardViewModel> cards, DashboardMetricsViewModel? metrics, DashboardFilterState filters, bool isLoading, bool isStreaming, DateTime? lastUpdatedAt, String? errorMessage
});


$DashboardFilterStateCopyWith<$Res> get filters;

}
/// @nodoc
class _$DashboardStateCopyWithImpl<$Res>
    implements $DashboardStateCopyWith<$Res> {
  _$DashboardStateCopyWithImpl(this._self, this._then);

  final DashboardState _self;
  final $Res Function(DashboardState) _then;

/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cards = null,Object? metrics = freezed,Object? filters = null,Object? isLoading = null,Object? isStreaming = null,Object? lastUpdatedAt = freezed,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
cards: null == cards ? _self.cards : cards // ignore: cast_nullable_to_non_nullable
as List<DashboardClassroomCardViewModel>,metrics: freezed == metrics ? _self.metrics : metrics // ignore: cast_nullable_to_non_nullable
as DashboardMetricsViewModel?,filters: null == filters ? _self.filters : filters // ignore: cast_nullable_to_non_nullable
as DashboardFilterState,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isStreaming: null == isStreaming ? _self.isStreaming : isStreaming // ignore: cast_nullable_to_non_nullable
as bool,lastUpdatedAt: freezed == lastUpdatedAt ? _self.lastUpdatedAt : lastUpdatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardFilterStateCopyWith<$Res> get filters {
  
  return $DashboardFilterStateCopyWith<$Res>(_self.filters, (value) {
    return _then(_self.copyWith(filters: value));
  });
}
}


/// Adds pattern-matching-related methods to [DashboardState].
extension DashboardStatePatterns on DashboardState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardState value)  $default,){
final _that = this;
switch (_that) {
case _DashboardState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardState value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<DashboardClassroomCardViewModel> cards,  DashboardMetricsViewModel? metrics,  DashboardFilterState filters,  bool isLoading,  bool isStreaming,  DateTime? lastUpdatedAt,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardState() when $default != null:
return $default(_that.cards,_that.metrics,_that.filters,_that.isLoading,_that.isStreaming,_that.lastUpdatedAt,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<DashboardClassroomCardViewModel> cards,  DashboardMetricsViewModel? metrics,  DashboardFilterState filters,  bool isLoading,  bool isStreaming,  DateTime? lastUpdatedAt,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _DashboardState():
return $default(_that.cards,_that.metrics,_that.filters,_that.isLoading,_that.isStreaming,_that.lastUpdatedAt,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<DashboardClassroomCardViewModel> cards,  DashboardMetricsViewModel? metrics,  DashboardFilterState filters,  bool isLoading,  bool isStreaming,  DateTime? lastUpdatedAt,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _DashboardState() when $default != null:
return $default(_that.cards,_that.metrics,_that.filters,_that.isLoading,_that.isStreaming,_that.lastUpdatedAt,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _DashboardState extends DashboardState {
  const _DashboardState({final  List<DashboardClassroomCardViewModel> cards = const <DashboardClassroomCardViewModel>[], this.metrics, this.filters = const DashboardFilterState(), this.isLoading = false, this.isStreaming = false, this.lastUpdatedAt, this.errorMessage}): _cards = cards,super._();
  

 final  List<DashboardClassroomCardViewModel> _cards;
@override@JsonKey() List<DashboardClassroomCardViewModel> get cards {
  if (_cards is EqualUnmodifiableListView) return _cards;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cards);
}

@override final  DashboardMetricsViewModel? metrics;
@override@JsonKey() final  DashboardFilterState filters;
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isStreaming;
@override final  DateTime? lastUpdatedAt;
@override final  String? errorMessage;

/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardStateCopyWith<_DashboardState> get copyWith => __$DashboardStateCopyWithImpl<_DashboardState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardState&&const DeepCollectionEquality().equals(other._cards, _cards)&&(identical(other.metrics, metrics) || other.metrics == metrics)&&(identical(other.filters, filters) || other.filters == filters)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isStreaming, isStreaming) || other.isStreaming == isStreaming)&&(identical(other.lastUpdatedAt, lastUpdatedAt) || other.lastUpdatedAt == lastUpdatedAt)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_cards),metrics,filters,isLoading,isStreaming,lastUpdatedAt,errorMessage);

@override
String toString() {
  return 'DashboardState(cards: $cards, metrics: $metrics, filters: $filters, isLoading: $isLoading, isStreaming: $isStreaming, lastUpdatedAt: $lastUpdatedAt, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$DashboardStateCopyWith<$Res> implements $DashboardStateCopyWith<$Res> {
  factory _$DashboardStateCopyWith(_DashboardState value, $Res Function(_DashboardState) _then) = __$DashboardStateCopyWithImpl;
@override @useResult
$Res call({
 List<DashboardClassroomCardViewModel> cards, DashboardMetricsViewModel? metrics, DashboardFilterState filters, bool isLoading, bool isStreaming, DateTime? lastUpdatedAt, String? errorMessage
});


@override $DashboardFilterStateCopyWith<$Res> get filters;

}
/// @nodoc
class __$DashboardStateCopyWithImpl<$Res>
    implements _$DashboardStateCopyWith<$Res> {
  __$DashboardStateCopyWithImpl(this._self, this._then);

  final _DashboardState _self;
  final $Res Function(_DashboardState) _then;

/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cards = null,Object? metrics = freezed,Object? filters = null,Object? isLoading = null,Object? isStreaming = null,Object? lastUpdatedAt = freezed,Object? errorMessage = freezed,}) {
  return _then(_DashboardState(
cards: null == cards ? _self._cards : cards // ignore: cast_nullable_to_non_nullable
as List<DashboardClassroomCardViewModel>,metrics: freezed == metrics ? _self.metrics : metrics // ignore: cast_nullable_to_non_nullable
as DashboardMetricsViewModel?,filters: null == filters ? _self.filters : filters // ignore: cast_nullable_to_non_nullable
as DashboardFilterState,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isStreaming: null == isStreaming ? _self.isStreaming : isStreaming // ignore: cast_nullable_to_non_nullable
as bool,lastUpdatedAt: freezed == lastUpdatedAt ? _self.lastUpdatedAt : lastUpdatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardFilterStateCopyWith<$Res> get filters {
  
  return $DashboardFilterStateCopyWith<$Res>(_self.filters, (value) {
    return _then(_self.copyWith(filters: value));
  });
}
}

// dart format on
