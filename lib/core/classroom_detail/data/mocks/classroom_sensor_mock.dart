import 'dart:async';

class ClassroomSensorSnapshot {
  const ClassroomSensorSnapshot({
    required this.temperature,
    required this.humidity,
    this.pm25,
    this.updatedAt,
  });

  final double temperature;
  final double humidity;
  final double? pm25;
  final DateTime? updatedAt;

  ClassroomSensorSnapshot copyWith({
    double? temperature,
    double? humidity,
    double? pm25,
    DateTime? updatedAt,
  }) {
    return ClassroomSensorSnapshot(
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      pm25: pm25 ?? this.pm25,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class ClassroomSensorMockDataSource {
  ClassroomSensorMockDataSource()
      : _snapshot = const ClassroomSensorSnapshot(
          temperature: 23.0,
          humidity: 45.0,
          pm25: 15.0,
          updatedAt: null,
        );

  ClassroomSensorSnapshot _snapshot;
  Timer? _timer;

  ClassroomSensorSnapshot get snapshot => _snapshot;

  void start() {
    _timer ??= Timer.periodic(const Duration(seconds: 10), (_) {
      final double deltaTemp = (_randomDelta());
      final double deltaHumidity = (_randomDelta());
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
