import 'package:web_dashboard/core/timetable/domain/entities/lecture_entity.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_status.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_type.dart';

abstract class LectureRepository {
  Future<List<LectureEntity>> fetchLectures(LectureQuery query);
  Future<LectureEntity> createLecture(LectureWriteInput input);
  Future<LectureEntity> updateLecture(UpdateLectureInput input);
  Future<void> deleteLecture(DeleteLectureInput input);
}

class LectureQuery {
  const LectureQuery({
    required this.from,
    required this.to,
    required this.classroomId,
    this.departmentId,
    this.instructorId,
    this.type,
    this.status,
  });

  final DateTime from;
  final DateTime to;
  final String classroomId;
  final String? departmentId;
  final String? instructorId;
  final LectureType? type;
  final LectureStatus? status;
}

class LectureWriteInput {
  const LectureWriteInput({
    required this.title,
    required this.type,
    required this.status,
    required this.classroomId,
    required this.classroomName,
    required this.start,
    required this.end,
    this.departmentId,
    this.departmentName,
    this.instructorId,
    this.instructorName,
    this.colorHex,
    this.recurrenceRule,
    this.recurrenceExceptions = const <DateTime>[],
    this.notes,
  });

  final String title;
  final LectureType type;
  final LectureStatus status;
  final String classroomId;
  final String classroomName;
  final String? departmentId;
  final String? departmentName;
  final String? instructorId;
  final String? instructorName;
  final DateTime start;
  final DateTime end;
  final String? colorHex;
  final String? recurrenceRule;
  final List<DateTime> recurrenceExceptions;
  final String? notes;
}

class UpdateLectureInput {
  const UpdateLectureInput({
    required this.lectureId,
    required this.payload,
    this.applyToSeries = false,
  });

  final String lectureId;
  final LectureWriteInput payload;
  final bool applyToSeries;
}

class DeleteLectureInput {
  const DeleteLectureInput({
    required this.lectureId,
    this.deleteSeries = false,
  });

  final String lectureId;
  final bool deleteSeries;
}
