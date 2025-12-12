import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_entity.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_type.dart';

part 'classroom_timetable_state.freezed.dart';

/// 강의실 시간표 화면이 구독하는 상태 모델.
@freezed
abstract class ClassroomTimetableState with _$ClassroomTimetableState {
  const ClassroomTimetableState._();

  const factory ClassroomTimetableState({
    required String classroomId,
    @Default(<LectureEntity>[]) List<LectureEntity> lectures,
    TimetableDateRange? visibleRange,
    LectureType? filterType,
    String? departmentId,
    String? instructorId,
    @Default(false) bool isLoading,
    @Default(false) bool isRefreshing,
    String? errorMessage,
  }) = _ClassroomTimetableState;

  factory ClassroomTimetableState.initial(String classroomId) =>
      ClassroomTimetableState(
        classroomId: classroomId,
        visibleRange: TimetableDateRange.weekOf(DateTime.now()),
      );

  bool get hasError => (errorMessage ?? '').isNotEmpty;
}

/// 주간/월간 등 기간을 나타내는 값 객체.
@freezed
abstract class TimetableDateRange with _$TimetableDateRange {
  const TimetableDateRange._();

  const factory TimetableDateRange({
    required DateTime from,
    required DateTime to,
  }) = _TimetableDateRange;

  factory TimetableDateRange.weekOf(DateTime anchor) {
    final DateTime monday =
        anchor.subtract(Duration(days: anchor.weekday - DateTime.monday));
    final DateTime sunday = monday.add(const Duration(days: 6));
    return TimetableDateRange(
      from: DateTime(monday.year, monday.month, monday.day),
      to: DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59),
    );
  }

  bool contains(DateTime moment) {
    final bool startsBefore = !moment.isBefore(from);
    final bool endsAfter = !moment.isAfter(to);
    return startsBefore && endsAfter;
  }
}
