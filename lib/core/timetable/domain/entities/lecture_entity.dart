import 'dart:collection';

import 'package:web_dashboard/core/timetable/domain/entities/lecture_status.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_type.dart';

class LectureEntity {
  LectureEntity({
    required this.id,
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
    List<DateTime> recurrenceExceptions = const <DateTime>[],
    this.notes,
  }) : recurrenceExceptions = UnmodifiableListView<DateTime>(
         List<DateTime>.from(recurrenceExceptions)..sort(),
       );

  final String id;
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
  final UnmodifiableListView<DateTime> recurrenceExceptions;
  final String? notes;

  Duration get duration => end.difference(start);

  bool occursOn(DateTime date) {
    final bool startsBeforeOrEqual = !date.isBefore(start);
    final bool endsAfter = date.isBefore(end);
    return startsBeforeOrEqual && endsAfter;
  }
}
