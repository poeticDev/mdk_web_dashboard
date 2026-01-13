import 'package:flutter/material.dart';
import 'package:web_dashboard/domains/schedule/domain/entities/lecture_occurrence_entity.dart';
import 'package:web_dashboard/domains/schedule/domain/entities/lecture_type.dart';

/// UI가 구독하는 불변 ViewModel.
class LectureViewModel {
  const LectureViewModel({
    required this.id,
    required this.lectureId,
    required this.title,
    required this.classroomName,
    required this.start,
    required this.end,
    required this.color,
    required this.statusLabel,
    required this.version,
    required this.type,
    required this.isOverride,
    this.recurrenceRule,
    this.departmentName,
    this.instructorName,
    this.notes,
  });

  final String id;
  final String lectureId;
  final String title;
  final String classroomName;
  final DateTime start;
  final DateTime end;
  final Color color;
  final String statusLabel;
  final int version;
  final LectureType type;
  final bool isOverride;
  final String? recurrenceRule;
  final String? departmentName;
  final String? instructorName;
  final String? notes;

  factory LectureViewModel.fromOccurrence(
    LectureOccurrenceEntity entity, {
    required Color color,
  }) {
    return LectureViewModel(
      id: entity.id,
      lectureId: entity.lectureId,
      title: entity.title,
      classroomName: entity.classroomName,
      start: entity.start,
      end: entity.end,
      color: color,
      statusLabel: entity.status.isCanceled ? '휴강' : '진행',
      departmentName: entity.departmentName,
      instructorName: entity.instructorName,
      version: entity.sourceVersion,
      type: entity.type,
      isOverride: entity.isOverride,
      notes: entity.notes,
    );
  }
}
