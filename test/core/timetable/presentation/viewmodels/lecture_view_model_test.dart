import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_entity.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_status.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_type.dart';
import 'package:web_dashboard/core/timetable/presentation/viewmodels/lecture_view_model.dart';

void main() {
  test('LectureViewModel maps entity fields', () {
    final entity = LectureEntity(
      id: '1',
      title: 'AI 개론',
      type: LectureType.lecture,
      lectureStatus: LectureStatus.scheduled,
      classroomId: 'room-1',
      classroomName: '공학관 101',
      start: DateTime.utc(2025, 1, 1, 9),
      end: DateTime.utc(2025, 1, 1, 10),
      instructorName: '김교수',
      version: 1,
      createdAt: DateTime.utc(2024, 12, 31, 23, 59),
      updatedAt: DateTime.utc(2025, 1, 1),
      notes: '비고',
    );

    final vm = LectureViewModel.fromEntity(
      entity,
      color: Colors.blue,
    );

    expect(vm.title, 'AI 개론');
    expect(vm.statusLabel, '진행');
    expect(vm.instructorName, '김교수');
    expect(vm.version, 1);
    expect(vm.notes, '비고');
  });
}
