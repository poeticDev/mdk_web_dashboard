import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_dashboard/core/timetable/application/state/classroom_timetable_state.dart';
import 'package:web_dashboard/core/timetable/application/timetable_providers.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_type.dart';
import 'package:web_dashboard/core/timetable/domain/repositories/lecture_repository.dart';

part 'classroom_timetable_controller.g.dart';

/// 강의실 상세 화면에서 사용하는 캘린더 컨트롤러.
@riverpod
class ClassroomTimetableController
    extends _$ClassroomTimetableController {
  @override
  ClassroomTimetableState build(String classroomId) {
    return ClassroomTimetableState.initial(classroomId);
  }

  Future<void> loadLectures({TimetableDateRange? range}) async {
    final TimetableDateRange targetRange =
        range ?? state.visibleRange ?? TimetableDateRange.weekOf(DateTime.now());
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      visibleRange: targetRange,
    );
    try {
      final lectures = await ref
          .read(getLecturesUseCaseProvider)
          .execute(
            LectureQuery(
              from: targetRange.from,
              to: targetRange.to,
              classroomId: state.classroomId,
              departmentId: state.departmentId,
              instructorId: state.instructorId,
              type: state.filterType,
            ),
          );
      state = state.copyWith(
        lectures: lectures,
        isLoading: false,
        errorMessage: lectures.isEmpty ? '표시할 일정이 없습니다.' : null,
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '시간표 데이터를 불러오지 못했습니다.',
      );
    }
  }

  void selectLectureType(LectureType? type) {
    state = state.copyWith(filterType: type);
  }

  void setDepartment(String? departmentId) {
    state = state.copyWith(departmentId: departmentId);
  }

  void setInstructor(String? instructorId) {
    state = state.copyWith(instructorId: instructorId);
  }

  Future<void> refresh() async {
    state = state.copyWith(isRefreshing: true);
    await loadLectures();
    state = state.copyWith(isRefreshing: false);
  }

  void updateRange(TimetableDateRange range) {
    state = state.copyWith(visibleRange: range);
  }
}
