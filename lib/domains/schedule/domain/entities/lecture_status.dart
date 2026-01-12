/// 강의 일정의 상태(정상/휴강)를 나타내는 enum.
enum LectureStatus {
  scheduled('scheduled'),
  canceled('cancelled');

  const LectureStatus(this.apiValue);

  final String apiValue;

  /// 휴강 여부를 편리하게 확인한다.
  bool get isCanceled => this == LectureStatus.canceled;

  /// API 문자열을 enum으로 변환한다.
  static LectureStatus fromApi(String value) {
    final String normalized = value.toLowerCase();
    if (normalized == 'canceled' || normalized == 'cancelled') {
      return LectureStatus.canceled;
    }
    return LectureStatus.scheduled;
  }
}
