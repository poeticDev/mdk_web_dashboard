/// ROLE
/// - 도메인 엔티티를 정의한다
///
/// RESPONSIBILITY
/// - 핵심 필드를 보관한다
/// - 도메인 모델을 제공한다
///
/// DEPENDS ON
/// - 없음
library;

/// 강의실 환경 센서 스냅샷 데이터를 표현하는 엔티티.
class ClassroomSensorSnapshot {
  const ClassroomSensorSnapshot({
    required this.temperature,
    required this.humidity,
    // this.pm25,
    this.updatedAt,
  });

  final double temperature;
  final double humidity;
  // final double? pm25;
  final DateTime? updatedAt;

  ClassroomSensorSnapshot copyWith({
    double? temperature,
    double? humidity,
    // double? pm25,
    DateTime? updatedAt,
  }) {
    return ClassroomSensorSnapshot(
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      // pm25: pm25 ?? this.pm25,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
