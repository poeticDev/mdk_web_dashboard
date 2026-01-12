import 'package:flutter_test/flutter_test.dart';
import 'package:web_dashboard/domains/schedule/domain/entities/lecture_entity.dart';
import 'package:web_dashboard/domains/schedule/domain/entities/lecture_status.dart';
import 'package:web_dashboard/domains/schedule/domain/entities/lecture_type.dart';

void main() {
  group('LectureEntity', () {
    test('duration reflects start and end delta', () {
      final LectureEntity entity = LectureEntity(
        id: '1',
        title: '샘플 일정',
        type: LectureType.lecture,
        lectureStatus: LectureStatus.scheduled,
        classroomId: 'room-1',
        classroomName: '공학관 101',
        start: DateTime(2025, 1, 1, 9),
        end: DateTime(2025, 1, 1, 11, 30),
        version: 1,
        createdAt: DateTime(2024, 12, 31, 23, 59),
        updatedAt: DateTime(2025, 1, 1),
      );
      expect(entity.duration.inMinutes, 150);
    });

    test('occursOn returns true for moments within the slot', () {
      final LectureEntity entity = LectureEntity(
        id: '1',
        title: '샘플 일정',
        type: LectureType.event,
        lectureStatus: LectureStatus.scheduled,
        classroomId: 'room-1',
        classroomName: '공학관 101',
        start: DateTime(2025, 1, 1, 9),
        end: DateTime(2025, 1, 1, 11),
        version: 1,
        createdAt: DateTime(2024, 12, 31, 23, 59),
        updatedAt: DateTime(2025, 1, 1),
      );
      expect(entity.occursOn(DateTime(2025, 1, 1, 10)), isTrue);
      expect(entity.occursOn(DateTime(2025, 1, 1, 12)), isFalse);
    });
  });

  group('LectureType', () {
    test('parses api strings', () {
      expect(LectureType.fromApi('event'), LectureType.event);
      expect(LectureType.fromApi('EXAM'), LectureType.exam);
      expect(LectureType.fromApi('unknown'), LectureType.lecture);
    });
  });

  group('LectureStatus', () {
    test('detects canceled values', () {
      expect(LectureStatus.fromApi('canceled'), LectureStatus.canceled);
      expect(LectureStatus.fromApi('active'), LectureStatus.scheduled);
      expect(LectureStatus.canceled.isCanceled, isTrue);
    });
  });
}
