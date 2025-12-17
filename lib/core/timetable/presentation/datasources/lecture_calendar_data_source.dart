import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:web_dashboard/core/timetable/presentation/viewmodels/lecture_view_model.dart';

/// Syncfusion Calendar와 연결되는 DataSource.
class LectureCalendarDataSource extends CalendarDataSource {
  LectureCalendarDataSource(List<LectureViewModel> items) {
    appointments = items;
  }

  LectureViewModel _get(int index) =>
      appointments![index] as LectureViewModel;

  @override
  DateTime getStartTime(int index) => _get(index).start;

  @override
  DateTime getEndTime(int index) => _get(index).end;

  @override
  String getSubject(int index) => _get(index).title;

  @override
  Color getColor(int index) => _get(index).color;

  @override
  String? getNotes(int index) {
    final LectureViewModel lecture = _get(index);
    return lecture.notes ?? lecture.statusLabel;
  }
}
