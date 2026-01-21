/// ROLE
/// - 강의실 상세 실시간 강의 상태를 정의한다
///
/// RESPONSIBILITY
/// - 진행 중 강의 정보를 보관한다
/// - 로딩/스트리밍/오류 상태를 관리한다
///
/// DEPENDS ON
/// - freezed_annotation
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'classroom_now_state.freezed.dart';

@freezed
abstract class ClassroomNowState with _$ClassroomNowState {
  const ClassroomNowState._();

  const factory ClassroomNowState({
    @Default(false) bool isLoading,
    @Default(false) bool isStreaming,
    @Default(false) bool isInSession,
    String? currentCourseName,
    String? instructorName,
    DateTime? startTime,
    DateTime? endTime,
    String? errorMessage,
  }) = _ClassroomNowState;

  factory ClassroomNowState.initial() => const ClassroomNowState(
        isLoading: true,
      );

  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;
}
