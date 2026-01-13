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

/// 강의실 자동화/환경설정 값을 표현하는 엔티티.
class RoomConfigEntity {
  const RoomConfigEntity({
    this.autoPowerOnTime,
    this.autoPowerOffTime,
    required this.autoPowerOnLecture,
    this.autoStopAfterMinutes,
    this.tempHighThreshold,
    this.tempLowThreshold,
  });

  final String? autoPowerOnTime;
  final String? autoPowerOffTime;
  final bool autoPowerOnLecture;
  final int? autoStopAfterMinutes;
  final double? tempHighThreshold;
  final double? tempLowThreshold;
}
