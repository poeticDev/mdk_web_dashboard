import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_dashboard/core/timetable/application/controllers/classroom_timetable_controller.dart';
import 'package:web_dashboard/core/timetable/application/state/classroom_timetable_state.dart';
import 'package:web_dashboard/core/timetable/application/timetable_providers.dart';
import 'package:web_dashboard/core/timetable/application/usecases/get_lectures_usecase.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_entity.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_status.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_type.dart';
import 'package:web_dashboard/core/timetable/domain/repositories/lecture_repository.dart';

void main() {
  setUp(() {
    ClassroomTimetableController.demoDataEnabled = false;
  });

  test('loadLectures fetches data and updates state', () async {
    final container = ProviderContainer(
      overrides:[
        getLecturesUseCaseProvider.overrideWithValue(_FakeGetLecturesUseCase()),
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
    expect(state.lectures.length, 1);
  });

  test('selectLectureType stores filter without loading', () {
    final container = ProviderContainer(
      overrides: [
        getLecturesUseCaseProvider.overrideWithValue(_FakeGetLecturesUseCase()),
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

class _FakeGetLecturesUseCase extends GetLecturesUseCase {
  _FakeGetLecturesUseCase() : super(_DummyRepository());

  @override
  Future<List<LectureEntity>> execute(LectureQuery query) async {
    return <LectureEntity>[
      LectureEntity(
        id: '1',
        title: '테스트 강의',
        type: LectureType.lecture,
        lectureStatus: LectureStatus.scheduled,
        classroomId: query.classroomId,
        classroomName: '공학관 101',
        start: DateTime(2025, 1, 1, 9),
        end: DateTime(2025, 1, 1, 10),
        version: 1,
        createdAt: DateTime(2024, 12, 31, 23),
        updatedAt: DateTime(2024, 12, 31, 23, 30),
      ),
    ];
  }
}

class _DummyRepository implements LectureRepository {
  @override
  Future<LectureEntity> createLecture(LectureWriteInput input) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteLecture(DeleteLectureInput input) {
    throw UnimplementedError();
  }

  @override
  Future<List<LectureEntity>> fetchLectures(LectureQuery query) {
    throw UnimplementedError();
  }

  @override
  Future<LectureEntity> updateLecture(UpdateLectureInput input) {
    throw UnimplementedError();
  }
}
