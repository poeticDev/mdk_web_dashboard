/// ROLE
/// - 대시보드 메트릭 카드 그룹을 제공한다
///
/// RESPONSIBILITY
/// - 메트릭 카드 배열과 선택 상태를 렌더링한다
///
/// DEPENDS ON
/// - theme_utilities
/// - dashboard_status
/// - dashboard_state
/// - dashboard_metric_card
library;

import 'package:flutter/material.dart';
import 'package:mdk_app_theme/theme_utilities.dart';
import 'package:web_dashboard/features/dashboard/application/state/dashboard_state.dart';
import 'package:web_dashboard/features/dashboard/presentation/widgets/dashboard_metric_card.dart';
import 'package:web_dashboard/features/dashboard/presentation/widgets/header/dashboard_header_layout.dart';
import 'package:web_dashboard/features/dashboard/viewmodels/dashboard_status.dart';

class DashboardMetricGroup extends StatelessWidget {
  const DashboardMetricGroup({
    required this.totalCount,
    required this.inUseCount,
    required this.idleCount,
    required this.unlinkedCount,
    required this.isTotalSelected,
    required this.filters,
    required this.colors,
    required this.onToggleActivityStatus,
    required this.onToggleLinkStatus,
    required this.onClearStatusFilters,
    super.key,
  });

  final int totalCount;
  final int inUseCount;
  final int idleCount;
  final int unlinkedCount;
  final bool isTotalSelected;
  final DashboardFilterState filters;
  final AppColors colors;
  final ValueChanged<DashboardActivityStatus> onToggleActivityStatus;
  final ValueChanged<DashboardLinkStatus> onToggleLinkStatus;
  final VoidCallback onClearStatusFilters;

  @override
  Widget build(BuildContext context) {

    return Wrap(
      spacing: headerGap,
      runSpacing: headerGap,
      children: <Widget>[
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: metricMinWidth),
          child: DashboardMetricCard(
            label: '전체',
            value: totalCount,
            isSelected: isTotalSelected,
            accentColor: colors.primaryVariant,
            onTap: onClearStatusFilters,
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: metricMinWidth),
          child: DashboardMetricCard(
            label: '사용 중',
            value: inUseCount,
            isSelected: filters.activityStatus == DashboardActivityStatus.inUse,
            accentColor: colors.success,
            onTap: () => onToggleActivityStatus(DashboardActivityStatus.inUse),
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: metricMinWidth),
          child: DashboardMetricCard(
            label: '미사용',
            value: idleCount,
            isSelected: filters.activityStatus == DashboardActivityStatus.idle,
            accentColor: colors.textSecondary,
            onTap: () => onToggleActivityStatus(DashboardActivityStatus.idle),
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: metricMinWidth),
          child: DashboardMetricCard(
            label: '미연동',
            value: unlinkedCount,
            isSelected: filters.linkStatus == DashboardLinkStatus.unlinked,
            accentColor: colors.warning,
            onTap: () => onToggleLinkStatus(DashboardLinkStatus.unlinked),
          ),
        ),
      ],
    );
  }
}
