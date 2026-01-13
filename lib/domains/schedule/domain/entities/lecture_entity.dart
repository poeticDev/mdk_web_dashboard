/// ROLE
/// - 도메인 엔티티를 정의한다
///
/// RESPONSIBILITY
/// - 핵심 필드를 보관한다
/// - 도메인 모델을 제공한다
///
/// DEPENDS ON
/// - collection
/// - lecture_status
/// - lecture_type
library;

import 'dart:collection';

import 'package:web_dashboard/domains/schedule/domain/entities/lecture_status.dart';
import 'package:web_dashboard/domains/schedule/domain/entities/lecture_type.dart';

/// 클라이언트에서 사용하는 강의 일정 도메인 엔티티.
class LectureEntity {
  LectureEntity({
    required this.id,
    required this.title,
    required this.type,
    required this.classroomId,
    required this.start,
    required this.end,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
    LectureStatus lectureStatus = LectureStatus.scheduled,
    String? classroomName,
    this.externalCode,
    this.departmentId,
    this.departmentName,
    this.instructorId,
    this.instructorName,
    this.colorHex,
    this.recurrenceRule,
    List<DateTime> recurrenceExceptions = const <DateTime>[],
    this.notes,
  })  : classroomName = classroomName ?? classroomId,
        status = lectureStatus,
        recurrenceExceptions = UnmodifiableListView<DateTime>(
          List<DateTime>.from(recurrenceExceptions)..sort(),
        );

  final String id;
  final String title;
  final LectureType type;
  final LectureStatus status;
  final String classroomId;
  final String classroomName;
  final String? externalCode;
  final String? departmentId;
  final String? departmentName;
  final String? instructorId;
  final String? instructorName;
  final DateTime start;
  final DateTime end;
  final int version;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? colorHex;
  final String? recurrenceRule;
  final UnmodifiableListView<DateTime> recurrenceExceptions;
  final String? notes;

  /// 강의 길이를 계산한다.
  Duration get duration => end.difference(start);

  /// 특정 시각이 이 일정 범위에 포함되는지 검사한다.
  bool occursOn(DateTime date) {
    final bool startsBeforeOrEqual = !date.isBefore(start);
    final bool endsAfter = date.isBefore(end);
    return startsBeforeOrEqual && endsAfter;
  }
}
