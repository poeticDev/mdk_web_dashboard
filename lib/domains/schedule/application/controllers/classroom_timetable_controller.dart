import 'dart:math' as math;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_dashboard/domains/schedule/application/state/classroom_timetable_state.dart';
import 'package:web_dashboard/domains/schedule/application/timetable_providers.dart';
import 'package:web_dashboard/domains/schedule/application/usecases/save_lecture_usecase.dart';
import 'package:web_dashboard/domains/schedule/domain/entities/lecture_occurrence_entity.dart';
import 'package:web_dashboard/domains/schedule/domain/entities/lecture_occurrence_query.dart';
import 'package:web_dashboard/domains/schedule/domain/entities/lecture_status.dart';
import 'package:web_dashboard/domains/schedule/domain/entities/lecture_type.dart';
import 'package:web_dashboard/domains/schedule/domain/repositories/lecture_origin_repository.dart'
    show LectureField, LectureOriginDeleteInput, LectureOriginWriteInput;
import 'package:web_dashboard/domains/schedule/domain/repositories/lecture_occurrence_repository.dart'
    show
        LectureOccurrenceDeleteInput,
        LectureOccurrenceUpdateInput,
        LectureOccurrenceWriteInput;

part 'classroom_timetable_controller.g.dart';

/// 강의실 상세 화면에서 사용하는 캘린더 컨트롤러.
@riverpod
class ClassroomTimetableController
    extends _$ClassroomTimetableController {
  /// TODO: 서버 연동 완료 후 false로 변경한다.
  static bool demoDataEnabled = false;
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
      final List<LectureOccurrenceEntity> occurrences =
          await _requestOccurrences(targetRange);
      state = state.copyWith(
        occurrences: occurrences,
        isLoading: false,
        errorMessage: occurrences.isEmpty ? '표시할 일정이 없습니다.' : null,
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

  /// 무상태로 특정 범위의 occurrence만 조회한다.
  Future<List<LectureOccurrenceEntity>> fetchOccurrencesByRange(
    TimetableDateRange range,
  ) {
    return _requestOccurrences(range);
  }

  List<LectureOccurrenceEntity> _generateDemoOccurrences(
    TimetableDateRange targetRange,
  ) {
    final DateTime base =
        DateTime(targetRange.from.year, targetRange.from.month, 1);
    final List<DateTime> monthAnchors = <DateTime>[
      base,
      DateTime(base.year, base.month + 1, 1),
    ];
    final List<LectureOccurrenceEntity> samples =
        <LectureOccurrenceEntity>[];
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
        final LectureStatus status = i % 6 == 0
            ? LectureStatus.canceled
            : LectureStatus.scheduled;
        samples.add(
          LectureOccurrenceEntity(
            id: 'occ_${anchor.month}_$i',
            lectureId: 'demo_${anchor.month}_$i',
            title: _demoCourseNames[i % _demoCourseNames.length],
            type: LectureType.values[i % LectureType.values.length],
            status: status,
            isOverride: false,
            classroomId: state.classroomId,
            classroomName: '공학관 ${state.classroomId}',
            start: start,
            end: end,
            sourceVersion: 1,
            departmentName: '스마트보안학과',
            instructorName: _demoProfessors[i % _demoProfessors.length],
          ),
        );
      }
    }
    return samples
        .where(
          (LectureOccurrenceEntity occurrence) =>
              targetRange.contains(occurrence.start),
        )
        .toList();
  }

  Future<List<LectureOccurrenceEntity>> _requestOccurrences(
    TimetableDateRange targetRange,
  ) async {
    if (demoDataEnabled) {
      return _generateDemoOccurrences(targetRange);
    }
    return ref.read(getLectureOccurrencesUseCaseProvider).execute(
          LectureOccurrenceQuery(
            classroomId: state.classroomId,
            from: targetRange.from,
            to: targetRange.to,
          ),
        );
  }

  Future<void> saveLecture({
    required LectureOriginWriteInput payload,
    String? lectureId,
    int? expectedVersion,
    Set<LectureField>? updatedFields,
    bool applyToFollowing = false,
    bool applyToOverrides = false,
  }) async {
    await ref.read(saveLectureUseCaseProvider).execute(
          SaveLectureCommand(
            payload: payload,
            lectureId: lectureId,
            expectedVersion: expectedVersion,
            updatedFields: updatedFields,
            applyToFollowing: applyToFollowing,
            applyToOverrides: applyToOverrides,
          ),
        );
    await loadLectures(range: state.visibleRange);
  }

  Future<void> deleteLectureSeries({
    required String lectureId,
    required int expectedVersion,
    bool applyToFollowing = false,
    bool applyToOverrides = false,
  }) async {
    await ref.read(deleteLectureUseCaseProvider).execute(
          LectureOriginDeleteInput(
            lectureId: lectureId,
            expectedVersion: expectedVersion,
            applyToFollowing: applyToFollowing,
            applyToOverrides: applyToOverrides,
          ),
        );
    await loadLectures(range: state.visibleRange);
  }

  Future<LectureOccurrenceEntity> createOccurrence(
    LectureOccurrenceWriteInput input,
  ) async {
    final LectureOccurrenceEntity entity = await ref
        .read(createLectureOccurrenceUseCaseProvider)
        .execute(input);
    await loadLectures(range: state.visibleRange);
    return entity;
  }

  Future<LectureOccurrenceEntity> updateOccurrence(
    LectureOccurrenceUpdateInput input,
  ) async {
    final LectureOccurrenceEntity entity = await ref
        .read(updateLectureOccurrenceUseCaseProvider)
        .execute(input);
    await loadLectures(range: state.visibleRange);
    return entity;
  }

  Future<void> resumeOccurrence(
    String occurrenceId,
  ) async {
    final LectureOccurrenceUpdateInput input  = LectureOccurrenceUpdateInput(
      occurrenceId: occurrenceId,
      status: LectureStatus.scheduled,
    );

    await updateOccurrence(input);
  }

    Future<void> suspendOccurrence(
    String occurrenceId,
  ) async {
    final LectureOccurrenceUpdateInput input  = LectureOccurrenceUpdateInput(
      occurrenceId: occurrenceId,
      status: LectureStatus.canceled,
    );

    await updateOccurrence(input);
  }

  Future<void> deleteOccurrence(
    LectureOccurrenceDeleteInput input,
  ) async {
    await ref.read(deleteLectureOccurrenceUseCaseProvider).execute(input);
    await loadLectures(range: state.visibleRange);
  }

  
}
