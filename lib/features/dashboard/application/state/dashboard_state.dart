/// ROLE
/// - 대시보드 상태 모델을 정의한다
///
/// RESPONSIBILITY
/// - 필터/카드/메트릭/로딩 상태를 보관한다
///
/// DEPENDS ON
/// - freezed_annotation
/// - dashboard_viewmodels
library;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:web_dashboard/features/dashboard/viewmodels/dashboard_classroom_card_view_model.dart';
import 'package:web_dashboard/features/dashboard/viewmodels/dashboard_metrics_view_model.dart';
import 'package:web_dashboard/features/dashboard/viewmodels/dashboard_usage_status.dart';

part 'dashboard_state.freezed.dart';

const String _emptyQuery = '';

@freezed
abstract class DashboardFilterState with _$DashboardFilterState {
  const DashboardFilterState._();

  const factory DashboardFilterState({
    @Default(_emptyQuery) String query,
    @Default(<DashboardUsageStatus>{})
    Set<DashboardUsageStatus> usageStatuses,
    @Default(<String>{}) Set<String> departmentIds,
    @Default(<String>{}) Set<String> buildingIds,
  }) = _DashboardFilterState;
}

@freezed
abstract class DashboardState with _$DashboardState {
  const DashboardState._();

  const factory DashboardState({
    @Default(<DashboardClassroomCardViewModel>[])
    List<DashboardClassroomCardViewModel> cards,
    DashboardMetricsViewModel? metrics,
    @Default(DashboardFilterState()) DashboardFilterState filters,
    @Default(false) bool isLoading,
    @Default(false) bool isStreaming,
    DateTime? lastUpdatedAt,
    String? errorMessage,
  }) = _DashboardState;

  factory DashboardState.initial() => const DashboardState();

  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;
}
