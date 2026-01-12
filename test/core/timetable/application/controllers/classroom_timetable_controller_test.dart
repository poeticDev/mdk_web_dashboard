import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_dashboard/domains/schedule/application/controllers/classroom_timetable_controller.dart';
import 'package:web_dashboard/domains/schedule/application/state/classroom_timetable_state.dart';
import 'package:web_dashboard/domains/schedule/application/timetable_providers.dart';
import 'package:web_dashboard/domains/schedule/application/usecases/get_lecture_occurrences_usecase.dart';
import 'package:web_dashboard/domains/schedule/domain/entities/lecture_occurrence_entity.dart';
import 'package:web_dashboard/domains/schedule/domain/entities/lecture_occurrence_query.dart';
import 'package:web_dashboard/domains/schedule/domain/entities/lecture_status.dart';
import 'package:web_dashboard/domains/schedule/domain/entities/lecture_type.dart';
import 'package:web_dashboard/domains/schedule/domain/repositories/lecture_occurrence_repository.dart';

void main() {
  setUp(() {
    ClassroomTimetableController.demoDataEnabled = false;
  });

  test('loadLectures fetches data and updates state', () async {
    final container = ProviderContainer(
      overrides: [
        getLectureOccurrencesUseCaseProvider.overrideWithValue(
          _FakeGetLectureOccurrencesUseCase(),
        ),
      ],
    );
    addTearDown(container.dispose);
    final controller = container.read(
      classroomTimetableControllerProvider('room-1').notifier,
    );
    final range = TimetableDateRange(
      from: DateTime(2025, 1, 1),
      to: DateTime(2025, 1, 7),
    );

    await controller.loadLectures(range: range);

    final state =
        container.read(classroomTimetableControllerProvider('room-1'));
    expect(state.isLoading, isFalse);
    expect(state.occurrences.length, 1);
  });

  test('selectLectureType stores filter without loading', () {
    final container = ProviderContainer(
      overrides: [
        getLectureOccurrencesUseCaseProvider.overrideWithValue(
          _FakeGetLectureOccurrencesUseCase(),
        ),
      ],
    );
    addTearDown(container.dispose);
    final controller = container.read(
      classroomTimetableControllerProvider('room-9').notifier,
    );

    controller.selectLectureType(LectureType.event);

    final state =
        container.read(classroomTimetableControllerProvider('room-9'));
    expect(state.filterType, LectureType.event);
  });
}

class _FakeGetLectureOccurrencesUseCase extends GetLectureOccurrencesUseCase {
  _FakeGetLectureOccurrencesUseCase()
      : super(_DummyLectureOccurrenceRepository());

  @override
  Future<List<LectureOccurrenceEntity>> execute(
    LectureOccurrenceQuery query,
  ) async {
    return <LectureOccurrenceEntity>[
      LectureOccurrenceEntity(
        id: 'occ-1',
        lectureId: 'lec-1',
        title: '테스트 강의',
        type: LectureType.lecture,
        status: LectureStatus.scheduled,
        isOverride: false,
        classroomId: query.classroomId,
        classroomName: '공학관 101',
        start: DateTime(2025, 1, 1, 9),
        end: DateTime(2025, 1, 1, 10),
        sourceVersion: 1,
      ),
    ];
  }
}

class _DummyLectureOccurrenceRepository
    implements LectureOccurrenceRepository {
  @override
  Future<List<LectureOccurrenceEntity>> fetchOccurrences(
    LectureOccurrenceQuery query,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<LectureOccurrenceEntity> createOccurrence(
    LectureOccurrenceWriteInput input,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteOccurrence(LectureOccurrenceDeleteInput input) {
    throw UnimplementedError();
  }

  @override
  Future<LectureOccurrenceEntity> updateOccurrence(
    LectureOccurrenceUpdateInput input,
  ) {
    throw UnimplementedError();
  }
}
