import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web_dashboard/domains/schedule/domain/entities/lecture_type.dart';
import 'package:web_dashboard/features/classroom_detail/presentation/datasources/lecture_calendar_data_source.dart';
import 'package:web_dashboard/features/classroom_detail/presentation/viewmodels/lecture_view_model.dart';

void main() {
  test('LectureCalendarDataSource exposes view model values', () {
    final vm = LectureViewModel(
      id: '1',
      lectureId: 'lec-1',
      title: '테스트',
      classroomName: '공학관 101',
      start: DateTime.utc(2025, 1, 1, 9),
      end: DateTime.utc(2025, 1, 1, 10),
      color: Colors.purple,
      statusLabel: '진행',
      version: 1,
      notes: '비고',
      type: LectureType.lecture,
      isOverride: false,
    );
    final dataSource = LectureCalendarDataSource(
      items: <LectureViewModel>[vm],
      loadMoreLectures: (DateTime _, DateTime __) async => <LectureViewModel>[],
    );

    expect(dataSource.getStartTime(0), vm.start);
    expect(dataSource.getColor(0), vm.color);
    expect(dataSource.getSubject(0), '테스트');
  });

  test('handleLoadMore appends fetched lectures without duplicates', () async {
    final LectureViewModel existing = LectureViewModel(
      id: '1',
      lectureId: 'lec-1',
      title: '기존',
      classroomName: '공학관 101',
      start: DateTime.utc(2025, 1, 1, 9),
      end: DateTime.utc(2025, 1, 1, 10),
      color: Colors.blue,
      statusLabel: '진행',
      version: 1,
      type: LectureType.lecture,
      isOverride: false,
    );
    final LectureViewModel incoming = LectureViewModel(
      id: '2',
      lectureId: 'lec-2',
      title: '추가',
      classroomName: '공학관 102',
      start: DateTime.utc(2025, 1, 2, 9),
      end: DateTime.utc(2025, 1, 2, 10),
      color: Colors.red,
      statusLabel: '예정',
      version: 1,
      type: LectureType.lecture,
      isOverride: false,
    );
    final dataSource = LectureCalendarDataSource(
      items: <LectureViewModel>[existing],
      loadMoreLectures: (DateTime _, DateTime __) async =>
          <LectureViewModel>[incoming],
    );

    await dataSource.handleLoadMore(existing.start, incoming.end);

    expect(dataSource.appointments, hasLength(2));
    expect(dataSource.getSubject(1), '추가');
  });

  test('handleLoadMore prefers newer versions when ids match', () async {
    final LectureViewModel existing = LectureViewModel(
      id: 'dup',
      lectureId: 'lec-dup',
      title: '기존',
      classroomName: '공학관 101',
      start: DateTime.utc(2025, 1, 1, 9),
      end: DateTime.utc(2025, 1, 1, 10),
      color: Colors.blue,
      statusLabel: '진행',
      version: 1,
      type: LectureType.lecture,
      isOverride: false,
    );
    final LectureViewModel updated = LectureViewModel(
      id: 'dup',
      lectureId: 'lec-dup',
      title: '수정',
      classroomName: '공학관 101',
      start: DateTime.utc(2025, 1, 1, 9),
      end: DateTime.utc(2025, 1, 1, 10),
      color: Colors.green,
      statusLabel: '진행',
      version: 2,
      type: LectureType.lecture,
      isOverride: true,
    );
    final dataSource = LectureCalendarDataSource(
      items: <LectureViewModel>[existing],
      loadMoreLectures: (DateTime _, DateTime __) async =>
          <LectureViewModel>[updated],
    );

    await dataSource.handleLoadMore(existing.start, existing.end);

    expect(dataSource.appointments, hasLength(1));
    expect(dataSource.getColor(0), Colors.green);
  });
}
