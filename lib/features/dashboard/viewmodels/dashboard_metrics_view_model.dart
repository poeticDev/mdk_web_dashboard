/// ROLE
/// - 대시보드 KPI 뷰모델을 정의한다
///
/// RESPONSIBILITY
/// - 메트릭 집계 결과를 UI용으로 보관한다
///
/// DEPENDS ON
/// - 없음
library;

import 'package:flutter/foundation.dart';

const int _defaultCount = 0;

@immutable
class DashboardMetricsViewModel {
  const DashboardMetricsViewModel({
    required this.totalCount,
    required this.inUseCount,
    required this.idleCount,
    required this.unlinkedCount,
    required this.timestamp,
    this.scheduleSummary,
    this.occupancySummary,
  });

  final int totalCount;
  final int inUseCount;
  final int idleCount;
  final int unlinkedCount;
  final DateTime timestamp;
  final DashboardScheduleSummaryViewModel? scheduleSummary;
  final DashboardOccupancySummaryViewModel? occupancySummary;

  factory DashboardMetricsViewModel.empty(DateTime timestamp) {
    return DashboardMetricsViewModel(
      totalCount: _defaultCount,
      inUseCount: _defaultCount,
      idleCount: _defaultCount,
      unlinkedCount: _defaultCount,
      timestamp: timestamp,
    );
  }
}

@immutable
class DashboardScheduleSummaryViewModel {
  const DashboardScheduleSummaryViewModel({
    required this.total,
    required this.inLecture,
    required this.noSchedule,
    required this.updatedAt,
  });

  final int total;
  final int inLecture;
  final int noSchedule;
  final DateTime updatedAt;
}

@immutable
class DashboardOccupancySummaryViewModel {
  const DashboardOccupancySummaryViewModel({
    required this.occupied,
    required this.vacant,
    required this.notLinked,
    required this.updatedAt,
  });

  final int occupied;
  final int vacant;
  final int notLinked;
  final DateTime updatedAt;
}
