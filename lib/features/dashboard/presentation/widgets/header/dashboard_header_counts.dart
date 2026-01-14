/// ROLE
/// - 헤더 카운트 결과 모델을 정의한다
///
/// RESPONSIBILITY
/// - 메트릭 뷰모델에서 헤더 카운트를 추출한다
///
/// DEPENDS ON
/// - dashboard_metrics_view_model
library;

import 'package:web_dashboard/features/dashboard/viewmodels/dashboard_metrics_view_model.dart';

class DashboardHeaderCounts {
  const DashboardHeaderCounts({
    required this.total,
    required this.inUse,
    required this.idle,
    required this.unlinked,
  });

  final int? total;
  final int? inUse;
  final int? idle;
  final int? unlinked;
}

DashboardHeaderCounts resolveDashboardCounts(
  DashboardMetricsViewModel? metrics,
) {
  return DashboardHeaderCounts(
    total: metrics?.totalCount,
    inUse: metrics?.inUseCount,
    idle: metrics?.idleCount,
    unlinked: metrics?.unlinkedCount,
  );
}
