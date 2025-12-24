import 'package:flutter_test/flutter_test.dart';
import 'package:web_dashboard/core/timetable/application/usecases/get_lectures_usecase.dart';
import 'package:web_dashboard/core/timetable/application/usecases/save_lecture_usecase.dart';
import 'package:web_dashboard/core/timetable/application/usecases/delete_lecture_usecase.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_entity.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_status.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_type.dart';
import 'package:web_dashboard/core/timetable/domain/repositories/lecture_origin_repository.dart';

void main() {
  late _FakeRepository repository;

  setUp(() {
    repository = _FakeRepository();
  });

  test('GetLecturesUseCase delegates to repository', () async {
    repository.fetchResult = <LectureEntity>[
      LectureEntity(
        id: '1',
        title: '강의 1',
        type: LectureType.lecture,
        lectureStatus: LectureStatus.scheduled,
        classroomId: 'room-1',
        classroomName: '공학관 101',
        start: DateTime.utc(2025, 1, 1, 9),
        end: DateTime.utc(2025, 1, 1, 10),
        version: 1,
        createdAt: DateTime.utc(2024, 12, 31, 20),
        updatedAt: DateTime.utc(2024, 12, 31, 21),
      ),
    ];
    final usecase = GetLecturesUseCase(repository);

    final result = await usecase.execute(
      LectureOriginQuery(
        from: DateTime.utc(2025, 1, 1),
        to: DateTime.utc(2025, 1, 2),
        classroomId: 'room-1',
      ),
    );

    expect(repository.lastQuery?.classroomId, 'room-1');
    expect(result.length, 1);
  });

  test('SaveLectureUseCase creates when lectureId is null', () async {
    repository.singleResult = LectureEntity(
      id: 'new',
      title: '신규',
      type: LectureType.event,
      lectureStatus: LectureStatus.scheduled,
      classroomId: 'room-1',
      classroomName: '공학관 101',
      start: DateTime.utc(2025, 1, 1, 9),
      end: DateTime.utc(2025, 1, 1, 10),
      version: 1,
      createdAt: DateTime.utc(2024, 12, 31, 20),
      updatedAt: DateTime.utc(2024, 12, 31, 21),
    );
    final usecase = SaveLectureUseCase(repository);

    final entity = await usecase.execute(
      SaveLectureCommand(
        payload: LectureOriginWriteInput(
          title: '신규',
          type: LectureType.event,
          classroomId: 'room-1',
          start: DateTime.utc(2025, 1, 1, 9),
          end: DateTime.utc(2025, 1, 1, 10),
        ),
      ),
    );

    expect(repository.createdCount, 1);
    expect(entity.id, 'new');
  });

  test('SaveLectureUseCase updates when lectureId exists', () async {
    repository.singleResult = LectureEntity(
      id: 'update',
      title: '수정',
      type: LectureType.lecture,
      lectureStatus: LectureStatus.scheduled,
      classroomId: 'room-1',
      classroomName: '공학관 101',
      start: DateTime.utc(2025, 1, 1, 9),
      end: DateTime.utc(2025, 1, 1, 10),
      version: 2,
      createdAt: DateTime.utc(2024, 12, 31, 20),
      updatedAt: DateTime.utc(2025, 1, 1, 8),
    );
    final usecase = SaveLectureUseCase(repository);

    await usecase.execute(
      SaveLectureCommand(
        lectureId: 'update',
        expectedVersion: 1,
        payload: LectureOriginWriteInput(
          title: '수정',
          type: LectureType.lecture,
          classroomId: 'room-1',
          start: DateTime.utc(2025, 1, 1, 9),
          end: DateTime.utc(2025, 1, 1, 10),
        ),
      ),
    );

    expect(repository.lastUpdate?.expectedVersion, 1);
    expect(repository.updatedCount, 1);
  });

  test('DeleteLectureUseCase forwards request', () async {
    final usecase = DeleteLectureUseCase(repository);

    await usecase.execute(
      const LectureOriginDeleteInput(
        lectureId: 'delete',
        expectedVersion: 4,
      ),
    );

    expect(repository.deletedCount, 1);
  });
}

class _FakeRepository implements LectureOriginRepository {
  LectureOriginQuery? lastQuery;
  LectureOriginUpdateInput? lastUpdate;
  LectureEntity? singleResult;
  List<LectureEntity> fetchResult = <LectureEntity>[];
  int createdCount = 0;
  int updatedCount = 0;
  int deletedCount = 0;

  @override
  Future<LectureEntity> createLecture(LectureOriginWriteInput input) async {
    createdCount += 1;
    return singleResult!;
  }

  @override
  Future<void> deleteLecture(LectureOriginDeleteInput input) async {
    deletedCount += 1;
  }

  @override
  Future<List<LectureEntity>> fetchLectures(LectureOriginQuery query) async {
    lastQuery = query;
    return fetchResult;
  }

  @override
  Future<LectureEntity> updateLecture(LectureOriginUpdateInput input) async {
    lastUpdate = input;
    updatedCount += 1;
    return singleResult!;
  }
}
