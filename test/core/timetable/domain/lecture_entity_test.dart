import 'package:flutter_test/flutter_test.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_entity.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_status.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_type.dart';

void main() {
  group('LectureEntity', () {
    test('duration reflects start and end delta', () {
      final LectureEntity entity = LectureEntity(
        id: '1',
        title: 'Sample',
        type: LectureType.lecture,
        status: LectureStatus.scheduled,
        classroomId: 'room-1',
        classroomName: '공학관 101',
        start: DateTime(2025, 1, 1, 9),
        end: DateTime(2025, 1, 1, 11, 30),
      );
      expect(entity.duration.inMinutes, 150);
    });

    test('occursOn returns true for moments within the slot', () {
      final LectureEntity entity = LectureEntity(
        id: '1',
        title: 'Sample',
        type: LectureType.event,
        status: LectureStatus.scheduled,
        classroomId: 'room-1',
        classroomName: '공학관 101',
        start: DateTime(2025, 1, 1, 9),
        end: DateTime(2025, 1, 1, 11),
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
