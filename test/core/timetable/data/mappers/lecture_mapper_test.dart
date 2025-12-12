import 'package:flutter_test/flutter_test.dart';
import 'package:web_dashboard/core/timetable/data/dtos/lecture_dto.dart';
import 'package:web_dashboard/core/timetable/data/mappers/lecture_mapper.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_status.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_type.dart';
import 'package:web_dashboard/core/timetable/domain/repositories/lecture_repository.dart';

void main() {
  const LectureMapper mapper = LectureMapper();

  test('toEntity converts dto to domain entity', () {
    final LectureDto dto = LectureDto(
      id: '1',
      title: 'Math',
      type: 'EXAM',
      status: 'CANCELED',
      classroomId: 'room-1',
      classroomName: '공학관 101',
      startTime: DateTime.utc(2025, 1, 1, 9),
      endTime: DateTime.utc(2025, 1, 1, 11),
      recurrenceExceptions: <DateTime>[DateTime.utc(2025, 1, 3, 9)],
    );

    final entity = mapper.toEntity(dto);
    expect(entity.type, LectureType.exam);
    expect(entity.status, LectureStatus.canceled);
    expect(entity.recurrenceExceptions.length, 1);
  });

  test('toQueryRequest copies filters', () {
    final LectureQuery query = LectureQuery(
      from: DateTime.utc(2025, 1, 1),
      to: DateTime.utc(2025, 1, 31),
      classroomId: 'room-1',
      departmentId: 'dept',
      type: LectureType.event,
      status: LectureStatus.scheduled,
    );
    final request = mapper.toQueryRequest(query);
    expect(request.type, 'EVENT');
    expect(request.status, 'ACTIVE');
  });

  test('toPayload copies writer input', () {
    final LectureWriteInput input = LectureWriteInput(
      title: 'AI',
      type: LectureType.lecture,
      status: LectureStatus.scheduled,
      classroomId: 'room-1',
      classroomName: '공학관 101',
      start: DateTime.utc(2025, 2, 1, 10),
      end: DateTime.utc(2025, 2, 1, 12),
      recurrenceExceptions: <DateTime>[DateTime.utc(2025, 2, 8, 10)],
    );
    final payload = mapper.toPayload(input);
    expect(payload.type, 'LECTURE');
    expect(payload.recurrenceExceptions.first.year, 2025);
  });
}
