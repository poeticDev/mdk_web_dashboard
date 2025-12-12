// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'classroom_timetable_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 강의실 상세 화면에서 사용하는 캘린더 컨트롤러.

@ProviderFor(ClassroomTimetableController)
const classroomTimetableControllerProvider =
    ClassroomTimetableControllerFamily._();

/// 강의실 상세 화면에서 사용하는 캘린더 컨트롤러.
final class ClassroomTimetableControllerProvider
    extends
        $NotifierProvider<
          ClassroomTimetableController,
          ClassroomTimetableState
        > {
  /// 강의실 상세 화면에서 사용하는 캘린더 컨트롤러.
  const ClassroomTimetableControllerProvider._({
    required ClassroomTimetableControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'classroomTimetableControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$classroomTimetableControllerHash();

  @override
  String toString() {
    return r'classroomTimetableControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ClassroomTimetableController create() => ClassroomTimetableController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ClassroomTimetableState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ClassroomTimetableState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ClassroomTimetableControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$classroomTimetableControllerHash() =>
    r'b6cb0e14010407d406dab3e78e174fd723bb1ccc';

/// 강의실 상세 화면에서 사용하는 캘린더 컨트롤러.

final class ClassroomTimetableControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ClassroomTimetableController,
          ClassroomTimetableState,
          ClassroomTimetableState,
          ClassroomTimetableState,
          String
        > {
  const ClassroomTimetableControllerFamily._()
    : super(
        retry: null,
        name: r'classroomTimetableControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 강의실 상세 화면에서 사용하는 캘린더 컨트롤러.

  ClassroomTimetableControllerProvider call(String classroomId) =>
      ClassroomTimetableControllerProvider._(argument: classroomId, from: this);

  @override
  String toString() => r'classroomTimetableControllerProvider';
}

/// 강의실 상세 화면에서 사용하는 캘린더 컨트롤러.

abstract class _$ClassroomTimetableController
    extends $Notifier<ClassroomTimetableState> {
  late final _$args = ref.$arg as String;
  String get classroomId => _$args;

  ClassroomTimetableState build(String classroomId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref =
        this.ref as $Ref<ClassroomTimetableState, ClassroomTimetableState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ClassroomTimetableState, ClassroomTimetableState>,
              ClassroomTimetableState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
