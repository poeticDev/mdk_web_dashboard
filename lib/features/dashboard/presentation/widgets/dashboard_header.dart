/// ROLE
/// - 대시보드 헤더 UI를 제공한다
///
/// RESPONSIBILITY
/// - 현재 시각, KPI, 검색 입력 영역을 구성한다
///
/// DEPENDS ON
/// - theme_utilities
/// - dashboard_viewmodels
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mdk_app_theme/theme_utilities.dart';
import 'package:web_dashboard/features/dashboard/presentation/widgets/dashboard_metric_card.dart';
import 'package:web_dashboard/features/dashboard/presentation/widgets/dashboard_search_field.dart';
import 'package:web_dashboard/features/dashboard/viewmodels/dashboard_metrics_view_model.dart';
import 'package:web_dashboard/features/dashboard/viewmodels/dashboard_status.dart';
import 'package:web_dashboard/features/dashboard/application/state/dashboard_state.dart';

const Duration _clockTick = Duration(seconds: 1);
const Duration _kstOffset = Duration(hours: 9);
const double _headerGap = 16;
const double _metricMinWidth = 180;
const double _searchMinWidth = _metricMinWidth;
const double _searchMaxWidth = 240;
const double _clockMinWidth = 260;
const double _headerCardRadius = 18;
const double _headerCardPadding = 18;

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
    final DashboardHeaderCounts counts = _resolveCounts(metrics);
    final int totalCount = counts.total ?? 0;
    final bool isTotalSelected =
        filters.activityStatus == null && filters.linkStatus == null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Wrap(
          spacing: _headerGap,
          runSpacing: _headerGap,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            _ClockCard(minWidth: _clockMinWidth),
            _MetricGroup(
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
                minWidth: _searchMinWidth,
                maxWidth: _searchMaxWidth,
              ),
              child: DashboardSearchField(
                initialValue: filters.query,
                onQueryChanged: onQueryChanged,
              ),
            ),
            _StreamingBadge(isStreaming: isStreaming),
          ],
        ),
      ],
    );
  }
}

class _MetricGroup extends StatelessWidget {
  const _MetricGroup({
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
      spacing: _headerGap,
      runSpacing: _headerGap,
      children: <Widget>[
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: _metricMinWidth),
          child: DashboardMetricCard(
            label: '전체',
            value: totalCount,
            isSelected: isTotalSelected,
            accentColor: colors.primaryVariant,
            onTap: onClearStatusFilters,
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: _metricMinWidth),
          child: DashboardMetricCard(
            label: '사용 중',
            value: inUseCount,
            isSelected: filters.activityStatus == DashboardActivityStatus.inUse,
            accentColor: colors.success,
            onTap: () => onToggleActivityStatus(DashboardActivityStatus.inUse),
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: _metricMinWidth),
          child: DashboardMetricCard(
            label: '미사용',
            value: idleCount,
            isSelected: filters.activityStatus == DashboardActivityStatus.idle,
            accentColor: colors.textSecondary,
            onTap: () => onToggleActivityStatus(DashboardActivityStatus.idle),
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: _metricMinWidth),
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

class _ClockCard extends StatelessWidget {
  const _ClockCard({required this.minWidth});

  final double minWidth;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final AppColors colors = isDark
        ? AppColors.dark(ThemeBrand.defaultBrand)
        : AppColors.light(ThemeBrand.defaultBrand);

    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: minWidth),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_headerCardRadius),
        ),
        child: Container(
          padding: const EdgeInsets.all(_headerCardPadding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_headerCardRadius),
            color: colors.surface,
          ),
          child: StreamBuilder<DateTime>(
            stream: Stream<DateTime>.periodic(
              _clockTick,
              (_) => _nowInKst(),
            ),
            initialData: _nowInKst(),
            builder: (BuildContext context, AsyncSnapshot<DateTime> snapshot) {
              final DateTime now = snapshot.data ?? _nowInKst();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '현재 시각',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatKoreanDate(now),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colors.primaryVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatClock(now),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _StreamingBadge extends StatelessWidget {
  const _StreamingBadge({required this.isStreaming});

  final bool isStreaming;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final AppColors colors = isDark
        ? AppColors.dark(ThemeBrand.defaultBrand)
        : AppColors.light(ThemeBrand.defaultBrand);
    final Color badgeColor = isStreaming ? colors.success : colors.warning;
    final String label = isStreaming ? '연결됨' : '연결 끊김';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: isDark ? 0.18 : 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: badgeColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            isStreaming ? Icons.wifi : Icons.wifi_off,
            color: badgeColor,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: badgeColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

DashboardHeaderCounts _resolveCounts(DashboardMetricsViewModel? metrics) {
  return DashboardHeaderCounts(
    total: metrics?.totalCount,
    inUse: metrics?.inUseCount,
    idle: metrics?.idleCount,
    unlinked: metrics?.unlinkedCount,
  );
}

DateTime _nowInKst() => DateTime.now().toUtc().add(_kstOffset);

String _formatKoreanDate(DateTime dateTime) {
  final DateFormat format = DateFormat('yyyy년 M월 d일 (E)', 'ko_KR');
  return format.format(dateTime);
}

String _formatClock(DateTime dateTime) {
  final DateFormat format = DateFormat('HH:mm:ss', 'ko_KR');
  return format.format(dateTime);
}

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
