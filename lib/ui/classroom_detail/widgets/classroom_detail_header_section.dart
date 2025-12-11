import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:web_dashboard/common/responsive/responsive_layout.dart';
import 'package:web_dashboard/ui/classroom_detail/models/classroom_detail_header_data.dart';
import 'package:web_dashboard/common/widgets/custom_card.dart';

const double _headerHeight = 132;

const double _panelSpacing = 16;
const EdgeInsets _panelPadding = EdgeInsets.all(24);
const BorderRadius _tileRadius = BorderRadius.all(Radius.circular(16));

class ClassroomDetailHeaderSection extends StatelessWidget {
  const ClassroomDetailHeaderSection({
    required this.data,
    this.onToggleChanged,
    this.onCameraPressed,
    super.key,
  });

  final ClassroomDetailHeaderData data;
  final void Function(String toggleId, bool value)? onToggleChanged;
  final VoidCallback? onCameraPressed;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      builder: (BuildContext context, DeviceFormFactor formFactor) {
        // 모바일은 단일 컬럼, 그 이상은 가로 3:2 레이아웃으로 전환한다.
        final bool isWideLayout = formFactor != DeviceFormFactor.mobile;
        return Column(
          spacing: _panelSpacing,
          children: [
            _RoomTitle(summary: data.summary, isWideLayout: isWideLayout),
            SizedBox(
              height: isWideLayout ? _headerHeight : null,
              child: ResponsiveRowColumn(
                layout: isWideLayout
                    ? ResponsiveRowColumnType.ROW
                    : ResponsiveRowColumnType.COLUMN,
                rowMainAxisAlignment: MainAxisAlignment.center,
                rowCrossAxisAlignment: CrossAxisAlignment.center,
                // columnCrossAxisAlignment: CrossAxisAlignment.start,
                rowSpacing: _panelSpacing,
                columnSpacing: _panelSpacing,
                children: <ResponsiveRowColumnItem>[
                  ResponsiveRowColumnItem(
                    rowFlex: 3,
                    child: _RoomSummaryCard(summary: data.summary),
                  ),
                  ResponsiveRowColumnItem(
                    child: SizedBox(
                      width: 180,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        spacing: 4.0,
                        children: data.deviceToggles
                            .map(
                              (DeviceToggleStatus toggle) => _DeviceToggleRow(
                                toggle: toggle,
                                onChanged: (bool value) =>
                                    onToggleChanged?.call(toggle.id, value),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),

                  ...data.environmentMetrics.map(
                    (EnvironmentMetric metric) => ResponsiveRowColumnItem(
                      child: _EnvironmentTile(metric: metric),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _RoomTitle extends StatelessWidget {
  const _RoomTitle({required this.summary, required this.isWideLayout});

  final bool isWideLayout;

  final ClassroomSummaryInfo summary;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return ResponsiveRowColumn(
      layout: isWideLayout
          ? ResponsiveRowColumnType.ROW
          : ResponsiveRowColumnType.COLUMN,
      rowSpacing: _panelSpacing,
      columnSpacing: _panelSpacing,
      rowMainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        ResponsiveRowColumnItem(
          child: SizedBox(
            width: isWideLayout ? 300 : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  summary.roomName,
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  summary.department,
                  style: textTheme.titleMedium?.copyWith(
                    color: textTheme.headlineSmall?.color?.withValues(
                      alpha: 0.9,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        ResponsiveRowColumnItem(child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: _panelSpacing,
          children: [
            _RoomOccupancyInfo(summary: summary),
            ElevatedButton(
            onPressed: () {},
            child: Text('실시간 카메라 보기', style: textTheme.bodyMedium),
          ),
          ],
        )),
        // ResponsiveRowColumnItem(
        //   child: ElevatedButton(
        //     onPressed: () {},
        //     child: Text('실시간 카메라 보기', style: textTheme.bodyMedium),
        //   ),
        // ),
      ],
    );
  }
}

class _RoomSummaryCard extends StatelessWidget {
  const _RoomSummaryCard({required this.summary});

  final ClassroomSummaryInfo summary;

  @override
  Widget build(BuildContext context) {
    const double spacing = 8.0;
    const double runSpacing = 8.0;

    final TextTheme textTheme = Theme.of(context).textTheme;

    return CustomCard(
      child: 
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: runSpacing,
            children: <Widget>[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: spacing,
                  children: [
                    _StatusBadge(status: summary.status),
                    Text(
                      summary.sessionTime.label(context),
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: spacing,
                  children: [
                    Text(
                      summary.currentCourse,
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
          
                    Text(summary.professor, style: textTheme.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoomOccupancyInfo extends StatelessWidget {
  const _RoomOccupancyInfo({required this.summary});

  final ClassroomSummaryInfo summary;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: _tileRadius,
        color: scheme.primary.withValues(alpha: 0.08),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 8.0,
          children: <Widget>[
            Text('재실 상태', style: textTheme.labelLarge),
            CircleAvatar(
              backgroundColor: scheme.primary,
              child: const Icon(Icons.people_alt_outlined, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final ClassroomSessionStatus status;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _statusColor(scheme).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(_statusIcon, size: 16, color: _statusColor(scheme)),
          const SizedBox(width: 6),
          Text(
            status.label,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: _statusColor(scheme)),
          ),
        ],
      ),
    );
  }

  IconData get _statusIcon {
    switch (status) {
      case ClassroomSessionStatus.inUse:
        return Icons.circle;
      case ClassroomSessionStatus.idle:
        return Icons.pause_circle_filled_rounded;
      case ClassroomSessionStatus.disconnected:
        return Icons.offline_bolt_rounded;
    }
  }

  Color _statusColor(ColorScheme scheme) {
    switch (status) {
      case ClassroomSessionStatus.inUse:
        return scheme.primary;

      case ClassroomSessionStatus.idle:
        return scheme.secondary;
      case ClassroomSessionStatus.disconnected:
        return scheme.error;
    }
  }
}

class _ControlPanelCard extends StatelessWidget {
  const _ControlPanelCard({
    required this.toggles,
    required this.metrics,
    this.onToggleChanged,
    this.onCameraPressed,
  });

  final List<DeviceToggleStatus> toggles;
  final List<EnvironmentMetric> metrics;
  final void Function(String toggleId, bool value)? onToggleChanged;
  final VoidCallback? onCameraPressed;

  @override
  Widget build(BuildContext context) {
    // 토글 → 환경 지표 → 카메라 순서로 컨트롤 흐름을 고정해 사용자 문맥을 유지한다.
    return CustomCard(
      padding: _panelPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[_EnvironmentGrid(metrics: metrics)],
      ),
    );
  }
}

class _VerticalDeviceToggleCard extends StatelessWidget {
  const _VerticalDeviceToggleCard({required this.toggle, this.onChanged});

  final DeviceToggleStatus toggle;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Tooltip(
      message: toggle.description ?? "",
      preferBelow: false,
      waitDuration: const Duration(seconds: 3),
      child: CustomCard(
        width: 140,
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 2.0,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 4.0,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  child: Icon(
                    toggle.icon,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  toggle.label,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
            Switch(value: toggle.isOn, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}

class _DeviceToggleRow extends StatelessWidget {
  const _DeviceToggleRow({required this.toggle, this.onChanged});
  final DeviceToggleStatus toggle;
  final ValueChanged<bool>? onChanged;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 4.0,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Theme.of(context).colorScheme.surface,
          child: Icon(
            toggle.icon,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        Text(toggle.label, style: Theme.of(context).textTheme.titleSmall),
        SizedBox(),
        Switch(value: toggle.isOn, onChanged: onChanged),
      ],
    );
  }
}

class _DeviceToggleTile extends StatelessWidget {
  const _DeviceToggleTile({required this.toggle, this.onChanged});

  final DeviceToggleStatus toggle;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final Color borderColor = Theme.of(
      context,
    ).dividerColor.withValues(alpha: 0.6);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: _tileRadius,
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 20,
            backgroundColor: Theme.of(context).colorScheme.surface,
            child: Icon(
              toggle.icon,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  toggle.label,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                if (toggle.description != null)
                  Text(
                    toggle.description!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ),
          Switch(value: toggle.isOn, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _EnvironmentGrid extends StatelessWidget {
  const _EnvironmentGrid({required this.metrics});

  final List<EnvironmentMetric> metrics;

  @override
  Widget build(BuildContext context) {
    // 센서 지표 개수가 변해도 줄바꿈으로 자연스럽게 재배치한다.
    return Wrap(
      spacing: _panelSpacing,
      runSpacing: _panelSpacing,
      children: metrics
          .map((EnvironmentMetric metric) => _EnvironmentTile(metric: metric))
          .toList(),
    );
  }
}

class _EnvironmentTile extends StatelessWidget {
  const _EnvironmentTile({required this.metric});

  final EnvironmentMetric metric;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Color cardColor = Theme.of(context).colorScheme.surface;
    return CustomCard(
      padding: _panelPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(metric.icon, size: 20),
              const SizedBox(width: 8),
              Text(metric.label, style: textTheme.labelLarge),
            ],
          ),
          Text(
            '${metric.value}${metric.unit}',
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
