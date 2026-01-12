import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web_dashboard/domains/schedule/domain/entities/lecture_occurrence_entity.dart';
import 'package:web_dashboard/domains/schedule/domain/entities/lecture_status.dart';
import 'package:web_dashboard/domains/schedule/domain/entities/lecture_type.dart';
import 'package:web_dashboard/features/classroom_detail/presentation/viewmodels/lecture_view_model.dart';

void main() {
  test('LectureViewModel maps entity fields', () {
    final entity = LectureOccurrenceEntity(
      id: 'occ-1',
      lectureId: 'lec-1',
      title: 'AI 개론',
      type: LectureType.lecture,
      status: LectureStatus.scheduled,
      isOverride: false,
      classroomId: 'room-1',
      classroomName: '공학관 101',
      start: DateTime.utc(2025, 1, 1, 9),
      end: DateTime.utc(2025, 1, 1, 10),
      sourceVersion: 1,
      instructorName: '김교수',
      notes: '비고',
    );

    final vm = LectureViewModel.fromOccurrence(
      entity,
      color: Colors.blue,
    );

    expect(vm.title, 'AI 개론');
    expect(vm.statusLabel, '진행');
    expect(vm.instructorName, '김교수');
    expect(vm.version, 1);
    expect(vm.notes, '비고');
    expect(vm.type, LectureType.lecture);
    expect(vm.lectureId, 'lec-1');
  });
}
