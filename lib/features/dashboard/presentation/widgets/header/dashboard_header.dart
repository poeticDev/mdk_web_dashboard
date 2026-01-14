/// ROLE
/// - 대시보드 헤더 UI를 제공한다
///
/// RESPONSIBILITY
/// - 현재 시각, KPI, 검색 입력 영역을 구성한다
///
/// DEPENDS ON
/// - dashboard_header_widgets
library;

import 'package:flutter/material.dart';
import 'package:mdk_app_theme/theme_utilities.dart';
import 'package:web_dashboard/features/dashboard/application/state/dashboard_state.dart';
import 'package:web_dashboard/features/dashboard/presentation/widgets/header/dashboard_search_field.dart';
import 'package:web_dashboard/features/dashboard/presentation/widgets/header/dashboard_clock_card.dart';
import 'package:web_dashboard/features/dashboard/presentation/widgets/header/dashboard_header_counts.dart';
import 'package:web_dashboard/features/dashboard/presentation/widgets/header/dashboard_header_layout.dart';
import 'package:web_dashboard/features/dashboard/presentation/widgets/header/dashboard_metric_group.dart';
import 'package:web_dashboard/features/dashboard/presentation/widgets/header/dashboard_streaming_badge.dart';
import 'package:web_dashboard/features/dashboard/viewmodels/dashboard_metrics_view_model.dart';
import 'package:web_dashboard/features/dashboard/viewmodels/dashboard_status.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    required this.metrics,
    required this.filters,
    required this.isStreaming,
    required this.onQueryChanged,
    required this.onToggleActivityStatus,
    required this.onToggleLinkStatus,
    required this.onClearStatusFilters,
    super.key,
  });

  final DashboardMetricsViewModel? metrics;
  final DashboardFilterState filters;
  final bool isStreaming;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<DashboardActivityStatus> onToggleActivityStatus;
  final ValueChanged<DashboardLinkStatus> onToggleLinkStatus;
  final VoidCallback onClearStatusFilters;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final AppColors colors = isDark
        ? AppColors.dark(ThemeBrand.defaultBrand)
        : AppColors.light(ThemeBrand.defaultBrand);
    final DashboardHeaderCounts counts = resolveDashboardCounts(metrics);
    final int totalCount = counts.total ?? 0;
    final bool isTotalSelected =
        filters.activityStatus == null && filters.linkStatus == null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Wrap(
          spacing: headerGap,
          runSpacing: headerGap,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            const DashboardClockCard(minWidth: clockMinWidth),
            DashboardMetricGroup(
              totalCount: totalCount,
              inUseCount: counts.inUse ?? 0,
              idleCount: counts.idle ?? 0,
              unlinkedCount: counts.unlinked ?? 0,
              isTotalSelected: isTotalSelected,
              filters: filters,
              colors: colors,
              onToggleActivityStatus: onToggleActivityStatus,
              onToggleLinkStatus: onToggleLinkStatus,
              onClearStatusFilters: onClearStatusFilters,
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: searchMinWidth,
                maxWidth: searchMaxWidth,
              ),
              child: DashboardSearchField(
                initialValue: filters.query,
                onQueryChanged: onQueryChanged,
              ),
            ),
            DashboardStreamingBadge(isStreaming: isStreaming),
          ],
        ),
      ],
    );
  }
}
