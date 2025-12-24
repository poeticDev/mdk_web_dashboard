import 'package:flutter_test/flutter_test.dart';
import 'package:web_dashboard/core/timetable/application/usecases/create_lecture_occurrence_usecase.dart';
import 'package:web_dashboard/core/timetable/application/usecases/update_lecture_occurrence_usecase.dart';
import 'package:web_dashboard/core/timetable/application/usecases/delete_lecture_occurrence_usecase.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_occurrence_entity.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_occurrence_query.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_status.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_type.dart';
import 'package:web_dashboard/core/timetable/domain/repositories/lecture_occurrence_repository.dart';

void main() {
  late _FakeOccurrenceRepository repository;

  setUp(() {
    repository = _FakeOccurrenceRepository();
  });

  test('CreateLectureOccurrenceUseCase delegates to repository', () async {
    final useCase = CreateLectureOccurrenceUseCase(repository);
    final result = await useCase.execute(
      LectureOccurrenceWriteInput(
        lectureId: 'lec-1',
        classroomId: 'room-1',
        start: DateTime.utc(2025, 1, 1, 9),
        end: DateTime.utc(2025, 1, 1, 10),
      ),
    );
    expect(result.id, 'occ-create');
    expect(repository.createdCount, 1);
  });

  test('UpdateLectureOccurrenceUseCase delegates to repository', () async {
    final useCase = UpdateLectureOccurrenceUseCase(repository);
    await useCase.execute(
      LectureOccurrenceUpdateInput(occurrenceId: 'occ-1'),
    );
    expect(repository.updatedCount, 1);
  });

  test('DeleteLectureOccurrenceUseCase delegates to repository', () async {
    final useCase = DeleteLectureOccurrenceUseCase(repository);
    await useCase.execute(
      const LectureOccurrenceDeleteInput(occurrenceId: 'occ-1'),
    );
    expect(repository.deletedCount, 1);
  });
}

class _FakeOccurrenceRepository implements LectureOccurrenceRepository {
  int createdCount = 0;
  int updatedCount = 0;
  int deletedCount = 0;

  @override
  Future<LectureOccurrenceEntity> createOccurrence(
    LectureOccurrenceWriteInput input,
  ) async {
    createdCount += 1;
    return LectureOccurrenceEntity(
      id: 'occ-create',
      lectureId: input.lectureId,
      title: '테스트',
      type: LectureType.lecture,
      status: LectureStatus.scheduled,
      isOverride: false,
      classroomId: input.classroomId,
      classroomName: '공학관 101',
      start: input.start,
      end: input.end,
      sourceVersion: 1,
    );
  }

  @override
  Future<void> deleteOccurrence(LectureOccurrenceDeleteInput input) async {
    deletedCount += 1;
  }

  @override
  Future<List<LectureOccurrenceEntity>> fetchOccurrences(
    LectureOccurrenceQuery query,
  ) async {
    return const <LectureOccurrenceEntity>[];
  }

  @override
  Future<LectureOccurrenceEntity> updateOccurrence(
    LectureOccurrenceUpdateInput input,
  ) async {
    updatedCount += 1;
    return LectureOccurrenceEntity(
      id: input.occurrenceId,
      lectureId: 'lec-1',
      title: '테스트',
      type: LectureType.lecture,
      status: LectureStatus.scheduled,
      isOverride: true,
      classroomId: 'room-1',
      classroomName: '공학관 101',
      start: DateTime.utc(2025, 1, 1, 9),
      end: DateTime.utc(2025, 1, 1, 10),
      sourceVersion: 2,
    );
  }
}
