import 'dart:math' as math;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_dashboard/core/timetable/application/state/classroom_timetable_state.dart';
import 'package:web_dashboard/core/timetable/application/timetable_providers.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_entity.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_status.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_type.dart';
import 'package:web_dashboard/core/timetable/domain/repositories/lecture_repository.dart';

part 'classroom_timetable_controller.g.dart';

/// 강의실 상세 화면에서 사용하는 캘린더 컨트롤러.
@riverpod
class ClassroomTimetableController
    extends _$ClassroomTimetableController {
  /// TODO: 서버 연동 완료 후 false로 변경한다.
  static bool demoDataEnabled = true;
  static const int _demoLecturesPerMonth = 10;
  static const List<String> _demoCourseNames = <String>[
    'AI 개론',
    '스마트보안 실습',
    '디지털 포렌식',
    '임베디드 시스템',
    '클라우드 인프라',
    '데이터 시각화',
    '네트워크 구조',
    'UX 설계',
    'IoT 프로그래밍',
    '머신러닝 응용',
  ];
  static const List<String> _demoProfessors = <String>[
    '김보안 교수',
    '박AI 교수',
    '최데이터 교수',
    '정클라우드 교수',
  ];

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
      final List<LectureEntity> lectures = demoDataEnabled
          ? _generateDemoLectures(targetRange)
          : await ref
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

  List<LectureEntity> _generateDemoLectures(
    TimetableDateRange targetRange,
  ) {
    final DateTime base =
        DateTime(targetRange.from.year, targetRange.from.month, 1);
    final List<DateTime> monthAnchors = <DateTime>[
      base,
      DateTime(base.year, base.month + 1, 1),
    ];
    final List<LectureEntity> samples = <LectureEntity>[];
    for (final DateTime anchor in monthAnchors) {
      final DateTime lastDay =
          DateTime(anchor.year, anchor.month + 1, 0);
      for (int i = 0; i < _demoLecturesPerMonth; i++) {
        final int day = math.min(1 + i * 3, lastDay.day);
        final DateTime start = DateTime(
          anchor.year,
          anchor.month,
          day,
          9 + (i % 3) * 2,
        );
        final DateTime end = start.add(const Duration(hours: 1, minutes: 40));
        samples.add(
          LectureEntity(
            id: '${anchor.month}_$i',
            title: _demoCourseNames[i % _demoCourseNames.length],
            type: LectureType.values[i % LectureType.values.length],
            status: i % 6 == 0
                ? LectureStatus.canceled
                : LectureStatus.scheduled,
            classroomId: state.classroomId,
            classroomName: '공학관 ${state.classroomId}',
            departmentName: '스마트보안학과',
            instructorName: _demoProfessors[i % _demoProfessors.length],
            start: start,
            end: end,
          ),
        );
      }
    }
    return samples
        .where(
          (LectureEntity lecture) => targetRange.contains(lecture.start),
        )
        .toList();
  }
}
