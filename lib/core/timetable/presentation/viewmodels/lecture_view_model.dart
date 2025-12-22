import 'package:flutter/material.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_entity.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_type.dart';

/// UI가 구독하는 불변 ViewModel.
class LectureViewModel {
  const LectureViewModel({
    required this.id,
    required this.title,
    required this.classroomName,
    required this.start,
    required this.end,
    required this.color,
    required this.statusLabel,
    required this.version,
    required this.type,
    this.recurrenceRule,
    this.departmentName,
    this.instructorName,
    this.notes,
  });

  final String id;
  final String title;
  final String classroomName;
  final DateTime start;
  final DateTime end;
  final Color color;
  final String statusLabel;
  final int version;
  final LectureType type;
  final String? recurrenceRule;
  final String? departmentName;
  final String? instructorName;
  final String? notes;

  factory LectureViewModel.fromEntity(
    LectureEntity entity, {
    required Color color,
  }) {
    return LectureViewModel(
      id: entity.id,
      title: entity.title,
      classroomName: entity.classroomName,
      start: entity.start,
      end: entity.end,
      color: color,
      statusLabel: entity.status.isCanceled ? '휴강' : '진행',
      departmentName: entity.departmentName,
      instructorName: entity.instructorName,
      version: entity.version,
      type: entity.type,
      recurrenceRule: entity.recurrenceRule,
      notes: entity.notes,
    );
  }
}
