// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'classroom_now_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ClassroomNowController)
const classroomNowControllerProvider = ClassroomNowControllerFamily._();

final class ClassroomNowControllerProvider
    extends $NotifierProvider<ClassroomNowController, ClassroomNowState> {
  const ClassroomNowControllerProvider._({
    required ClassroomNowControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'classroomNowControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$classroomNowControllerHash();

  @override
  String toString() {
    return r'classroomNowControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ClassroomNowController create() => ClassroomNowController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ClassroomNowState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ClassroomNowState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ClassroomNowControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$classroomNowControllerHash() =>
    r'1b3dd5d5fd87be4613ac0b8daeac1666639e261d';

final class ClassroomNowControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ClassroomNowController,
          ClassroomNowState,
          ClassroomNowState,
          ClassroomNowState,
          String
        > {
  const ClassroomNowControllerFamily._()
    : super(
        retry: null,
        name: r'classroomNowControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ClassroomNowControllerProvider call(String classroomId) =>
      ClassroomNowControllerProvider._(argument: classroomId, from: this);

  @override
  String toString() => r'classroomNowControllerProvider';
}

abstract class _$ClassroomNowController extends $Notifier<ClassroomNowState> {
  late final _$args = ref.$arg as String;
  String get classroomId => _$args;

  ClassroomNowState build(String classroomId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<ClassroomNowState, ClassroomNowState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ClassroomNowState, ClassroomNowState>,
              ClassroomNowState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
