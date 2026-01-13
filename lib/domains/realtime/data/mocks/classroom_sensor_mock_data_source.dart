import 'dart:async';

import 'package:web_dashboard/domains/realtime/domain/entities/classroom_sensor_snapshot.dart';

/// 더미 센서 데이터를 생성하는 Mock 데이터 소스.
class ClassroomSensorMockDataSource {
  ClassroomSensorMockDataSource()
      : _snapshot = const ClassroomSensorSnapshot(
          temperature: 23.0,
          humidity: 45.0,
          // pm25: 15.0,
          updatedAt: null,
        );

  ClassroomSensorSnapshot _snapshot;
  Timer? _timer;

  ClassroomSensorSnapshot get snapshot => _snapshot;

  void start() {
    _timer ??= Timer.periodic(const Duration(seconds: 10), (_) {
      final double deltaTemp = _randomDelta();
      final double deltaHumidity = _randomDelta();
      _snapshot = _snapshot.copyWith(
        temperature: (_snapshot.temperature + deltaTemp).clamp(20.0, 27.0),
        humidity: (_snapshot.humidity + deltaHumidity).clamp(30.0, 60.0),
        updatedAt: DateTime.now(),
      );
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  double _randomDelta() {
    return (DateTime.now().millisecond % 5 - 2).toDouble() * 0.1;
  }
}
