import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_dashboard/core/classroom_detail/data/mocks/classroom_sensor_mock.dart';

class EnvironmentMetricViewModel {
  const EnvironmentMetricViewModel({
    required this.id,
    required this.label,
    required this.value,
    required this.unit,
  });

  final String id;
  final String label;
  final String value;
  final String unit;
}

final classroomSensorMockDataSourceProvider =
    Provider.autoDispose.family<ClassroomSensorMockDataSource, String>(
  (Ref ref, String classroomId) {
    final ClassroomSensorMockDataSource dataSource = ClassroomSensorMockDataSource();
    dataSource.start();
    ref.onDispose(dataSource.stop);
    return dataSource;
  },
);

final classroomSensorSnapshotProvider =
    StreamProvider.autoDispose.family<ClassroomSensorSnapshot, String>(
  (Ref ref, String classroomId) async* {
    final ClassroomSensorMockDataSource dataSource =
        ref.watch(classroomSensorMockDataSourceProvider(classroomId));
    yield dataSource.snapshot;
    await for (final _ in Stream.periodic(const Duration(seconds: 5))) {
      yield dataSource.snapshot.copyWith(updatedAt: DateTime.now());
    }
  },
);

final classroomEnvironmentMetricsProvider = Provider.autoDispose
    .family<AsyncValue<List<EnvironmentMetricViewModel>>, String>(
  (Ref ref, String classroomId) {
    final AsyncValue<ClassroomSensorSnapshot> snapshot =
        ref.watch(classroomSensorSnapshotProvider(classroomId));
    return snapshot.whenData(
      (ClassroomSensorSnapshot data) => <EnvironmentMetricViewModel>[
        EnvironmentMetricViewModel(
          id: 'temperature',
          label: '온도',
          value: data.temperature.toStringAsFixed(1),
          unit: '°C',
        ),
        EnvironmentMetricViewModel(
          id: 'humidity',
          label: '습도',
          value: data.humidity.toStringAsFixed(1),
          unit: '%',
        ),
        if (data.pm25 != null)
          EnvironmentMetricViewModel(
            id: 'pm25',
            label: 'PM2.5',
            value: data.pm25!.toStringAsFixed(0),
            unit: 'μg/m³',
          ),
      ],
    );
  },
);
