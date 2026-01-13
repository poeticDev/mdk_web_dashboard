/// ROLE
/// - UI 데이터 소스를 제공한다
///
/// RESPONSIBILITY
/// - 외부 위젯 데이터 소스와 연결한다
///
/// DEPENDS ON
/// - flutter
/// - syncfusion_flutter_calendar
/// - lecture_view_model
library;

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:web_dashboard/features/classroom_detail/viewmodels/lecture_view_model.dart';

typedef LectureRangeLoader =
    Future<List<LectureViewModel>> Function(DateTime from, DateTime to);

/// Syncfusion Calendar와 연결되는 DataSource.
class LectureCalendarDataSource extends CalendarDataSource {
  LectureCalendarDataSource({
    required List<LectureViewModel> items,
    required LectureRangeLoader loadMoreLectures,
  }) : _items = List<LectureViewModel>.from(items),
       _loadMoreLectures = loadMoreLectures {
    appointments = _items;
  }

  final List<LectureViewModel> _items;
  final LectureRangeLoader _loadMoreLectures;
  bool _isLoadingMore = false;

  LectureViewModel _get(int index) => _items[index];

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

  @override
  Future<void> handleLoadMore(DateTime startDate, DateTime endDate) async {
    if (_isLoadingMore) {
      return;
    }
    _isLoadingMore = true;
    try {
      print('로드모어 시작');
      final List<LectureViewModel> nextItems = await _loadMoreLectures(
        startDate,
        endDate,
      );
      print('다음 아이템: $nextItems');
      if (nextItems.isEmpty) {
        notifyListeners(CalendarDataSourceAction.reset, _items);
        return;
      }
      print('머지 시작');
      _mergeAppointments(nextItems);
    } finally {
      print('로드모어 종료');
      _isLoadingMore = false;
    }
  }

  /// 기존 일정과 신규 데이터를 병합해 정렬 후 Syncfusion에 알린다.
  void _mergeAppointments(List<LectureViewModel> incoming) {
    final Map<String, LectureViewModel> merged = <String, LectureViewModel>{
      for (final LectureViewModel lecture in _items) lecture.id: lecture,
    };
    for (final LectureViewModel lecture in incoming) {
      final LectureViewModel? existing = merged[lecture.id];
      if (existing == null || lecture.version >= existing.version) {
        merged[lecture.id] = lecture;
      }
    }
    final List<LectureViewModel> sorted = merged.values.toList()
      ..sort(
        (LectureViewModel a, LectureViewModel b) => a.start.compareTo(b.start),
      );
    _items
      ..clear()
      ..addAll(sorted);
    appointments = _items;
    notifyListeners(CalendarDataSourceAction.reset, _items);
  }
}
