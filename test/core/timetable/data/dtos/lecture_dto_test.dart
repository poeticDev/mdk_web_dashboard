import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:web_dashboard/domains/schedule/data/dtos/lecture_dto.dart';

void main() {
  test('LectureDto serializes to and from json', () {
    final LectureDto dto = LectureDto(
      id: '1',
      title: '테스트 강의',
      type: 'lecture',
      status: 'scheduled',
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
    expect(json['lectureId'], '1');
    expect(
      (json['recurrence'] as Map<String, Object?>)['rrule'],
      'FREQ=WEEKLY',
    );

    final LectureDto restored = LectureDto.fromJson(
      jsonDecode(
        jsonEncode(
          <String, Object?>{
            'lectureId': '1',
            'title': '테스트 강의',
            'type': 'lecture',
            'status': 'scheduled',
            'classroomId': 'room-1',
            'startTime': '2025-01-01T09:00:00Z',
            'endTime': '2025-01-01T11:00:00Z',
            'version': 3,
            'createdAt': '2024-12-31T23:30:00Z',
            'updatedAt': '2025-01-01T00:30:00Z',
            'recurrence': <String, Object?>{
              'rrule': 'FREQ=WEEKLY',
              'exDates': <String>['2025-01-08T09:00:00Z'],
            },
          },
        ),
      ) as Map<String, Object?>,
    );

    expect(restored.id, '1');
    expect(restored.title, '테스트 강의');
    expect(restored.version, 3);
    expect(restored.recurrenceExceptions.length, 1);
    expect(restored.recurrenceExceptions.first.year, 2025);
  });
}
