import 'package:flutter/material.dart';
import 'package:web_dashboard/ui/classroom_detail/models/classroom_detail_header_data.dart';

const double _panelSpacing = 16;
const EdgeInsets _panelPadding = EdgeInsets.all(24);
const double _wideLayoutBreakpoint = 960;
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
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool isWide = constraints.maxWidth >= _wideLayoutBreakpoint;
        // Summary와 제어 패널을 해상도에 따라 3:2 비율로 배치한다.
        return Flex(
          direction: isWide ? Axis.horizontal : Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildSummaryChild(isWide),
            SizedBox(
              width: isWide ? _panelSpacing : 0,
              height: isWide ? 0 : _panelSpacing,
            ),
            _buildControlChild(isWide),
          ],
        );
      },
    );
  }

  Widget _buildSummaryChild(bool isWide) {
    final Widget child = _RoomSummaryCard(summary: data.summary);
    return isWide ? Expanded(flex: 3, child: child) : child;
  }

  Widget _buildControlChild(bool isWide) {
    final Widget child = _ControlPanelCard(
      toggles: data.deviceToggles,
      metrics: data.environmentMetrics,
      onToggleChanged: onToggleChanged,
      onCameraPressed: onCameraPressed,
    );
    return isWide ? Expanded(flex: 2, child: child) : child;
  }
}

class _RoomSummaryCard extends StatelessWidget {
  const _RoomSummaryCard({required this.summary});

  final ClassroomSummaryInfo summary;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: _panelPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _RoomTitle(summary: summary),
            const SizedBox(height: _panelSpacing),
            _RoomSessionInfo(summary: summary),
            const SizedBox(height: _panelSpacing),
            _RoomOccupancyInfo(summary: summary),
          ],
        ),
      ),
    );
  }
}

class _RoomTitle extends StatelessWidget {
  const _RoomTitle({required this.summary});

  final ClassroomSummaryInfo summary;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          summary.roomName,
          style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(
          summary.department,
          style: textTheme.titleMedium?.copyWith(
            color: textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 12),
        _StatusBadge(status: summary.status),
      ],
    );
  }
}

class _RoomSessionInfo extends StatelessWidget {
  const _RoomSessionInfo({required this.summary});

  final ClassroomSummaryInfo summary;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          summary.currentCourse,
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text('담당: ${summary.professor}', style: textTheme.bodyMedium),
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            const Icon(Icons.schedule_rounded, size: 18),
            const SizedBox(width: 8),
            Text(
              summary.sessionTime.label(context),
              style: textTheme.bodyMedium,
            ),
          ],
        ),
      ],
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
        child: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: scheme.primary,
              child: const Icon(Icons.people_alt_outlined, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('재실 인원', style: textTheme.labelLarge),
                Text(summary.occupancyLabel, style: textTheme.titleMedium),
              ],
            ),
            const Spacer(),
            _OccupancyGauge(rate: summary.occupancyRate),
          ],
        ),
      ),
    );
  }
}

class _OccupancyGauge extends StatelessWidget {
  const _OccupancyGauge({required this.rate});

  final double rate;

  @override
  Widget build(BuildContext context) {
    final double displayRate = rate.clamp(0, 1);
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            '${(displayRate * 100).round()}%',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(999)),
            child: LinearProgressIndicator(
              value: displayRate,
              minHeight: 6,
              backgroundColor: scheme.surface,
              valueColor: AlwaysStoppedAnimation<Color>(scheme.primary),
            ),
          ),
        ],
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
    return Card(
      child: Padding(
        padding: _panelPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '제어 패널',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: _panelSpacing),
            ...toggles.map(
              (DeviceToggleStatus toggle) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _DeviceToggleTile(
                  toggle: toggle,
                  onChanged: (bool value) =>
                      onToggleChanged?.call(toggle.id, value),
                ),
              ),
            ),
            const SizedBox(height: _panelSpacing),
            Text('환경 정보', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            _EnvironmentGrid(metrics: metrics),
            const SizedBox(height: _panelSpacing),
            OutlinedButton.icon(
              onPressed: onCameraPressed,
              icon: const Icon(Icons.videocam_outlined),
              label: const Text('실시간 카메라 열기'),
            ),
          ],
        ),
      ),
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
            child: Icon(toggle.icon),
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
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(borderRadius: _tileRadius, color: cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(metric.icon, size: 20),
              const SizedBox(width: 8),
              Text(metric.label, style: textTheme.labelLarge),
            ],
          ),
          const SizedBox(height: 12),
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
