import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:web_dashboard/core/timetable/data/dtos/lecture_dto.dart';

void main() {
  test('LectureDto serializes to and from json', () {
    final LectureDto dto = LectureDto(
      id: '1',
      title: '테스트 강의',
      type: 'LECTURE',
      status: 'ACTIVE',
      classroomId: 'room-1',
      departmentId: 'dept-1',
      instructorId: 'inst-1',
      startTime: DateTime.utc(2025, 1, 1, 9),
      endTime: DateTime.utc(2025, 1, 1, 11),
      recurrenceRule: 'FREQ=WEEKLY',
      recurrenceExceptions: <DateTime>[DateTime.utc(2025, 1, 8, 9)],
      version: 3,
      createdAt: DateTime.utc(2024, 12, 31, 23, 30),
      updatedAt: DateTime.utc(2025, 1, 1, 0, 30),
    );

    final Map<String, Object?> json = dto.toJson();
    final LectureDto restored =
        LectureDto.fromJson(jsonDecode(jsonEncode(json)) as Map<String, Object?>);

    expect(restored.id, '1');
    expect(restored.title, '테스트 강의');
    expect(restored.version, 3);
    expect(restored.recurrenceExceptions.length, 1);
    expect(restored.recurrenceExceptions.first.year, 2025);
  });
}
