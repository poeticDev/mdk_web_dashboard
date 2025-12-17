import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web_dashboard/core/timetable/presentation/datasources/lecture_calendar_data_source.dart';
import 'package:web_dashboard/core/timetable/presentation/viewmodels/lecture_view_model.dart';

void main() {
  test('LectureCalendarDataSource exposes view model values', () {
    final vm = LectureViewModel(
      id: '1',
      title: '테스트',
      classroomName: '공학관 101',
      start: DateTime.utc(2025, 1, 1, 9),
      end: DateTime.utc(2025, 1, 1, 10),
      color: Colors.purple,
      statusLabel: '진행',
      version: 1,
      notes: '비고',
    );
    final dataSource = LectureCalendarDataSource(<LectureViewModel>[vm]);

    expect(dataSource.getStartTime(0), vm.start);
    expect(dataSource.getColor(0), vm.color);
    expect(dataSource.getSubject(0), '테스트');
  });
}
