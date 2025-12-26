import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:web_dashboard/common/responsive/responsive_layout.dart';
import 'package:web_dashboard/common/widgets/custom_card.dart';
import 'package:web_dashboard/core/classroom_detail/application/classroom_detail_providers.dart';
import 'package:web_dashboard/core/classroom_detail/application/devices/classroom_device_controller.dart';
import 'package:web_dashboard/core/classroom_detail/application/sensors/classroom_sensor_providers.dart';
import 'package:web_dashboard/core/classroom_detail/domain/entities/classroom_detail_entity.dart';

const double _headerHeight = 132;
const double _panelSpacing = 16;
const EdgeInsets _panelPadding = EdgeInsets.all(24);
const BorderRadius _tileRadius = BorderRadius.all(Radius.circular(16));

class ClassroomDetailHeaderSection extends ConsumerWidget {
  const ClassroomDetailHeaderSection({
    required this.classroomId,
    this.onCameraPressed,
    super.key,
  });

  final String classroomId;
  final VoidCallback? onCameraPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ResponsiveLayoutBuilder(
      builder: (BuildContext context, DeviceFormFactor formFactor) {
        final bool isWideLayout = formFactor != DeviceFormFactor.mobile;
        return Column(
          spacing: _panelSpacing,
          children: <Widget>[
            _HeaderTitle(
              classroomId: classroomId,
              isWideLayout: isWideLayout,
              onCameraPressed: onCameraPressed,
            ),
            SizedBox(
              height: isWideLayout ? _headerHeight : null,
              child: ResponsiveRowColumn(
                layout: isWideLayout
                    ? ResponsiveRowColumnType.ROW
                    : ResponsiveRowColumnType.COLUMN,
                rowMainAxisAlignment: MainAxisAlignment.center,
                rowCrossAxisAlignment: CrossAxisAlignment.center,
                rowSpacing: _panelSpacing,
                columnSpacing: _panelSpacing,
                children: <ResponsiveRowColumnItem>[
                  ResponsiveRowColumnItem(
                    rowFlex: 3,
                    child: _RoomSummaryCard(classroomId: classroomId),
                  ),
                  ResponsiveRowColumnItem(
                    child: _DevicePanel(classroomId: classroomId),
                  ),
                  ResponsiveRowColumnItem(
                    child: _EnvironmentPanel(classroomId: classroomId),
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

class _HeaderTitle extends ConsumerWidget {
  const _HeaderTitle({
    required this.classroomId,
    required this.isWideLayout,
    this.onCameraPressed,
  });

  final String classroomId;
  final bool isWideLayout;
  final VoidCallback? onCameraPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<ClassroomSummaryViewModel> summary = ref.watch(
      classroomSummaryViewModelProvider(classroomId),
    );
    final TextTheme textTheme = Theme.of(context).textTheme;
    return ResponsiveRowColumn(
      layout: isWideLayout
          ? ResponsiveRowColumnType.ROW
          : ResponsiveRowColumnType.COLUMN,
      rowSpacing: _panelSpacing,
      columnSpacing: _panelSpacing,
      rowMainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <ResponsiveRowColumnItem>[
        ResponsiveRowColumnItem(
          child: summary.when(
            data: (ClassroomSummaryViewModel data) => SizedBox(
              width: isWideLayout ? 300 : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    data.roomName,
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (data.departmentName != null)
                    Text(
                      data.departmentName!,
                      style: textTheme.titleMedium?.copyWith(
                        color: textTheme.headlineSmall?.color?.withValues(
                          alpha: 0.9,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            loading: () => const SizedBox(height: 52),
            error: (_, __) => const SizedBox(height: 52),
          ),
        ),
        ResponsiveRowColumnItem(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: _panelSpacing,
            children: <Widget>[
              _RoomOccupancyInfo(classroomId: classroomId),
              ElevatedButton(
                onPressed: onCameraPressed,
                child: Text('실시간 카메라 보기', style: textTheme.bodyMedium),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RoomSummaryCard extends ConsumerWidget {
  const _RoomSummaryCard({required this.classroomId});

  final String classroomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<ClassroomDetailEntity> detail = ref.watch(
      classroomDetailInfoProvider(classroomId),
    );
    final TextTheme textTheme = Theme.of(context).textTheme;
    return detail.when(
      data: (ClassroomDetailEntity entity) => CustomCard(
        padding: _panelPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: <Widget>[
            Text(entity.name, style: textTheme.titleLarge),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: <Widget>[
                _SummaryChip(
                  icon: Icons.apartment,
                  label: entity.building?.name ?? '건물 정보 없음',
                ),
                _SummaryChip(
                  icon: Icons.groups,
                  label: '${entity.capacity ?? 0}명 수용',
                ),
                _SummaryChip(
                  icon: Icons.meeting_room_outlined,
                  label: entity.type.name,
                ),
              ],
            ),
          ],
        ),
      ),
      loading: () => const _LoadingTile(height: 120),
      error: (_, __) => const _ErrorTile(message: '강의실 정보를 불러올 수 없습니다.'),
    );
  }
}

class _DevicePanel extends ConsumerWidget {
  const _DevicePanel({required this.classroomId});

  final String classroomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ClassroomDeviceControllerState state = ref.watch(
      classroomDeviceControllerProvider(classroomId),
    );
    final ClassroomDeviceController controller = ref.read(
      classroomDeviceControllerProvider(classroomId).notifier,
    );
    if (state.devices.isEmpty) {
      return const _ErrorTile(message: '연동된 장비가 없습니다.');
    }
    return CustomCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        spacing: 6,
        children: <Widget>[
          if (state.isUpdating) const LinearProgressIndicator(minHeight: 2),
          ...state.devices.map(
            (ClassroomDeviceViewModel device) => SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: Text(device.name),
              subtitle: Text(device.type),
              value: device.isEnabled,
              onChanged: (bool value) =>
                  controller.toggleDevice(device.id, value),
            ),
          ),
          if (state.errorMessage != null)
            Text(
              state.errorMessage!,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
        ],
      ),
    );
  }
}

class _EnvironmentPanel extends ConsumerWidget {
  const _EnvironmentPanel({required this.classroomId});

  final String classroomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<EnvironmentMetricViewModel>> metricsValue = ref.watch(
      classroomEnvironmentMetricsProvider(classroomId),
    );
    return metricsValue.when(
      data: (List<EnvironmentMetricViewModel> metrics) {
        if (metrics.isEmpty) {
          return const _ErrorTile(message: '센서 정보가 없습니다.');
        }
        return Wrap(
          spacing: _panelSpacing,
          runSpacing: _panelSpacing,
          children: metrics
              .map(
                (EnvironmentMetricViewModel metric) =>
                    _EnvironmentTile(metric: metric),
              )
              .toList(),
        );
      },
      loading: () => const _LoadingTile(height: 120),
      error: (_, __) => const _ErrorTile(message: '센서 데이터를 불러오지 못했습니다.'),
    );
  }
}

class _RoomOccupancyInfo extends ConsumerWidget {
  const _RoomOccupancyInfo({required this.classroomId});

  final String classroomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<ClassroomDetailEntity> detail = ref.watch(
      classroomDetailInfoProvider(classroomId),
    );
    final ThemeData theme = Theme.of(context);
    return detail.when(
      data: (ClassroomDetailEntity entity) {
        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: _tileRadius,
            color: theme.colorScheme.primaryContainer,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 6,
              children: <Widget>[
                Text('수용 인원', style: theme.textTheme.labelLarge),
                Text(
                  '${entity.capacity ?? 0}명',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const _LoadingTile(height: 64, width: 160),
      error: (_, __) => const _ErrorTile(message: '재실 정보를 불러올 수 없습니다.'),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(label, style: textTheme.bodySmall),
    );
  }
}

class _EnvironmentTile extends StatelessWidget {
  const _EnvironmentTile({required this.metric});

  final EnvironmentMetricViewModel metric;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return CustomCard(
      padding: _panelPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.sensors, size: 18),
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

class _LoadingTile extends StatelessWidget {
  const _LoadingTile({this.height = 100, this.width});

  final double height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: _tileRadius,
        color: Theme.of(context).colorScheme.surfaceVariant,
      ),
      child: const CircularProgressIndicator(strokeWidth: 2),
    );
  }
}

class _ErrorTile extends StatelessWidget {
  const _ErrorTile({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: _panelPadding,
      decoration: BoxDecoration(
        borderRadius: _tileRadius,
        color: Theme.of(context).colorScheme.errorContainer,
      ),
      child: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.onErrorContainer,
        ),
      ),
    );
  }
}
