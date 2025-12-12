import 'package:flutter/material.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_entity.dart';

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
    this.departmentName,
    this.instructorName,
  });

  final String id;
  final String title;
  final String classroomName;
  final DateTime start;
  final DateTime end;
  final Color color;
  final String statusLabel;
  final String? departmentName;
  final String? instructorName;

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
    );
  }
}
