import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_dashboard/features/classroom_detail/application/realtime/classroom_sensor_providers.dart';
import 'package:web_dashboard/ui/classroom_detail/widgets/header/header_shared_tiles.dart';

/// 온도·습도 등 실시간 환경 지표를 보여주는 패널.
class EnvironmentPanel extends ConsumerWidget {
  const EnvironmentPanel({required this.classroomId, super.key});

  final String classroomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<EnvironmentMetricViewModel>> metricsValue = ref.watch(
      classroomEnvironmentMetricsProvider(classroomId),
    );
    return metricsValue.when(
      data: (List<EnvironmentMetricViewModel> metrics) {
        if (metrics.isEmpty) {
          return const HeaderErrorTile(message: '센서 정보가 없습니다.');
        }
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: metrics
              .map(
                (EnvironmentMetricViewModel metric) => EnvironmentMetricTile(
                  label: metric.label,
                  value: metric.value,
                  unit: metric.unit,
                ),
              )
              .toList(),
        );
      },
      loading: () => const HeaderLoadingTile(height: 120),
      error: (_, __) => const HeaderErrorTile(message: '센서 데이터를 불러오지 못했습니다.'),
    );
  }
}
