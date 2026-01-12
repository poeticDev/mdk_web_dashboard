/// 서버의 LectureType 문자열을 표현하는 도메인 enum.
enum LectureType {
  lecture('lecture', displayName: '일반 강의'),
  event('event', displayName: '이벤트'),
  exam('exam', displayName: '시험');

  const LectureType(this.apiValue, {required this.displayName});

  final String apiValue;
  final String displayName;

  /// API 문자열을 enum으로 변환한다. 기본값은 `lecture`이다.
  static LectureType fromApi(String value) {
    switch (value.toLowerCase()) {
      case 'event':
        return LectureType.event;
      case 'exam':
        return LectureType.exam;
      default:
        return LectureType.lecture;
    }
  }
}
