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
