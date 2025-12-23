import 'package:web_dashboard/core/timetable/domain/entities/lecture_status.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_type.dart';

/// 서버가 확장한 단일 occurrence를 표현한다.
class LectureOccurrenceEntity {
  const LectureOccurrenceEntity({
    required this.id,
    required this.lectureId,
    required this.title,
    required this.type,
    required this.status,
    required this.isOverride,
    required this.classroomId,
    required this.classroomName,
    required this.start,
    required this.end,
    required this.sourceVersion,
    this.colorHex,
    this.departmentId,
    this.departmentName,
    this.departmentCode,
    this.instructorId,
    this.instructorName,
    this.notes,
  });

  final String id;
  final String lectureId;
  final String title;
  final LectureType type;
  final LectureStatus status;
  final bool isOverride;
  final String classroomId;
  final String classroomName;
  final DateTime start;
  final DateTime end;
  final int sourceVersion;
  final String? colorHex;
  final String? departmentId;
  final String? departmentName;
  final String? departmentCode;
  final String? instructorId;
  final String? instructorName;
  final String? notes;
}
