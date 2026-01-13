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
